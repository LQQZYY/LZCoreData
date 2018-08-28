//
//  ManEntity+CoreDataProperties.h
//  LDCoreData-OC
//
//  Created by LiuQiqiang on 2018/4/21.
//  Copyright © 2018年 LiuQiqiang. All rights reserved.
//
//

#import "ManEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ManEntity (CoreDataProperties)

+ (NSFetchRequest<ManEntity *> *)fetchRequest;

@property (nonatomic) float height;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) float weight;

@end

NS_ASSUME_NONNULL_END
