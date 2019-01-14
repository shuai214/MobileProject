//
//  CAPCoreData.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/14.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPCoreData.h"
#import <CoreData/CoreData.h>
#import "DeviceMessageInfo+CoreDataClass.h"
@interface CAPCoreData()
{
    NSManagedObjectContext * _context;
    NSMutableArray * _dataSource;
}
@property (nonatomic, strong)NSPersistentStoreCoordinator *store;

@end

@implementation CAPCoreData
+ (instancetype)coreData{
    static id instance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
////创建数据库
- (void)creatResource:(NSString *)resourceName{
    //1、创建模型对象
    //获取模型路径/Users/caoshuai/Desktop/MobileProject/AISTracker_iOS/GPSTracker/Core Data/GPSTracker.xcdatamodeld
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MessageLogs" withExtension:@"momd"];
    if (!modelURL) {
        return;
    }
    //根据模型文件创建模型对象
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    
    //2、创建持久化存储助理：数据库
    //利用模型对象创建助理对象
    self.store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    //数据库的名称和路径
    NSString *docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlPath = [docStr stringByAppendingPathComponent:@"coreData.sqlite"];
    NSLog(@"数据库 path = %@", sqlPath);
    NSURL *sqlUrl = [NSURL fileURLWithPath:sqlPath];
    
    NSError *error = nil;
    //设置数据库相关信息 添加一个持久化存储库并设置存储类型和路径，NSSQLiteStoreType：SQLite作为存储库
    [self.store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlUrl options:nil error:&error];
    
    if (error) {
        NSLog(@"添加数据库失败:%@",error);
    } else {
        NSLog(@"添加数据库成功");
    }
    
    //3、创建上下文 保存信息 操作数据库
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //关联持久化助理
    context.persistentStoreCoordinator = self.store;
   
    _context = context;
}

- (void)insertData:(MQTTInfo *)mqttInfo{
    // 1.根据Entity名称和NSManagedObjectContext获取一个新的继承于NSManagedObject的子类Student
    
    DeviceMessageInfo * deviceMessageInfo = [NSEntityDescription
                         insertNewObjectForEntityForName:@"DeviceMessageInfo"
                         inManagedObjectContext:_context];
    
    //  2.根据表Student中的键值，给NSManagedObject对象赋值
    deviceMessageInfo.deviceId = mqttInfo.deviceID;
    deviceMessageInfo.deviceMessage = mqttInfo.message;
    deviceMessageInfo.deviceMessageTime = mqttInfo.time;
    //   3.保存插入的数据
    NSError *error = nil;
    [_context save:&error];
}
//删除
- (void)deleteData:(NSString *)deviceMessageTime{
    
    //创建删除请求
    NSFetchRequest *deleRequest = [NSFetchRequest fetchRequestWithEntityName:@"DeviceMessageInfo"];
    
    //删除条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:deviceMessageTime];
    deleRequest.predicate = pre;
    
    //返回需要删除的对象数组
    NSArray *deleArray = [_context executeFetchRequest:deleRequest error:nil];
    
    //从数据库中删除
    for (DeviceMessageInfo *deviceMessageInfo in deleArray) {
        [_context deleteObject:deviceMessageInfo];
    }
    //保存--记住保存
    NSError *error = nil;
    [_context save:&error];
}
- (void)deleteAllData{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"DeviceMessageInfo"];
    //2.创建删除请求  参数是：查询请求
    //NSBatchDeleteRequest是iOS9之后新增的API，不兼容iOS8及以前的系统
    NSBatchDeleteRequest *deletRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    //3.使用存储调度器(NSPersistentStoreCoordinator)执行删除请求
    /**
     Request：存储器请求（NSPersistentStoreRequest）  删除请求NSBatchDeleteRequest继承于NSPersistentStoreRequest
     context：管理对象上下文
     */
    [ self.store executeRequest:deletRequest withContext:_context error:nil];
  
}
//读取查询
- (NSArray *)readData:(NSString *)resourceName{
    //创建查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:resourceName];
    //发送查询请求,并返回结果
    NSArray *resArray = [_context executeFetchRequest:request error:nil];
    return resArray;
}
@end
