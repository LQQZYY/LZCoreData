//
//  LQCoreData.swift
//  LDCoreDataTool2-Swift
//
//  Created by LiuQiqiang on 2018/8/28.
//  Copyright © 2018年 LiuQiqiang. All rights reserved.
//
// Github: https://github.com/LQi2009/LDCoreDataTool-Swift

import UIKit
import CoreData

fileprivate let LQCoreDataModelName = "LDCoreDataModel"
class LQCoreData {

    private static var context: NSManagedObjectContext = {
        // 如果是新建项目时启用了Core Data, 则可使用AppDelegate中的context
        // 即
        //        let delegate = UIApplication.shared.delegate as! AppDelegate
        //        let context = delegate.persistentContainer.viewContext
        //
        //        return context
        
        // 如果是新建的LDCoreDataModel.xcdatamodeld, 则需要手动加载
        let container = NSPersistentContainer(name: LQCoreDataModelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container.viewContext
    }()
    
    private class func saveContext(_ resuleHandler: ((_ error: NSError?) -> Void)? = nil) {
        
        if context.hasChanges {
            do {
                try context.save()
                if let handler = resuleHandler {
                    handler(nil)
                }
            } catch {
                let nserror = error as NSError
                if let handler = resuleHandler {
                    handler(nserror)
                }
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    /// 增
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - handler: 配置待保存数据回调
    ///   - rs: 保存结果回调
    class func insert(entity name: String, configHandler handler: ((_ obj: NSManagedObject) -> Void), resulteHandler rs: ((_ error: NSError? ) -> Void)? = nil) {
        
        let obj = NSEntityDescription.insertNewObject(forEntityName: name, into: context)
        
        handler(obj)
        
        saveContext(rs)
    }
    
    /// 查
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - predicate: 查询条件-谓词
    ///   - propertiesToFetch: 查询的属性, 默认所有属性
    ///   - key: 查询结果排序的依据属性, 升序
    ///   - result: 查询结果回调
    class func fetch(entity name: String, predicate: NSPredicate? = nil, propertiesToFetch: Array<Any>? = nil, resultSortKey key: String? = nil, resultHandler rs: @escaping ((_ info: Array<Any>?) -> Void)) {
        
        let queue = DispatchQueue(label: "fetchQueue")
        queue.async {
            let fetchReq = NSFetchRequest<NSFetchRequestResult>()
            let entity = NSEntityDescription.entity(forEntityName: name, in: context)
            
            fetchReq.entity = entity
            fetchReq.predicate = predicate// 设置查询条件
            fetchReq.propertiesToFetch = propertiesToFetch// 设置查询属性, 默认查询全部
            if let key = key {
                let sort = NSSortDescriptor(key: key, ascending: true)
                fetchReq.sortDescriptors = [sort]
            }
            
            let fetchObjs = try? context.fetch(fetchReq)
            
            DispatchQueue.main.async {
                rs(fetchObjs)
            }
        }
    }
    
    /// 删
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - predicate: 删除条件
    ///   - result: 删除结果回调
    class func delete(entity name: String, predicate: NSPredicate? = nil, resultHandler rs: ((_ error: NSError?, _ deletedObjs: Array<Any>?) -> Void)? = nil) {
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)
        
        fetchReq.entity = entity
        fetchReq.predicate = predicate // 设置查询条件
        fetchReq.includesPropertyValues = false
        
        do {
            let fetchedObjs = try context.fetch(fetchReq)
            
            for obj in fetchedObjs {
                context.delete(obj as! NSManagedObject)
            }
            
            try context.save()
            
            if let rs = rs {
                rs(nil, fetchedObjs)
            }
            
        } catch let error {
            if let rs = rs {
                rs(error as NSError, nil)
            }
        }
    }
    
    /// 改
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - predicate: 查询条件
    ///   - handler: 更新数据的回调
    ///   - result: 更新结果的回调
    class func update(withEntityName name: String, predicate: NSPredicate, configNewValues handler: ((_ objs: Array<Any>) -> Void), result: ((_ error: NSError?) -> Void)? = nil) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)
        
        fetchRequest.entity = entity
        fetchRequest.predicate = predicate // 设置查询条件
        
        do {
            let fetchedObjs = try context.fetch(fetchRequest)
            
            // 修改数据
            handler(fetchedObjs)
            
            try context.save()
            
            if let rs = result {
                rs(nil)
            }
        } catch let error {
            if let rs = result {
                rs(error as NSError)
            }
        }
    }
    
    //MARK: - 批量操作
    
    /// 批量删除操作
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - predicate: 查找条件
    ///   - handle: 结果回调
    class func batchDelete(entity name: String, predicate: NSPredicate, resultHandler handler: ((_ error: NSError?) -> Void)? = nil) {
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        fetchReq.predicate = predicate
        
        let batchDelete = NSBatchDeleteRequest(fetchRequest: fetchReq)
        batchDelete.resultType = .resultTypeObjectIDs
        
        do {
            let result = try context.execute(batchDelete)
            
            if let rs = result as? NSBatchDeleteResult {
                if let ids = rs.result as? Array<Any> {
                    // 告诉当前context, 数据库有变化了
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: ids], into: [context])
                }
            }
            
            if let hand = handler {
                hand(nil)
            }
        } catch let error {
            
            if let hand = handler {
                hand(error as NSError)
            }
        }
    }
    
    /// 批量更新
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - predicate: 查询条件
    ///   - values: 更新的值, 字典; key: 待更新属性名称, value: 更新的值
    ///   - handle: 更新结果回调
    class func batchUpdate(entity name: String, predicate: NSPredicate, propertiesToUpdate values: Dictionary<String, Any>, resultHandler handler: ((_ error: NSError?) -> Void)? = nil) {
        
        let updateReq = NSBatchUpdateRequest(entityName: name)
        updateReq.predicate = predicate
        updateReq.propertiesToUpdate = values
        updateReq.resultType = .updatedObjectIDsResultType
        
        do {
            let result = try context.execute(updateReq)
            
            if let rs = result as? NSBatchUpdateResult {
                if let ids = rs.result as? Array<NSManagedObjectID> {
                    
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSUpdatedObjectsKey: ids], into: [context])
                }
            }
            
            if let hand = handler {
                
                hand(nil)
            }
        } catch let error {
            
            if let hand = handler {
                hand(error as NSError)
            }
        }
    }
}

