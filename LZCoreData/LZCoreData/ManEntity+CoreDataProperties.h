//
//  ManEntity+CoreDataProperties.h
//  LZCoreData
//
//  Created by Artron_LQQ on 16/5/26.
//  Copyright © 2016年 Artup. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ManEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ManEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *height;
@property (nullable, nonatomic, retain) NSNumber *weight;
@property (nullable, nonatomic, retain) PeopleEntity *peopleRelationship;

@end

NS_ASSUME_NONNULL_END
