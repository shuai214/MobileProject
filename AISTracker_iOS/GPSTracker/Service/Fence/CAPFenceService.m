//
//  CAPFenceService.m
//  GPSTracker
//
//  Created by WeifengYao on 7/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPFenceService.h"

@implementation CAPFenceService
- (void)fetchFence:(NSString *)deviceID reply:(CAPServiceReply)reply {
    if (deviceID) {
        CAPHttpRequest *request = [self buildRequest:[@"Fence/Fences/" stringByAppendingString:deviceID] method:@"GET"];
        [self sendRequest:request reply:^(CAPHttpResponse *response) {
            reply(response);
        }];
    }
}

- (void)addFence:(CAPFence *)fence reply:(CAPServiceReply)reply {
    NSString *lat = [NSString stringWithFormat:@"%lf",fence.latitude];
    NSString *lng = [NSString stringWithFormat:@"%lf",fence.longitude];
    NSString *range = [NSString stringWithFormat:@"%ld",(long)fence.range];
    NSDictionary *params = @{
                             @"name":fence.name,
                             @"address": fence.address,
                             @"lat":lat,
                             @"lng":lng,
                             @"range":range,
                             @"status":@"1",
                             @"content":@""
                             };
    CAPHttpRequest *request = [self buildRequest:[@"Fence/Fence/" stringByAppendingString:fence.deviceID] method:@"POST" parameters:params];
    [self sendRequest:request reply:^(CAPHttpResponse *response) {
        reply(response);
    }];
}

- (void)editFence:(CAPFence *)fence reply:(CAPServiceReply)reply {
    
}

- (void)deleteFence:(NSString *)fenceID reply:(CAPServiceReply)reply {
    
}
@end
