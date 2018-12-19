//
//  CAPBaseService.h
//  GPSTracker
//
//  Created by user on 8/18/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAPHttpService.h"
#import "CAPResponse.h"

typedef void (^CAPServiceReply)(id response);
typedef void (^CAPServiceResponse)(CAPResponse *res);

@interface CAPBaseService : NSObject
- (CAPHttpRequest *)buildRequest:(NSString *)URLString;
- (CAPHttpRequest *)buildRequest:(NSString *)URLString method:(NSString *)method;
- (CAPHttpRequest *)buildRequest:(NSString *)URLString method:(NSString *)method parameters:(NSDictionary *)parameters;

- (void)sendRequest:(CAPHttpRequest *)request reply:(CAPHttpServiceCallback)reply;
@end
