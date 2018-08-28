//
//  LQCoreData.h
//  LDCoreData-OC
//
//  Created by LiuQiqiang on 2018/4/16.
//  Copyright © 2018年 LiuQiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObject;
@interface LQCoreData : NSObject

/**
 插入新的数据

 @param name 实体名称
 @param handle 配置对应的实体实例数据
 */
+ (void)insertWithEntity:(NSString *)name configData:(void(^)(NSManagedObject *obj))handle;

/**
 查找某个实体数据

 @param name 实体名称
 @param pred 查找条件(谓词)
 @param pro 查找的属性字段, 传nil则查询所有的属性
 @param key 排序依据, 以某个属性的值进行排序
 @param block 查询结果回调
 */
+ (void)fetchByEntity:(NSString *)name predicate:(NSPredicate *)pred properties:(NSArray *)pro sortKey:(NSString *)key result:(void(^)(NSArray *objs))block;

/**
 删除某个实体的一条数据

 @param name 实体名称
 @param pred 查询条件(谓词)
 @param block 删除的实体对象
 */
+ (void)deleteByEntity:(NSString *)name predicate:(NSPredicate *)pred result:(void(^)(NSArray *deletedObjs))block;

/**
 更新实体的数据

 @param name 实体名称
 @param pred 查询条件(谓词)
 @param objBlock 配置更新的数据
 @param rsBlock 结果回调
 */
+ (void)updateWithEntity:(NSString *)name predicate:(NSPredicate *)pred configNewObj:(void(^)(NSArray *objs))objBlock result:(void(^)(NSError *error))rsBlock;

/**
 批量删除某个实体数据

 @param name 实体名称
 @param pred 查询条件(谓词)
 @param rsBlock 结果回调
 */
+ (void)batchDeleteWithEntity:(NSString *)name predicate:(NSPredicate *)pred result:(void(^)(NSError *error))rsBlock;

/**
 批量更新某个实体数据

 @param name 实体名称
 @param pred 查询条件(谓词)
 @param values 更新的数据
 @param rsBlock 结果回调
 */
+ (void)batchUpdateWithEntity:(NSString *)name predicate:(NSPredicate *)pred propertiesToUpdate:(NSDictionary *)values result:(void(^)(NSError *error))rsBlock;

#pragma 预设的谓词查找条件
+ (NSPredicate *)predicateOfLike:(NSString *)value forProperty:(NSString *)key;
+ (NSPredicate *)predicateOfMatch:(NSString *)value forProperty:(NSString *)key;
+ (NSPredicate *)predicateOfMatchc:(NSString *)value forProperty:(NSString *)key;
+ (NSPredicate *)predicateOfContain:(NSString *)value forProperty:(NSString *)key;
+ (NSPredicate *)predicateOfEqual:(NSInteger)value forProperty:(NSString *)key;
+ (NSPredicate *)predicateOfBigThan:(NSInteger)value forProperty:(NSString *)key;
+ (NSPredicate *)predicateOfSmallThan:(NSInteger)value forProperty:(NSString *)key;
+ (NSPredicate *)predicateOfNotSmallThan:(NSInteger)value forProperty:(NSString *)key;
+ (NSPredicate *)predicateOfNotBigThan:(NSInteger)value forProperty:(NSString *)key;
@end
