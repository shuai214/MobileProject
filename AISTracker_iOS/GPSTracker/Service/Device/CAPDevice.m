//
//  CAPDevice.m
//  GPSTracker
//
//  Created by user on 8/19/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPDevice.h"



@implementation CAPDeviceSetting
+ (NSDictionary*)mj_objectClassInArray
{
    return @{@"avatar": @"CAPFileItem"};
}


@end

@implementation CAPDevice

+ (NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{@"createdDate": @"createdAt",@"deviceID": @"uuid",@"setting":@"setting"};
}
+ (NSDictionary*)mj_objectClassInArray
{
    return @{@"footprint": @"CAPFootprint",@"setting": @"CAPDeviceSetting"};
}
@end
