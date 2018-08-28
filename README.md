# LQCoreData
对Core Data增删改查的封装，同时提供了Swift版本与Objective-C版本，两个版本的使用方法一致，Demo中提供了增删改查的使用示例。

##### 增
```
/// 增
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - handler: 配置待保存数据回调
    ///   - rs: 保存结果回调
    class func insert(entity name: String, configHandler handler: ((_ obj: NSManagedObject) -> Void), resulteHandler rs: ((_ error: NSError? ) -> Void)? = nil)
```
这里主要说一下configHandler，其参数为**NSManagedObject**，为了提高复用性，在封装的方法中没有涉及到具体的entity，该回调方法就是供外部对具体entity进行赋值的入口，使用示例：
```
let names = ["夏侯惇", "貂蝉", "诸葛亮", "张三", "李四", "流火绯瞳", "流火", "李白", "张飞", "韩信", "范冰冰", "赵丽颖"]
        
        for i in 0...60 {
            
            LQCoreData.insert(entity: "PeopleEntity", configHandler: { (obj) in
                // 将回调的obj转换为具体的实体进行赋值
                let people = obj as! PeopleEntity
                people.name = names[i%names.count]
                people.age = Int16(arc4random() % 80 + UInt32(10))
                
            }, resulteHandler: { (error) in
                if let err = error {
                    print("保存失败\(err)")
                } else {
                    print("保存成功")
                }
            })
        }
```

##### 删
提供了两种删除方法，单独删除和批量删除：
```
/// 删
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - predicate: 删除条件
    ///   - result: 删除结果回调
    class func delete(entity name: String, predicate: NSPredicate? = nil, resultHandler rs: ((_ error: NSError?, _ deletedObjs: Array<Any>?) -> Void)? = nil)
    
/// 批量删除操作
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - predicate: 查找条件
    ///   - handle: 结果回调
    class func batchDelete(entity name: String, predicate: NSPredicate, resultHandler handler: ((_ error: NSError?) -> Void)? = nil)
```
使用示例，删除年龄为30的：
```
let pre1 = LQCoreData.predicate(.equalTo(number: 30, forProperty: "age"))
        
        LQCoreData.delete(entity: "PeopleEntity", predicate: pre1) { (error, info) in
            if let err = error {
                print("err: \(err)")
            } else {
                print("所有年龄为30的已删除")
            }
        }
```

##### 改
更新数据也是提供了两种方法，单个更新和批量更新：
```
/// 改
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - predicate: 查询条件
    ///   - handler: 更新数据的回调
    ///   - result: 更新结果的回调
    class func update(withEntityName name: String, predicate: NSPredicate, configNewValues handler: ((_ objs: Array<Any>) -> Void), result: ((_ error: NSError?) -> Void)? = nil)
    
/// 批量更新
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - predicate: 查询条件
    ///   - values: 更新的值, 字典; key: 待更新属性名称, value: 更新的值
    ///   - handle: 更新结果回调
    class func batchUpdate(entity name: String, predicate: NSPredicate, propertiesToUpdate values: Dictionary<String, Any>, resultHandler handler: ((_ error: NSError?) -> Void)? = nil)
```

例如，将所有的范冰冰，名称更新为哈哈哈：
```
let pre2 = LQCoreData.predicate(.match(string: "范冰冰", forProperty: "name"))
        
        LQCoreData.update(withEntityName: "PeopleEntity", predicate: pre2, configNewValues: { (datas) in
            
            for data in datas {
                let people = data as! PeopleEntity
                people.name = "哈哈哈哈"
                people.age = 100
            }
        }) { (error) in
            
            if let err = error {
                
                print("err: \(err)")
            } else {
                print("已更新")
            }
        }
```

##### 查
```
/// 查
    ///
    /// - Parameters:
    ///   - name: 实体(Entity)名称
    ///   - predicate: 查询条件-谓词
    ///   - propertiesToFetch: 查询的属性, 默认所有属性
    ///   - key: 查询结果排序的依据属性, 升序
    ///   - result: 查询结果回调
    class func fetch(entity name: String, predicate: NSPredicate? = nil, propertiesToFetch: Array<Any>? = nil, resultSortKey key: String? = nil, resultHandler rs: @escaping ((_ info: Array<Any>?) -> Void))
```

例如，查找年龄小于50的：
```
let pre = LQCoreData.predicate(.smallThan(number: 50, forProperty: "age"))
        
        LQCoreData.fetch(entity: "PeopleEntity", predicate: pre) { (results) in
            print("**************************查询age小于50*******************************")
            if let rs = results {
                for info in rs {
                    let people = info as! PeopleEntity
                    print("name: \(people.name ?? " ") ----age: \(people.age)")
                }
            } else {
                print("查询失败")
            }
        }
```

##### 条件谓词
另外单独封装了几个常用的条件谓词，可以直接调用相应的方法即可：
```
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
```

## 更多内容可参考本人博客

##### [[iOS]Core Data浅析一 -- 启用Core Data](http://www.jianshu.com/p/a6d2c35d3983)

##### [[iOS]Core Data浅析二 -- 转换实体(Entity)为模型对象](http://www.jianshu.com/p/7a8e3cad6181)

##### [[iOS]Core Data浅析三 --  数据的增删改查](http://www.jianshu.com/p/3e5dbc491677)

以及一个, 在新版Xcode中使用的注意事项:

##### [[Core Data]Xcode 8+ 新建NSManageObject subclass方法](http://www.jianshu.com/p/b3c734ba7181)
