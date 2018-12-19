//
//  CAPHttpService.h
//  GPSTracker
//
//  Created by user on 8/18/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAPHttpRequest.h"
#import "CAPHttpResponse.h"

@class NSURLSessionDataTask;

//typedef void (^CAPHttpServiceSuccessBlock) (NSURLSessionDataTask *task, id responseObject);
//typedef void (^CAPHttpServiceFailureBlock) (NSURLSessionDataTask *task, NSError *error);

typedef void (^CAPHttpServiceCallback) (CAPHttpResponse *response);

@interface CAPHttpService : NSObject
+ (instancetype)defaultService;

//- (NSURLSessionDataTask *)GET:(CAPHttpRequest *)request reply:(CAPHttpServiceCallback)reply;
//- (NSURLSessionDataTask *)POST:(CAPHttpRequest *)request reply:(CAPHttpServiceCallback)reply;
//- (NSURLSessionDataTask *)PUT:(CAPHttpRequest *)request reply:(CAPHttpServiceCallback)reply;
//- (NSURLSessionDataTask *)DELETE:(CAPHttpRequest *)request reply:(CAPHttpServiceCallback)reply;

- (void)auth:(NSString *)token;

- (NSURLSessionDataTask *)sendRequest:(CAPHttpRequest *)request reply:(CAPHttpServiceCallback)reply;
@end
