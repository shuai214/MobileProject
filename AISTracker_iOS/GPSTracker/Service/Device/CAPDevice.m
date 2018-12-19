//
//  CAPDevice.m
//  GPSTracker
//
//  Created by user on 8/19/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPDevice.h"



@implementation CAPDeviceSetting
- (NSString *)description {
    return [self toJSONString];
}
@end

@implementation CAPDevice
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"createdDate": @"createdAt",
                                                                  @"deviceID": @"uuid"
                                                                  }];
}

- (BOOL)isMaster {
    return [self.role isEqualToString:kMasterRole];
}
@end
