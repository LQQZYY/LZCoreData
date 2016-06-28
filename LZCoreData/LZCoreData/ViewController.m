//
//  ViewController.m
//  LZCoreData
//
//  Created by Artron_LQQ on 16/5/26.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "PeopleEntity+CoreDataProperties.h"
#import "ManEntity+CoreDataProperties.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self test2];
    
}

- (void)test1 {
    //获取代理
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    //获取context
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    //获取PeopleEntity实体
    NSManagedObject *people = [NSEntityDescription insertNewObjectForEntityForName:@"PeopleEntity" inManagedObjectContext:context];
    
    //设置属性内容
    [people setValue:@"流火绯瞳" forKey:@"name"];
    [people setValue:@26 forKey:@"age"];
    [people setValue:@0 forKey:@"sex"];
    
    //获取ManEntit实体
    NSManagedObject *man = [NSEntityDescription insertNewObjectForEntityForName:@"ManEntity" inManagedObjectContext:context];
    
    [man setValue:@178.0 forKey:@"height"];
    [man setValue:@60.0 forKey:@"weight"];
    [man setValue:@"张三" forKey:@"name"];
    [man setValue:people forKey:@"peopleRelationship"];
    
    [people setValue:man forKey:@"manRelationship"];
    
    NSError *error;
    //保存更改
    if ([context save:&error]) {
        NSLog(@"保存成功");
    } else {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    //查询实体
    //创建一个查询请求
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //获取要查询的实体
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"PeopleEntity" inManagedObjectContext:context];
    //添加到查询请求
    [fetchRequest setEntity:entity];
    //开始查询并获取结果
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSLog(@"输出查询结果");
    for (NSManagedObject *info in fetchedObjects) {
        
        NSLog(@"Name: %@", [info valueForKey:@"name"]);
        NSLog(@"age: %@", [info valueForKey:@"age"]);
        NSLog(@"sex: %@", [info valueForKey:@"sex"]);
        NSLog(@"-----------------------------------");
        
        NSManagedObject *man1 = [info valueForKey:@"manRelationship"];
        NSLog(@"Name: %@", [man1 valueForKey:@"name"]);
        NSLog(@"weight: %@", [man1 valueForKey:@"weight"]);
        NSLog(@"height: %@", [man1 valueForKey:@"height"]);
        NSLog(@"==========================================");
    }

}

- (void)test2 {
    //获取代理
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    //获取context
    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    //获取PeopleEntity实体
    //这里修改为PeopleEntity类型
    PeopleEntity *people = [NSEntityDescription insertNewObjectForEntityForName:@"PeopleEntity" inManagedObjectContext:context];
    
    //设置属性内容
    people.name = @"流火绯瞳";
    people.age = @27;
    people.sex = @0;
//    [people setValue:@"流火绯瞳" forKey:@"name"];
//    [people setValue:@26 forKey:@"age"];
//    [people setValue:@0 forKey:@"sex"];
    
    //获取ManEntit实体
    //这里修改为ManEntity类型
    ManEntity *man = [NSEntityDescription insertNewObjectForEntityForName:@"ManEntity" inManagedObjectContext:context];
    
    man.height = @178.0;
    man.weight = @60.0;
    man.name = @"张三丰";
    man.peopleRelationship = people;
    
//    [man setValue:@178.0 forKey:@"height"];
//    [man setValue:@60.0 forKey:@"weight"];
//    [man setValue:@"张三" forKey:@"name"];
//    [man setValue:people forKey:@"peopleRelationship"];
//    
//    [people setValue:man forKey:@"manRelationship"];
    
    people.manRelationship = man;
    
    NSError *error;
    //保存更改
    if ([context save:&error]) {
        NSLog(@"保存成功");
    } else {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    //查询实体
    //创建一个查询请求
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //获取要查询的实体
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"PeopleEntity" inManagedObjectContext:context];
    //添加到查询请求
    [fetchRequest setEntity:entity];
    //开始查询并获取结果
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSLog(@"输出查询结果");
    for (PeopleEntity *info in fetchedObjects) {
        
        NSLog(@"Name: %@", info.name);
        NSLog(@"age: %@", info.age);
        NSLog(@"sex: %@", info.sex);
        NSLog(@"-----------------------------------");

        
//        NSLog(@"Name: %@", [info valueForKey:@"name"]);
//        NSLog(@"age: %@", [info valueForKey:@"age"]);
//        NSLog(@"sex: %@", [info valueForKey:@"sex"]);
//        NSLog(@"-----------------------------------");
        
        ManEntity *man1 = [info valueForKey:@"manRelationship"];
        
        
        NSLog(@"Name: %@", man1.name);
        NSLog(@"weight: %@", man1.weight);
        NSLog(@"height: %@", man1.height);
        NSLog(@"==========================================");

//        NSLog(@"Name: %@", [man1 valueForKey:@"name"]);
//        NSLog(@"weight: %@", [man1 valueForKey:@"weight"]);
//        NSLog(@"height: %@", [man1 valueForKey:@"height"]);
//        NSLog(@"==========================================");
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
