//
//  CAPDeviceBindList.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/23.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPDeviceBindList.h"

@implementation PROFILE

@end
@implementation SOS

@end
@implementation USERS
+ (NSDictionary*)mj_objectClassInArray
{
    return @{@"device": @"CAPDevice",@"profile": @"PROFILE"};
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"uid": @"id"};
}
@end
@implementation CAPDeviceBindList
+ (NSDictionary*)mj_objectClassInArray
{
    return @{@"users": @"USERS"};
}
@end
