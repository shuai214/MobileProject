//
//  CAPDeviceLogs.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/4.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ResultLog,ListLog,LogContent;
NS_ASSUME_NONNULL_BEGIN

@interface CAPDeviceLogs : NSObject
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,strong)ResultLog *result;
@end
@interface ResultLog : NSObject
@property(nonatomic,strong)NSArray <ListLog *>*list;
@property(nonatomic,assign)NSInteger total;
@property(nonatomic,assign)NSInteger pagesize;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,assign)NSInteger pages;

@end
@interface ListLog : NSObject
@property(nonatomic,copy)NSString *uuid;
@property(nonatomic,assign)NSInteger logId;
@property(nonatomic,copy)NSString *logType;
@property(nonatomic,strong)LogContent *logContent;
@property(nonatomic,assign)NSTimeInterval createdAt;
@end
@interface LogContent : NSObject
@property(nonatomic,copy)NSString *altitude;
@property(nonatomic,assign)NSInteger batlevel;
@property(nonatomic,copy)NSString *data;
@property(nonatomic,copy)NSString *deviceID;
@property(nonatomic,copy)NSString *direction;
@property(nonatomic,copy)NSString *filename;
@property(nonatomic,copy)NSString *gps;
@property(nonatomic,copy)NSString *gpsnum;
@property(nonatomic,copy)NSString *gsmss;
@property(nonatomic,copy)NSString *latitude;
@property(nonatomic,copy)NSString *longitude;
@property(nonatomic,copy)NSString *neighbors;
@property(nonatomic,copy)NSString *rolls;
@property(nonatomic,copy)NSString *speed;
@property(nonatomic,copy)NSString *station;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *steps;
@property(nonatomic,strong)NSArray *wifis;
@property(nonatomic,assign)NSTimeInterval time;
@end
NS_ASSUME_NONNULL_END
