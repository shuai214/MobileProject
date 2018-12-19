//
//  MQTTCenter.h
//  GPSTracker
//
//  Created by WeifengYao on 30/10/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTTInfo.h"
//#import "MQTTConfig.h"

typedef NS_ENUM(NSUInteger, MQTTDeviceType) {
    MQTTDeviceTypeApp,
    MQTTDeviceTypeTracker,
    MQTTDeviceTypeWatch
};

@interface MQTTConfig : NSObject
@property (nonatomic, copy) NSString *host;
@property (nonatomic, assign) UInt32 port;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *platformID;
@property (nonatomic, assign) MQTTDeviceType deviceType;
@property (nonatomic, copy) NSString *clientID;
@property (nonatomic, assign) NSUInteger keepAliveInterval;
@end

@interface MQTTCenter : NSObject
+ (instancetype)center;

- (void)open:(MQTTConfig *)config;
- (void)close;

- (MQTTInfo *)getInfo:(NSString *)deviceID;
@end
