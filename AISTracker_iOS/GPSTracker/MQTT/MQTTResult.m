//
//  MQTTResult.m
//  GPSTracker
//
//  Created by WeifengYao on 30/10/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "MQTTResult.h"

@implementation MQTTResult
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"command": @"cmd"
                                                                  }];
}
@end
