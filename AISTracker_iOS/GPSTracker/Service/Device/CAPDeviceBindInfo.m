//
//  CAPDeviceBindInfo.m
//  GPSTracker
//
//  Created by 曹帅 on 2019/1/8.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPDeviceBindInfo.h"

@implementation CAPDeviceBindInfo
+ (NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{@"deviceID": @"uuid"};
}
+ (NSDictionary*)mj_objectClassInArray
{
    return @{@"bindinfo": @"BindInfo"};
}
@end
//@implementation ResultBindInfo
//+ (NSDictionary*)mj_objectClassInArray
//{
//   
//}
//@end
@implementation BindInfo

@end
