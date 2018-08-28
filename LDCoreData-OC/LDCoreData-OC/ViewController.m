//
//  ViewController.m
//  LDCoreData-OC
//
//  Created by LiuQiqiang on 2017/7/3.
//  Copyright © 2017年 LiuQiqiang. All rights reserved.
//

#import "ViewController.h"
#import "LQCoreData.h"
#import "PeopleEntity+CoreDataProperties.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ViewController
- (void)batchDeleteThan60 {
    
    NSPredicate *pre = [LQCoreData predicateOfBigThan:60 forProperty:@"age"];
    [LQCoreData batchDeleteEntity:@"PeopleEntity" predicate:pre result:^(NSError *error) {
        NSLog(@"error: %@", error.userInfo);
    }];
}
- (void)batchUpdateZLY {
    NSPredicate *pre = [LQCoreData predicateOfMatch:@"赵丽颖" forProperty:@"name"];
    [LQCoreData batchUpdateEntity:@"PeopleEntity" predicate:pre propertiesToUpdate:@{@"age": @20} result:^(NSError *error) {
        
        NSLog(@"已更新");
    }];
}
- (void)deleteAll {
    [LQCoreData deleteEntity:@"PeopleEntity" predicate:nil result:^(NSArray *deletedObjs) {
        NSLog(@"已删除");
    }];
}
- (void)select50 {
    NSPredicate *pre = [LQCoreData predicateOfSmallThan:50 forProperty:@"age"];
    [LQCoreData fetchEntity:@"PeopleEntity" predicate:pre properties:nil sortKey:nil result:^(NSArray *info) {
        NSLog(@"*********** 查询 age 小于 50 **********");
        for (PeopleEntity *p in info) {
            NSLog(@"name: %@---age: %d", p.name, p.age);
        }
    }];
}
- (void)updateFBB {
    NSLog(@"*********** 更新 **********");
    NSPredicate *pre = [LQCoreData predicateOfMatch:@"范冰冰" forProperty:@"name"];
    [LQCoreData updateEntity:@"PeopleEntity" predicate:pre configNewObj:^(NSArray *objs) {
        for (PeopleEntity *p in objs) {
            p.name = @"哈哈哈";
            p.age = 100;
        }
    } result:^(NSError *error) {
        NSLog(@"%@", error.userInfo);
    }];
}
- (void)delete30 {
    NSLog(@"************** 删除年龄为 30 的 ***********");
    NSPredicate *pre = [LQCoreData predicateOfEqual:30 forProperty:@"age"];
    [LQCoreData deleteEntity:@"PeopleEntity" predicate:pre result:^(NSArray *deletedObjs) {
        for (PeopleEntity *p in deletedObjs) {
            NSLog(@"name: %@---age: %d", p.name, p.age);
        }
    }];
}
- (void)selectZLY {
    NSPredicate *pre = [LQCoreData predicateOfMatch:@"赵丽颖" forProperty:@"name"];
    
    [LQCoreData fetchEntity:@"PeopleEntity" predicate:pre properties:nil sortKey:nil result:^(NSArray *info) {
        NSLog(@"************* 查询赵丽颖 ************");
        for (PeopleEntity *p in info) {
            NSLog(@"name: %@---age: %d", p.name, p.age);
        }
    }];
}

- (void)selectAll {
    
    [LQCoreData fetchEntity:@"PeopleEntity" predicate:nil properties:nil sortKey:nil result:^(NSArray *info) {
        
        for (PeopleEntity *p in info) {
            NSLog(@"name: %@---age: %d", p.name, p.age);
        }
    }];
}
- (void)insert {
    
    NSArray *names = @[@"夏侯惇", @"貂蝉", @"诸葛亮", @"张三", @"李四", @"流火绯瞳", @"流火", @"李白", @"张飞", @"韩信", @"范冰冰", @"赵丽颖"];
    
    for (int i = 0; i < 60; i++) {
        [LQCoreData insertEntity:@"PeopleEntity" configData:^(NSManagedObject *obj) {
            
            PeopleEntity *entity = (PeopleEntity *)obj;
            entity.name = names[i%names.count];
            entity.age = arc4random() % 80 + 20;
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataSource = [NSMutableArray arrayWithObjects:@"插入新数据", @"查询所有数据", @"删除所有数据",  @"删除age为30的, 如果有的话", @"更新所有的范冰冰为 哈哈哈",@"查找age小于50", @"寻找赵丽颖", @"批量更新赵丽颖的年龄为28", @"批量删除age大于60的", nil];
    
    UITableView *table = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
//    LQCoreData *d1 = [[LQCoreData alloc]init];
//    LQCoreData *d2 = [LQCoreData shared];
//    
//    NSLog(@"d1 == %@\nd2 == %@", d1, d2);
//    NSLog(@"%d",d1 == d2);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"dell"];
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            [self insert];
            break;
        case 1:
            [self selectAll];
            break;
            case 2:
            [self deleteAll];
            break;
            case 3:
            [self delete30];
            break;
            case 4:
            [self updateFBB];
            break;
            case 5:
            [self select50];
            break;
            case 6:
            [self selectZLY];
            break;
            case 7:
            [self batchUpdateZLY];
            break;
            case 8:
            [self batchDeleteThan60];
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
