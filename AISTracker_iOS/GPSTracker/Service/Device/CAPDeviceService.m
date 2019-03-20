//
//  CAPDeviceService.m
//  GPSTracker
//
//  Created by user on 9/20/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPDeviceService.h"
#import "CAPFileUpload.h"
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
                             @"mobile":device.mobile,
                             @"sos":device.sos
                             };
    CAPHttpRequest *request = [self buildRequest:@"Device/Device" method:@"POST" parameters:params];
    [self sendRequest:request reply:^(CAPHttpResponse *response) {
        reply(response);
    }];
}

- (void)getDeviceInfo:(CAPDevice *)device reply:(CAPServiceReply)reply{
    //TODO
    if (device) {
        CAPHttpRequest *request = [self buildRequest:[@"Device/Device/" stringByAppendingString:device.deviceID] method:@"GET" parameters:nil];
        [self sendRequest:request reply:^(CAPHttpResponse *response) {
            reply(response);
        }];
    }
}

- (void)bindDevice:(NSString *)shareid param:(NSDictionary *)param reply:(CAPServiceReply)reply{
    //TODO
    if (shareid) {
        CAPHttpRequest *request = [self buildRequest:[@"Device/Bind/" stringByAppendingString:shareid] method:@"POST" parameters:param];
        [self sendRequest:request reply:^(CAPHttpResponse *response) {
            reply(response);
        }];
    }
}
    
- (void)deviceConfirm:(NSString *)deviceID userid:(NSString *)userid result:(NSString *)result reply:(CAPServiceReply)reply{
    if (deviceID) {
        NSDictionary *params = @{
                                 @"uuid": deviceID,
                                 @"userid": userid,
                                 @"result": result
                                 };
        CAPHttpRequest *request = [self buildRequest:[NSString stringWithFormat:@"%@%@/%@/%@",@"Device/Confirm/",deviceID,userid,result] method:@"POST" parameters:params];
        [self sendRequest:request reply:^(CAPHttpResponse *response) {
            reply(response);
        }];
    }
}
-(void)getDevice:(CAPDevice *)device reply:(CAPServiceReply)reply{
    //TODO
    if (device) {
        CAPHttpRequest *request = [self buildRequest:[@"Device/Setting/" stringByAppendingString:device.deviceID] method:@"GET" parameters:nil];
        [self sendRequest:request reply:^(CAPHttpResponse *response) {
            reply(response);
        }];
    }
}
- (void)getDeviceBindinfo:(CAPDevice *)device reply:(CAPServiceReply)reply{
    //TODO
    if (device) {
        CAPHttpRequest *request = [self buildRequest:[@"Device/BindInfo/" stringByAppendingString:device.deviceID] method:@"GET" parameters:nil];
        [self sendRequest:request reply:^(CAPHttpResponse *response) {
            reply(response);
        }];
    }
}
- (void)updateDevice:(CAPDevice *)device reply:(CAPServiceReply)reply {
    //TODO
    if (device) {
        NSDictionary *params = @{
                                 @"name": device.name,
                                 @"mobile":device.mobile,
                                 @"sos":device.sos ? device.sos : @"",
                                 @"avatarPath": device.avatarPath ? device.avatarPath : @"",
                                 @"avatarBaseUrl": device.avatarBaseUrl ? device.avatarBaseUrl : @""
                                 };
        CAPHttpRequest *request = [self buildRequest:[@"Device/BindInfo/" stringByAppendingString:device.deviceID] method:@"PUT" parameters:params];
        [self sendRequest:request reply:^(CAPHttpResponse *response) {
            reply(response);
        }];
    }else{
        [gApp hideHUD];
    }
}

- (void)deleteDevice:(CAPDevice *)device reply:(CAPServiceReply)reply {
    //TODO
    if (device) {
        CAPHttpRequest *request = [self buildRequest:[@"Device/Device/" stringByAppendingString:device.deviceID] method:@"DELETE" parameters:nil];
        [self sendRequest:request reply:^(CAPHttpResponse *response) {
            reply(response);
        }];
    }
    
}

- (void)updateSetting:(CAPDevice *)setting reply:(CAPServiceReply)reply {
    if (setting) {
        NSDictionary *params = @{
                                 @"name": setting.name,
                                 @"mobile":setting.mobile,
                                 @"answerMode":setting.setting.answerMode ? setting.setting.answerMode:@"",
                                 @"reportFrequency":[NSString stringWithFormat:@"%ld",(long)(setting.setting.reportFrequency ? setting.setting.reportFrequency:0)],
                                 @"avatarPath": setting.avatarPath ? setting.avatarPath : @"",
                                 @"avatarBaseUrl": setting.avatarBaseUrl ? setting.avatarBaseUrl : @""
                                 };

        CAPHttpRequest *request = [self buildRequest:[@"Device/Setting/" stringByAppendingString:setting.deviceID] method:@"PUT" parameters:params];
        [self sendRequest:request reply:^(CAPHttpResponse *response) {
            reply(response);
        }];
    }
}

