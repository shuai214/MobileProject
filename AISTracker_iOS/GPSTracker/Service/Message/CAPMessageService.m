//
//  CAPMessageService.m
//  GPSTracker
//
//  Created by WeifengYao on 7/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPMessageService.h"

@implementation CAPMessageService
- (void)updatePushToken:(NSString *)token reply:(CAPServiceReply)reply{
    NSString *idfv = [[UIDevice currentDevice].identifierForVendor UUIDString];

    NSDictionary *params = @{
                             @"token":token?token:@"",
                             @"udid": idfv,
                             @"type": @"gcm"
                             };
    NSLog(@"%@",params);
    CAPHttpRequest *request = [self buildRequest:@"Account/PushToken" method:@"PUT" parameters:params];
    [self sendRequest:request reply:^(CAPHttpResponse *response) {
        reply(response);
    }];
}
- (void)deletePushTokenReply:(CAPServiceReply)reply{
    NSString *idfv = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSDictionary *params = @{
                             @"udid": idfv
                             };
    CAPHttpRequest *request = [self buildRequest:@"Account/PushToken" method:@"DELETE" parameters:params];
    [self sendRequest:request reply:^(CAPHttpResponse *response) {
        reply(response);
    }];
}
@end
