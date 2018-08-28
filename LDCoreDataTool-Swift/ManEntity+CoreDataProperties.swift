//
//  ManEntity+CoreDataProperties.swift
//  LDCoreDataTool2-Swift
//
//  Created by Artron_LQQ on 2017/7/3.
//  Copyright © 2017年 Artup. All rights reserved.
//

import Foundation
import CoreData


extension ManEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManEntity> {
        return NSFetchRequest<ManEntity>(entityName: "ManEntity")
    }

    @NSManaged public var height: Float
    @NSManaged public var name: String?
    @NSManaged public var weight: Float

}
