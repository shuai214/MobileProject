//
//  CAPPhotoService.m
//  GPSTracker
//
//  Created by WeifengYao on 7/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPPhotoService.h"

@implementation CAPPhotoService

- (void)takingPicturesReply:(CAPServiceReply)reply{
    //TODO
    
    NSDictionary *params = @{
                             @"uuid": @""
                             };
    CAPHttpRequest *request = [self buildRequest:@"Device/Device" method:@"POST" parameters:params];
    [self sendRequest:request reply:^(CAPHttpResponse *response) {
        reply(response);
    }];
}

@end
