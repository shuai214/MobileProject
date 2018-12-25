//
//  CAPBaseService.m
//  GPSTracker
//
//  Created by user on 8/18/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPBaseService.h"
#import "CAPResponse.h"

@implementation CAPBaseService
- (CAPHttpRequest *)buildRequest:(NSString *)URLString {
    return [self buildRequest:URLString method:@"GET"];
}

- (CAPHttpRequest *)buildRequest:(NSString *)URLString method:(NSString *)method {
    return [self buildRequest:URLString method:method parameters:nil];
}

- (CAPHttpRequest *)buildRequest:(NSString *)URLString method:(NSString *)method parameters:(NSDictionary *)parameters {
    return [[[CAPHttpRequest newBuilder:URLString method:method] addParameters:parameters] build];
}

- (void)sendRequest:(CAPHttpRequest *)request reply:(CAPHttpServiceCallback)reply {
    CAPHttpService *service = [CAPHttpService defaultService];
    [service auth:[CAPUserDefaults objectForKey:@"accessToken"] ? [CAPUserDefaults objectForKey:@"accessToken"]:@""];
    [service sendRequest:request reply:reply];
}
@end
