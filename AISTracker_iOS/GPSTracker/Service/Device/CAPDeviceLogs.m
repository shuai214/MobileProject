//
//  CAPDeviceLogs.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/4.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPDeviceLogs.h"

@implementation CAPDeviceLogs
+ (NSDictionary*)mj_objectClassInArray
{
    return @{@"result": @"ResultLog"};
}
@end

@implementation ResultLog
+ (NSDictionary*)mj_objectClassInArray
{
    return @{@"list": @"ListLog"};
}
@end
@implementation ListLog
//+ (NSDictionary*)mj_objectClassInArray
//{
//    return @{@"id": @"fid",};
//}
@end
@implementation LogContent
+ (NSDictionary*)mj_objectClassInArray
{
    return @{@"data": @"data"};
}
@end
