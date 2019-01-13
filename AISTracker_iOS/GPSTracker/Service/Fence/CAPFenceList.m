//
//  CAPFenceList.m
//  GPSTracker
//
//  Created by 曹帅 on 2019/1/3.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPFenceList.h"

@implementation CAPFenceList
+ (NSDictionary*)mj_objectClassInArray
{
    return @{@"result": @"Result"};
}
@end
@implementation Result
+ (NSDictionary*)mj_objectClassInArray
{
    return @{@"list": @"List"};
}
@end
@implementation List

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"fid": @"id"};
}
@end
