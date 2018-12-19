//
//  CAPHttpRequest.h
//  GPSTracker
//
//  Created by user on 8/18/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CAPHttpRequest;

@interface CAPHttpRequestBuilder : NSObject
- (instancetype)method:(NSString *)method;
- (instancetype)addParameter:(NSString *)value forKey:(NSString *)key;
- (instancetype)addParameters:(NSDictionary *)parameters;
- (CAPHttpRequest *)build;
@end

@interface CAPHttpRequest : NSObject
@property (nonatomic, readonly, copy) NSString *URLString;
@property (nonatomic, readonly, copy) NSString *method;
@property (nonatomic, readonly, strong) NSDictionary *parameters;

@property (nonatomic, assign) BOOL editing;
+ (CAPHttpRequestBuilder *)newBuilder:(NSString *)URLString;
+ (CAPHttpRequestBuilder *)newBuilder:(NSString *)URLString method:(NSString *)method;
+ (instancetype)newRequestFromBuilder:(CAPHttpRequestBuilder *)builder;
@end
