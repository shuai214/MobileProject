//
//  CAPUser.m
//  GPSTracker
//
//  Created by user on 10/13/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPUser.h"

@implementation CAPUserAccount
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"username": @"userName",
                                                                  @"userID" : @"id"
                                                                  }];
}

@end

@implementation CAPUserInfo
@end

@implementation CAPUserOAuth
@end

@implementation CAPUserProfile
@end

@implementation CAPUserSetting
@end

@implementation CAPUser
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"lastSignedInTime":
                                                                      @"lastLoggedAt",
                                                                  }];
}
@end
