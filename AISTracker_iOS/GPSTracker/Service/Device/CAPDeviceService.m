//
//  CAPDeviceService.m
//  GPSTracker
//
//  Created by user on 9/20/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPDeviceService.h"
@implementation CAPDeviceService

- (void)fetchDevice:(NSString *)deviceID reply:(CAPServiceReply)reply {
    //TODO
//    NSDictionary *params = @{
//                             @"uuid": deviceID
//                             };
    if (deviceID) {
        CAPHttpRequest *request = [self buildRequest:[@"Device/RecentLocation/" stringByAppendingString:deviceID] method:@"GET" parameters:nil];
        [self sendRequest:request reply:^(CAPHttpResponse *response) {
            reply(response);
        }];
    }
}

- (void)fetchDevice:(CAPServiceReply)reply {
    //TODO
    NSDictionary *params = @{
                             @"status": @"1",
                             @"page": @"0",
                             @"pagesize": @"20"
                             };
    CAPHttpRequest *request = [self buildRequest:@"Device/Devices" method:@"GET" parameters:params];
    [self sendRequest:request reply:^(CAPHttpResponse *response) {
        reply(response);
    }];
}

- (void)addDevice:(CAPDevice *)device reply:(CAPServiceReply)reply {
    //TODO
    NSDictionary *params = @{
                             @"uuid": device.deviceID,
                             @"token": [CAPUserDefaults objectForKey:@"accessToken"] ? [CAPUserDefaults objectForKey:@"accessToken"]:@"",
                             @"name": device.name,
                             @"mobile":@"13888888888",
                             @"sos":@"13888888888"
                             };
    CAPHttpRequest *request = [self buildRequest:@"Device/Device" method:@"POST" parameters:params];
    [self sendRequest:request reply:^(CAPHttpResponse *response) {
        reply(response);
    }];
}

- (void)updateDevice:(CAPDevice *)device reply:(CAPServiceReply)reply {
    //TODO
    CAPHttpRequest *request = [self buildRequest:[@"Device/Device" stringByAppendingString:device.deviceID] method:@"GET" parameters:nil];
    [self sendRequest:request reply:^(CAPHttpResponse *response) {
        reply(response);
    }];
}

- (void)deleteDevice:(CAPDevice *)device reply:(CAPServiceReply)reply {
    //TODO
    CAPHttpRequest *request = [self buildRequest:[@"Device/Device" stringByAppendingString:device.deviceID] method:@"DELETE" parameters:nil];
    [self sendRequest:request reply:^(CAPHttpResponse *response) {
        reply(response);
    }];
}

- (void)updateSetting:(CAPDeviceSetting *)setting reply:(CAPServiceReply)reply {
    //TODO
}

- (void)shareDevice:(NSString *)deviceID reply:(CAPServiceReply)reply {
    //TODO
}

- (void)fetchLastFootprint:(NSString *)deviceID reply:(CAPServiceReply)reply {
    //TODO
}

- (void)fetchFootprint:(NSString *)deviceID range:(NSRange)range reply:(CAPServiceReply)reply {
    //TODO
}


//+ (instancetype)defaultService {
//    static id instance = NULL;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[self alloc] init];
//    });
//    return instance;
//}

- (void)checkDeviceVersion:(NSUInteger)versionCode reply:(CAPServiceReply)reply {
    NSLog(@"[%@ checkDeviceVersion:%lu]", [self class], (unsigned long)versionCode);
//    NSString *requestURLString = [NSString stringWithFormat:@"Device/Logs/%lu", (unsigned long)versionCode];
//    CAPHttpRequest *request = [self buildRequest:requestURLString method:@"GET" parameters:nil];
//    [self sendRequest:request reply:^(CAPHttpResponse *response) {
//        reply([CAPCheckDeviceVersionResponse responseWithHttpResponse:response]);
//    }];
}
@end
