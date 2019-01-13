//
//  CAPDeviceLocal.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/13.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPDeviceLocal.h"

@implementation CAPDeviceLocal
+ (instancetype)local {
    static id instance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
@end
