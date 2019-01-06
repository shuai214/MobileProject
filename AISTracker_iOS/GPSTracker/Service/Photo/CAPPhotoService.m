//
//  CAPPhotoService.m
//  GPSTracker
//
//  Created by WeifengYao on 7/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPPhotoService.h"

@implementation CAPPhotoService

- (void)takingPicturesWithDeviceID:(NSString *)deviceID Reply:(CAPServiceReply)reply{
    //TODO
    
//    NSDictionary *params = @{
//                             @"uuid":deviceID
//                             };
    if (deviceID) {
        CAPHttpRequest *request = [self buildRequest:[@"Device/Photo/" stringByAppendingString:deviceID] method:@"POST" parameters:nil];
        [self sendRequest:request reply:^(CAPHttpResponse *response) {
            reply(response);
        }];
    }
    
}
- (void)getPhotoListDeviceID:(NSString *)deviceID reply:(CAPServiceReply)reply{
    if (deviceID) {
        CAPHttpRequest *request = [self buildRequest:[@"Device/Photos/" stringByAppendingString:deviceID] method:@"GET"];
        [self sendRequest:request reply:^(CAPHttpResponse *response) {
            reply(response);
        }];
    }
}
@end
