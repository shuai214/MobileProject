//
//  CAPGuardian.m
//  GPSTracker
//
//  Created by WeifengYao on 7/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPGuardian.h"

@implementation CAPGuardianProfile
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"nickname": @"firstName"
                                                                  }];
}
@end

@implementation CAPGuardian
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"username": @"userName"
                                                                  }];
}
@end
