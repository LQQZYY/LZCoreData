//
//  LDCoreData.swift
//  LDCoreData2-Swift
//
//  Created by Artron_LQQ on 2017/7/3.
//  Copyright © 2017年 Artup. All rights reserved.
//
// Github: https://github.com/LQi2009/LDCoreDataTool-Swift

import UIKit
import CoreData

fileprivate let LQCoreDataModelName = "LDCoreDataModel"

// MARK: - base Class: properties AND base function
class LQCoreData {
    
    static var shared: LQCoreData = LQCoreData()
    private init() {}
    
    lazy var context: NSManagedObjectContext = {
        
        // r如果是新建项目时启用了Core Data, 则可使用AppDelegate中的context
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
    
    func saveContext(_ resuleHandle: ((_ error: NSError?) -> Void)? = nil) {
        
        if context.hasChanges {
            do {
                try context.save()
                if let handle = resuleHandle {
                    handle(nil)
                }
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                
                if let handle = resuleHandle {
                    handle(nserror)
                }
                
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
// Public Method
// MARK: - LQCoreData public class methods
extension LQCoreData {
    
    /// 增
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - handle: 配置待保存数据回调
    ///   - rs: 保存结果回调
    class func insert(withEntityName name: String, configDataHandle handle: ((_ obj: NSManagedObject) -> Void), result rs: ((_ error: NSError? ) -> Void)? = nil) {
        
        LQCoreData.shared.insert(withEntityName: name, configDataHandle: handle, result: rs)
    }
    
    /// 查
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - predicate: 查询条件-谓词
    ///   - propertiesToFetch: 查询的属性, 默认所有属性
    ///   - key: 查询结果排序的依据属性, 升序
    ///   - result: 查询结果回调
    class func fetch(withEntityName name: String, predicate: NSPredicate? = nil, propertiesToFetch: Array<Any>? = nil, resultSortKey key: String? = nil, result: @escaping ((_ info: Array<Any>?) -> Void)) {
        
        LQCoreData.shared.fetch(withEntityName: name, predicate: predicate, propertiesToFetch: propertiesToFetch, resultSortKey: key, result: result)
    }
    
    /// 删
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - predicate: 删除条件
    ///   - result: 删除结果回调
    class func delete(withEntityName name: String, predicate: NSPredicate? = nil, result: ((_ error: NSError?, _ deletedObjs: Array<Any>?) -> Void)? = nil) {
        
        LQCoreData.shared.delete(withEntityName: name, predicate: predicate, result: result)
    }
    
    /// 改
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - predicate: 查询条件
    ///   - handle: 更新数据的回调
    ///   - result: 更新结果的回调
    class func update(withEntityName name: String, predicate: NSPredicate, configNewValues handle: ((_ objs: Array<Any>) -> Void), result: ((_ error: NSError?) -> Void)? = nil) {
        
        LQCoreData.shared.update(withEntityName: name, predicate: predicate, configNewValues: handle, result: result)
    }
    
    //MARK: - 批量操作
    
    /// 批量删除操作
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - predicate: 查找条件
    ///   - handle: 结果回调
    class func batchDelete(withEntityName name: String, predicate: NSPredicate, resultHandle handle: ((_ error: NSError?) -> Void)? = nil) {
        
        LQCoreData.shared.batchDelete(withEntityName: name, predicate: predicate, resultHandle: handle)
    }
    
    /// 批量更新
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - predicate: 查询条件
    ///   - values: 更新的值, 字典; key: 待更新属性名称, value: 更新的值
    ///   - handle: 更新结果回调
    class func batchUpdate(withEntityName name: String, predicate: NSPredicate, propertiesToUpdate values: Dictionary<String, Any>, resultHandle handle: ((_ error: NSError?) -> Void)? = nil) {
        
        LQCoreData.shared.batchUpdate(withEntityName: name, predicate: predicate, propertiesToUpdate: values, resultHandle: handle)
    }
}

// MARK: - LQCoreData base methods: insert, delete, update, fetch
extension LQCoreData {
    
    /// 增
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - handle: 配置待保存数据回调
    ///   - rs: 结果回调
    fileprivate func insert(withEntityName name: String, configDataHandle handle: ((_ obj: NSManagedObject) -> Void), result rs: ((_ error: NSError? ) -> Void)? = nil) {
        
        let obj = NSEntityDescription.insertNewObject(forEntityName: name, into: LQCoreData.shared.context)
        
        handle(obj)
        
        LQCoreData.shared.saveContext(rs)
    }
    
    /// 查
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - predicate: 查询条件
    ///   - propertiesToFetch: 查询的属性, 默认所有属性
    ///   - key: 查询结果排序的依据属性, 升序
    ///   - result: 查询结果回调
    fileprivate func fetch(withEntityName name: String, predicate: NSPredicate? = nil, propertiesToFetch: Array<Any>? = nil, resultSortKey key: String? = nil, result: @escaping ((_ info: Array<Any>?) -> Void)) {
        // 异步查询
        let queue = DispatchQueue(label: "fetchQueue")
        queue.async {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            
            let entity = NSEntityDescription.entity(forEntityName: name, in: LQCoreData.shared.context)
            
            fetchRequest.entity = entity
            fetchRequest.predicate = predicate // 设置查询条件
            fetchRequest.propertiesToFetch = propertiesToFetch // 设置查询属性, 默认查询全部
            
            if let key = key {
                
                let sort = NSSortDescriptor(key: key, ascending: true)
                fetchRequest.sortDescriptors = [sort]
            }
            
            let fetchedObjs = try? LQCoreData.shared.context.fetch(fetchRequest)
            
            guard let objs = fetchedObjs else {
                
                DispatchQueue.main.async {
                    result(nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                result(objs)
            }
        }
    }
    
    /// 删
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - predicate: 删除条件
    ///   - result: 删除结果回调
    fileprivate func delete(withEntityName name: String, predicate: NSPredicate? = nil, result: ((_ error: NSError?, _ deletedObjs: Array<Any>?) -> Void)? = nil) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: name, in: LQCoreData.shared.context)
        
        fetchRequest.entity = entity
        fetchRequest.predicate = predicate // 设置查询条件
        fetchRequest.includesPropertyValues = false
        
        do {
            let fetchedObjs = try LQCoreData.shared.context.fetch(fetchRequest)
            
            for obj in fetchedObjs {
                LQCoreData.shared.context.delete(obj as! NSManagedObject)
            }
            
            try LQCoreData.shared.context.save()
            
            if let rs = result {
                rs(nil, fetchedObjs)
            }
            
        } catch let error {
            if let rs = result {
                rs(error as NSError, nil)
            }
        }
    }
    
    // 改
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - predicate: 查询条件
    ///   - handle: 更新数据的回调
    ///   - result: 更新结果的回调
    fileprivate func update(withEntityName name: String, predicate: NSPredicate, configNewValues handle: ((_ objs: Array<Any>) -> Void), result: ((_ error: NSError?) -> Void)? = nil) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: name, in: LQCoreData.shared.context)
        
        fetchRequest.entity = entity
        fetchRequest.predicate = predicate // 设置查询条件
        
        do {
            let fetchedObjs = try LQCoreData.shared.context.fetch(fetchRequest)
            
            // 修改数据
            handle(fetchedObjs)
            
            try LQCoreData.shared.context.save()
            
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
    fileprivate func batchDelete(withEntityName name: String, predicate: NSPredicate, resultHandle handle: ((_ error: NSError?) -> Void)? = nil) {
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        fetchReq.predicate = predicate
        
        let batchDelete = NSBatchDeleteRequest(fetchRequest: fetchReq)
        batchDelete.resultType = .resultTypeObjectIDs
        
        do {
            let result = try LQCoreData.shared.context.execute(batchDelete)
            
            if let rs = result as? NSBatchDeleteResult {
                if let ids = rs.result as? Array<Any> {
                    // 告诉当前context, 数据库有变化了
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: ids], into: [LQCoreData.shared.context])
                }
            }
            
            if let hand = handle {
                hand(nil)
            }
        } catch let error {
            
            if let hand = handle {
                hand(error as NSError)
            }
        }
        
        
    }
    
    /// 批量更新操作, 只能更新为同样的东西
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - predicate: 查询条件
    ///   - values: 需要更新的属性及其值
    ///   - handle: 结果回调
    fileprivate func batchUpdate(withEntityName name: String, predicate: NSPredicate, propertiesToUpdate values: Dictionary<String, Any>, resultHandle handle: ((_ error: NSError?) -> Void)? = nil) {
        
        let updateReq = NSBatchUpdateRequest(entityName: name)
        updateReq.predicate = predicate
        updateReq.propertiesToUpdate = values
        updateReq.resultType = .updatedObjectIDsResultType
        
        do {
            let result = try LQCoreData.shared.context.execute(updateReq)
            
            if let rs = result as? NSBatchUpdateResult {
                if let ids = rs.result as? Array<NSManagedObjectID> {
                    
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSUpdatedObjectsKey: ids], into: [LQCoreData.shared.context])
                }
            }
            
            if let hand = handle {
                
                hand(nil)
            }
        } catch let error {
            
            if let hand = handle {
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

