//
//  MQTTResult.h
//  GPSTracker
//
//  Created by WeifengYao on 30/10/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPBaseJSON.h"
#import "MQTTInfo.h"

@interface MQTTResult : CAPBaseJSON
//@JsonProperty("cmd")
@property (nonatomic, copy) NSString *command;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) MQTTInfo *result;

@property (nonatomic, copy) NSString *deviceID;
@end
