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
}

- (void)fetchDevice:(CAPServiceReply)reply {
    //TODO
}

- (void)addDevice:(CAPDevice *)device reply:(CAPServiceReply)reply {
    //TODO
}

- (void)updateDevice:(CAPDevice *)device reply:(CAPServiceReply)reply {
    //TODO
}

- (void)deleteDevice:(CAPDevice *)device reply:(CAPServiceReply)reply {
    //TODO
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
