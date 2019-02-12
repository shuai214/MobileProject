//
//  CAPDeviceLocal.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/2/11.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPDeviceLocalModel.h"

@implementation Station

@end

@implementation Wifis

@end
@implementation CAPDeviceLocalModel
+ (NSDictionary*)mj_objectClassInArray
{
    return @{@"station": @"Station",@"wifis": @"Wifis"};
}
@end
