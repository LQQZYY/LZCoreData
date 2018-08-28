//
//  PeopleEntity+CoreDataProperties.h
//  LDCoreData-OC
//
//  Created by LiuQiqiang on 2018/4/21.
//  Copyright © 2018年 LiuQiqiang. All rights reserved.
//
//

#import "PeopleEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PeopleEntity (CoreDataProperties)

+ (NSFetchRequest<PeopleEntity *> *)fetchRequest;

@property (nonatomic) int16_t age;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) BOOL sex;

@end

NS_ASSUME_NONNULL_END
