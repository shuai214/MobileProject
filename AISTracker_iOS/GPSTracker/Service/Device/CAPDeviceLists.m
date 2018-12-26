//
//  CAPDeviceLists.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2018/12/25.
//  Copyright © 2018年 Capelabs. All rights reserved.
//

#import "CAPDeviceLists.h"

@implementation CAPDeviceLists
+ (NSDictionary*)mj_objectClassInArray
{
    return @{@"result": @"ResultLists"};
}
@end
@implementation ResultLists

+ (NSDictionary*)mj_objectClassInArray
{
    return @{@"list": @"CAPDevice"};
}
@end
