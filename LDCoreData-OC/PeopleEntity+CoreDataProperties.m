//
//  PeopleEntity+CoreDataProperties.m
//  LDCoreData-OC
//
//  Created by LiuQiqiang on 2018/4/21.
//  Copyright © 2018年 LiuQiqiang. All rights reserved.
//
//

#import "PeopleEntity+CoreDataProperties.h"

@implementation PeopleEntity (CoreDataProperties)

+ (NSFetchRequest<PeopleEntity *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"PeopleEntity"];
}

@dynamic age;
@dynamic name;
@dynamic sex;

@end
