//
//  CAPHttpRequest.m
//  GPSTracker
//
//  Created by user on 8/18/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPHttpRequest.h"

@interface CAPHttpRequestBuilder ()
    @property (nonatomic, copy) NSString *URLString;
    @property (nonatomic, copy) NSString *method;
    @property (nonatomic,  strong) NSMutableDictionary *parameters;
@end

@implementation CAPHttpRequestBuilder
- (instancetype)initWithURLString:(NSString *)URLString {
    if(self = [super init]) {
        self.URLString = URLString;
        self.parameters = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    return self;
}

- (instancetype)method:(NSString *)method {
    self.method = method;
    return self;
}

- (instancetype)addParameter:(NSString *)value forKey:(NSString *)key {
    self.parameters[key] = value;
    return self;
}

- (instancetype)addParameters:(NSDictionary *)parameters {
    for(NSString *key in parameters) {
        self.parameters[key] = parameters[key];
    }
    return self;
}

- (CAPHttpRequest *)build {
    return [CAPHttpRequest newRequestFromBuilder:self];
}
@end


@interface CAPHttpRequest ()
@property (nonatomic, readwrite, copy) NSString *URLString;
@property (nonatomic, readwrite, copy) NSString *method;
@property (nonatomic, readwrite, strong) NSDictionary *parameters;
@end

@implementation CAPHttpRequest
+ (CAPHttpRequestBuilder *)newBuilder:(NSString *)URLString {
    return [CAPHttpRequest newBuilder:URLString method:@"GET"];
}

+ (CAPHttpRequestBuilder *)newBuilder:(NSString *)URLString method:(NSString *)method {
    CAPHttpRequestBuilder *builder = [[CAPHttpRequestBuilder alloc] initWithURLString:URLString];
    builder.method = method;
    return builder;
}

+ (instancetype)newRequestFromBuilder:(CAPHttpRequestBuilder *)builder {
    CAPHttpRequest *request = [[CAPHttpRequest alloc] init];
    request.URLString = builder.URLString;
    request.method = builder.method;
    request.parameters = [builder.parameters copy];
    return request;
}
@end
