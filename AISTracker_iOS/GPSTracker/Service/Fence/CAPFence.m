//
//  CAPFence.m
//  GPSTracker
//
//  Created by WeifengYao on 7/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPFence.h"

@implementation CAPFence
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"fenceID": @"id",
                                                                  @"deviceID": @"uuid",
                                                                  @"userID": @"user_id",
                                                                  @"latitude": @"lat",
                                                                  @"longitude": @"lng",
                                                                  @"site": @"name",
                                                                  @"building": @"content",
                                                                  @"createdDate": @"created_at",
                                                                  @"updatedDate": @"updated_at"
                                                                  }];
}
@end