// MARK: - 预设的谓词查询条件 NSPredicate
enum LQPredicateType {
    
    case like(string: String, forProperty: String)
    case match(string: String, forProperty: String)
    case matchc(string: String, forProperty: String)
    case contain(string: String, forProperty: String)
    
    case equalTo(number: Int64, forProperty: String)
    case bigThan(number: Int64, forProperty: String)
    case smallThan(number: Int64, forProperty: String)
    
    case notBigThan(number: Int64, forProperty: String)
    case notSmallThan(number: Int64, forProperty: String)
}

extension LQCoreData {
    
    class func predicate(_ type: LQPredicateType) -> NSPredicate {
        
        switch type {
        case let .like(value, key):// 将let写到前面也可以
            return NSPredicate(format: "%K LIKE %@", key, value)
        case .match(let value, let key):
            return NSPredicate(format: "%K MATCHES %@", key, value)
        case .matchc(let value, let key):
            return NSPredicate(format: "%K MATCHES[c] %@", key, value)
        case .contain(let value, let key):
            return NSPredicate(format: "%K CONTAINS %@", key, value)
        case .equalTo(let value, let key):
            return NSPredicate(format: "%K == \(value)", key)
        case .bigThan(let value, let key):
            return NSPredicate(format: "%K > \(value)", key)
        case .smallThan(let value, let key):
            return NSPredicate(format: "%K < \(value)", key)
        case .notSmallThan(let value, let key):
            return NSPredicate(format: "%K >= \(value)", key)
        case .notBigThan(let value, let key):
            return NSPredicate(format: "%K <= \(value)", key)
        }
    }
}
