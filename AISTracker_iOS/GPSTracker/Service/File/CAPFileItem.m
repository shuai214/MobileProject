//
//  CAPFileItem.m
//  GPSTracker
//
//  Created by WeifengYao on 7/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPFileItem.h"

@implementation CAPFileItem
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"baseURL": @"base_url",
                                                                  @"deleteURL": @"delete_url"
                                                                  }];
}
@end
