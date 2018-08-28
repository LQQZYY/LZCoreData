//
//  ManEntity+CoreDataProperties.m
//  LDCoreData-OC
//
//  Created by LiuQiqiang on 2018/4/21.
//  Copyright © 2018年 LiuQiqiang. All rights reserved.
//
//

#import "ManEntity+CoreDataProperties.h"

@implementation ManEntity (CoreDataProperties)

+ (NSFetchRequest<ManEntity *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ManEntity"];
}

@dynamic height;
@dynamic name;
@dynamic weight;

@end
