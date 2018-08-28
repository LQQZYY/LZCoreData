//
//  PeopleEntity+CoreDataProperties.swift
//  LDCoreDataTool2-Swift
//
//  Created by Artron_LQQ on 2017/7/3.
//  Copyright © 2017年 Artup. All rights reserved.
//

import Foundation
import CoreData


extension PeopleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PeopleEntity> {
        return NSFetchRequest<PeopleEntity>(entityName: "PeopleEntity")
    }

    @NSManaged public var age: Int16
    @NSManaged public var name: String?
    @NSManaged public var sex: Bool

}
