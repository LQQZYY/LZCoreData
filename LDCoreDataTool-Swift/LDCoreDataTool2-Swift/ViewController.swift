//
//  ViewController.swift
//  LQCoreData2-Swift
//
//  Created by Artron_LQQ on 2017/7/3.
//  Copyright © 2017年 Artup. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dataArray = ["插入新数据", "查询所有数据", "删除所有数据",  "删除age为20的, 如果有的话", "更新所有的范冰冰为 哈哈哈","查找age小于50", "寻找赵丽颖", "批量更新赵丽颖的年龄为28", "批量删除age大于60的"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let table = UITableView(frame: self.view.bounds, style: .plain)
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
        
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100)
        label.backgroundColor = UIColor.black
        label.textColor = UIColor.white
        label.text = "CoreData操作测试\n\n结果请在控制台查看"
        label.numberOfLines = 0
        label.textAlignment = .center
        table.tableHeaderView = label
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            self.insertNew()
        case 1:
            self.selectAll()
        case 2:
            self.deleteAll()
        case 3:
            self.delete20()
        case 4:
            self.updateFBB()
        case 5:
            self.selete50()
        case 6:
            self.selectZLY()
        case 7:
            self.batchUpdateZLY()
        case 8:
            self.batchDeleteThan60()
        default:
            print("--------")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
        }
        
        cell?.textLabel?.text = dataArray[indexPath.row]
        
        return cell!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNew() {
        
        let names = ["夏侯惇", "貂蝉", "诸葛亮", "张三", "李四", "流火绯瞳", "流火", "李白", "张飞", "韩信", "范冰冰", "赵丽颖"]
        
        for i in 0...60 {
            
            LQCoreData.insert(entity: "PeopleEntity", configHandler: { (obj) in
                
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
    }
    
    func selectAll() {
        LQCoreData.fetch(entity: "PeopleEntity", predicate: nil) { (results) in
            print("**************************查询所有*******************************")
            if let rs = results {
                for info in rs {
                    let people = info as! PeopleEntity
                    print("name: \(people.name ?? " ") ----age: \(people.age)")
                }
            } else {
                print("查询失败")
            }
        }
    }
    
    func selectZLY() {
        
        //        let pre = LQCoreData.equalString(propertyName: "name", to: "赵丽颖")
        let pre = LQCoreData.predicate(.match(string: "赵丽颖", forProperty: "name"))
        
        LQCoreData.fetch(entity: "PeopleEntity", predicate: pre) { (results) in
            print("**************************查询赵丽颖*******************************")
            if let rs = results {
                for info in rs {
                    let people = info as! PeopleEntity
                    print("name: \(people.name ?? " ") ----age: \(people.age)")
                }
            } else {
                print("查询失败")
            }
        }
        
    }
    
    func delete20()  {
        
        print("*************************删除年龄为30*******************************")
        
        let pre1 = LQCoreData.predicate(.equalTo(number: 30, forProperty: "age"))
        
        LQCoreData.delete(entity: "PeopleEntity", predicate: pre1) { (error, info) in
            if let err = error {
                print("err: \(err)")
            } else {
                print("所有年龄为30的已删除")
            }
        }
    }
    
    func updateFBB() {
        
        print("**************************更新*******************************")
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
    }
    
    func selete50() {
        
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
    }
    
    func deleteAll() {
        
        LQCoreData.delete(entity: "PeopleEntity", predicate: nil) { (error, objs) in
            if let err = error {
                print("err: \(err)")
            } else {
                print("所有数据已删除")
            }
        }
    }
    
    func batchUpdateZLY() {
        let pre = LQCoreData.predicate(.match(string: "赵丽颖", forProperty: "name"))
        
        LQCoreData.batchUpdate(entity: "PeopleEntity", predicate: pre, propertiesToUpdate: ["age": 28]) { (error) in
            if let err = error {
                print("err: \(err)")
            } else {
                print("赵丽颖年龄已更正")
            }
        }
    }
    
    func batchDeleteThan60() {
        
        let pre = LQCoreData.predicate(.bigThan(number: 60, forProperty: "age"))
        
        LQCoreData.batchDelete(entity: "PeopleEntity", predicate: pre) { (error) in
            if let err = error {
                print("err: \(err)")
            } else {
                print("大于60的已批量删除")
            }
        }
    }
}

