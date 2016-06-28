//
//  PeopleEntity+CoreDataProperties.h
//  LZCoreData
//
//  Created by Artron_LQQ on 16/5/26.
//  Copyright © 2016年 Artup. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PeopleEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface PeopleEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSNumber *sex;
@property (nullable, nonatomic, retain) ManEntity *manRelationship;

@end

NS_ASSUME_NONNULL_END
