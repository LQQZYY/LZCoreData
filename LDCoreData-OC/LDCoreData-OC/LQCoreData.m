//
//  LQCoreData.m
//  LDCoreData-OC
//
//  Created by LiuQiqiang on 2018/4/16.
//  Copyright © 2018年 LiuQiqiang. All rights reserved.
//

#import "LQCoreData.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

// 如果项目创建时未勾选CoreData, 将此值改为 0
#define LQCoreDataAuto 1
//static LQCoreData * __coreData = nil;
// .xcdatamodeld 文件名称
static NSString *const LQCoreDataModelName = @"LDCoreData_OC";

@implementation LQCoreData
+ (NSManagedObjectContext *)coreDataContext {
    
#ifdef LQCoreDataAuto
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.persistentContainer.viewContext;
#else
    // 如果是新建的LDCoreDataModel.xcdatamodeld, 则需要手动加载
    NSPersistentContainer *container = [[NSPersistentContainer alloc]initWithName:LQCoreDataModelName];
    [container loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * storeDescription, NSError * error) {
        if (error != nil) {
            NSLog(@"%@", error.userInfo);
        }
    }];
    
    return container.viewContext;
#endif
}

+ (void)saveContext {
    
#ifdef LQCoreDataAuto
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate saveContext];
#else
    NSManagedObjectContext *context = [self coreDataContext];
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
#endif
}

+ (void)insertWithEntity:(NSString *)name configData:(void(^)(NSManagedObject *obj))handle {
    
    NSManagedObjectContext *cxt = [self coreDataContext];
    NSManagedObject *obj = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:cxt];
    handle(obj);
    [self saveContext];
}

+ (void)fetchByEntity:(NSString *)name predicate:(NSPredicate *)pred properties:(NSArray *)pro sortKey:(NSString *)key result:(void(^)(NSArray *objs))block {
    
    NSManagedObjectContext *cxt = [self coreDataContext];
    dispatch_queue_t queue = dispatch_queue_create("LQCoreData_fetchQueue", NULL);
    dispatch_async(queue, ^{
        
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:cxt];
        req.entity = entity;
        req.predicate = pred;
        if (pro) {
            req.propertiesToFetch = pro;
        }
        
        if (key) {
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:key ascending:YES];
            req.sortDescriptors = @[sort];
        }
        
        NSError *error;
        NSArray *rs = [cxt executeFetchRequest:req error:&error];
        if (error == nil) {
            if (block) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(rs);
                });
            }
        } else {
            NSLog(@"%@", error.userInfo);
        }
    });
}

+ (void)deleteByEntity:(NSString *)name predicate:(NSPredicate *)pred result:(void(^)(NSArray *deletedObjs))block {
    
    NSManagedObjectContext *cxt = [self coreDataContext];
    
    NSFetchRequest *req = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:cxt];
    req.entity = entity;
    req.predicate = pred;
    req.includesPropertyValues = NO;
    
    NSError *error;
    NSArray *deleteObjs = [cxt executeFetchRequest:req error:&error];
    if (error == nil) {
        for (NSManagedObject *obj in deleteObjs) {
            [cxt deleteObject:obj];
        }
        
        if (block) {
            block(deleteObjs);
        }
    } else {
        NSLog(@"%@", error.userInfo);
    }
    
    [self saveContext];
}

+ (void)updateWithEntity:(NSString *)name predicate:(NSPredicate *)pred configNewObj:(void(^)(NSArray *objs))objBlock result:(void(^)(NSError *error))rsBlock {
    
    NSManagedObjectContext *cxt = [self coreDataContext];
    NSFetchRequest *req = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:cxt];
    req.entity = entity;
    req.predicate = pred;
    
    NSError *error;
    NSArray *rs = [cxt executeFetchRequest:req error:&error];
    objBlock(rs);
    [self saveContext];
    
    if (rsBlock) {
        rsBlock(error);
    }
}

+ (void)batchDeleteWithEntity:(NSString *)name predicate:(NSPredicate *)pred result:(void(^)(NSError *error))rsBlock {
    
    NSManagedObjectContext *cxt = [self coreDataContext];
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:name];
    req.predicate = pred;
    
    NSBatchDeleteRequest *batchDele = [[NSBatchDeleteRequest alloc]initWithFetchRequest:req];
    batchDele.resultType = NSBatchDeleteResultTypeObjectIDs;
    
    NSError *error;
    NSBatchDeleteResult *result = [cxt executeRequest:batchDele error:&error];
    
    if (result.result) {
        [NSManagedObjectContext mergeChangesFromRemoteContextSave:@{NSDeletedObjectsKey: result.result} intoContexts:@[cxt]];
    }
    
    if (rsBlock) {
        rsBlock(error);
    }
}

+ (void)batchUpdateWithEntity:(NSString *)name predicate:(NSPredicate *)pred propertiesToUpdate:(NSDictionary *)values result:(void(^)(NSError *error))rsBlock {
    
    NSManagedObjectContext *cxt = [self coreDataContext];
    NSBatchUpdateRequest *req = [NSBatchUpdateRequest batchUpdateRequestWithEntityName:name];
    req.predicate = pred;
    req.propertiesToUpdate = values;
    req.resultType = NSUpdatedObjectIDsResultType;
    
    NSError *error;
    NSBatchUpdateResult *rs = [cxt executeRequest:req error:&error];
    if (rs.result) {
        [NSManagedObjectContext mergeChangesFromRemoteContextSave:@{NSUpdatedObjectsKey: rs.result} intoContexts:@[cxt]];
    }
    
    if (rsBlock) {
        rsBlock(error);
    }
}

+ (NSPredicate *)predicateOfLike:(NSString *)value forProperty:(NSString *)key {
    
    return [NSPredicate predicateWithFormat:@"%K LIKE %@", key, value];
}

+ (NSPredicate *)predicateOfMatch:(NSString *)value forProperty:(NSString *)key {
    
    return [NSPredicate predicateWithFormat:@"%K MATCHES %@", key, value];
}

+ (NSPredicate *)predicateOfMatchc:(NSString *)value forProperty:(NSString *)key {
    
    return [NSPredicate predicateWithFormat:@"%K MATCHES[c] %@", key, value];
}

+ (NSPredicate *)predicateOfContain:(NSString *)value forProperty:(NSString *)key {
    
    return [NSPredicate predicateWithFormat:@"%K CONTAINS %@", key, value];
}

+ (NSPredicate *)predicateOfEqual:(NSInteger)value forProperty:(NSString *)key {
    
    return [NSPredicate predicateWithFormat:@"%K == %d", key, value];
}

+ (NSPredicate *)predicateOfBigThan:(NSInteger)value forProperty:(NSString *)key {
    
    return [NSPredicate predicateWithFormat:@"%K > %d", key, value];
}

+ (NSPredicate *)predicateOfSmallThan:(NSInteger)value forProperty:(NSString *)key {
    
    return [NSPredicate predicateWithFormat:@"%K < %d", key, value];
}

+ (NSPredicate *)predicateOfNotSmallThan:(NSInteger)value forProperty:(NSString *)key {
    
    return [NSPredicate predicateWithFormat:@"%K >= %d", key, value];
}

+ (NSPredicate *)predicateOfNotBigThan:(NSInteger)value forProperty:(NSString *)key {
    
    return [NSPredicate predicateWithFormat:@"%K LIKE %@", key, value];
}
@end