- (void)shareDevice:(NSString *)deviceID reply:(CAPServiceReply)reply {
    //TODO
    if (deviceID) {
        NSDictionary *params = @{
                                 @"share": @"1",
                                 @"monitor": @"1"
                                 };
        CAPHttpRequest *request = [self buildRequest:[@"Device/Share/" stringByAppendingString:deviceID] method:@"POST" parameters:params];
        [self sendRequest:request reply:^(CAPHttpResponse *response) {
            reply(response);
        }];
    }
}

- (void)fetchLastFootprint:(NSString *)deviceID reply:(CAPServiceReply)reply {
    //TODO
}

- (void)fetchFootprint:(NSString *)deviceID starttime:(NSString *)starttime endtime:(NSString *)endtime reply:(CAPServiceReply)reply{
    //TODO
    if (deviceID) {
        NSDictionary *params = @{
                                 @"starttime": starttime,
                                 @"endtime": endtime
                                 };
        CAPHttpRequest *request = [self buildRequest:[@"Device/Locations/" stringByAppendingString:deviceID] method:@"GET" parameters:params];
        [self sendRequest:request reply:^(CAPHttpResponse *response) {
            reply(response);
        }];
    }
}

- (void)getDeviceLogs:(NSString *)deviceID page:(NSInteger)page reply:(CAPServiceReply)reply{
    if (deviceID) {
        NSString *pageStr = [NSString stringWithFormat:@"%ld",(long)page];
        NSDictionary *params = @{
                                 @"page": pageStr,
                                 @"pagesize":@"20"
                                 };
        CAPHttpRequest *request = [self buildRequest:[@"Device/Logs/" stringByAppendingString:deviceID] method:@"GET" parameters:params];
        [self sendRequest:request reply:^(CAPHttpResponse *response) {
            reply(response);
        }];
    }
}

- (void)deviceSendCommand:(NSString *)deviceID cmd:(NSString *)cmd param:(NSString *)param reply:(CAPServiceReply)reply{
    if (deviceID) {
        NSDictionary *params = @{
                                 @"cmd": cmd,
                                 @"param":param ? param : @""
                                 };
        CAPHttpRequest *request = [self buildRequest:[@"Device/Command/" stringByAppendingString:deviceID] method:@"POST" parameters:params];
        [self sendRequest:request reply:^(CAPHttpResponse *response) {
            reply(response);
        }];
    }
}
- (void)setDeviceParameter:(CAPDevice *)device reply:(CAPServiceReply)reply{
    //TODO
    if (device) {
        CAPHttpRequest *request = [self buildRequest:[@"Device/Parameter/" stringByAppendingString:device.deviceID] method:@"POST" parameters:nil];
        [self sendRequest:request reply:^(CAPHttpResponse *response) {
            reply(response);
        }];
    }
}
- (void)setSOSMobile:(CAPDevice *)device sosMobiles:(NSArray *)array reply:(CAPServiceReply)reply{
    //TODO
    if (device) {
        NSDictionary *params = @{
                                 @"sos":array
                                 };
        CAPHttpRequest *request = [self buildRequest:[@"Device/SOS/" stringByAppendingString:device.deviceID] method:@"PUT" parameters:params];
        [self sendRequest:request reply:^(CAPHttpResponse *response) {
            reply(response);
        }];
    }
}
- (void)getSOSMobile:(CAPDevice *)device reply:(CAPServiceReply)reply{
    //TODO
    if (device) {
       
        CAPHttpRequest *request = [self buildRequest:[@"Device/SOS/" stringByAppendingString:device.deviceID] method:@"GET"];
        [self sendRequest:request reply:^(CAPHttpResponse *response) {
            reply(response);
        }];
    }
}
- (void)getDeviceBindList:(CAPDevice *)device reply:(CAPServiceReply)reply{
    //TODO
    if (device) {
        CAPHttpRequest *request = [self buildRequest:[@"Device/BoundList/" stringByAppendingString:device.deviceID] method:@"GET"];
        [self sendRequest:request reply:^(CAPHttpResponse *response) {
            reply(response);
        }];
    }
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
//    NSLog(@"[%@ checkDeviceVersion:%lu]", [self class], (unsigned long)versionCode);
//    NSString *requestURLString = [NSString stringWithFormat:@"Device/Logs/%lu", (unsigned long)versionCode];
//    CAPHttpRequest *request = [self buildRequest:requestURLString method:@"GET" parameters:nil];
//    [self sendRequest:request reply:^(CAPHttpResponse *response) {
////        reply([CAPCheckDeviceVersionResponse responseWithHttpResponse:response]);
//    }];
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
