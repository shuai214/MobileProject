//
//  CAPHttpService.m
//  GPSTracker
//
//  Created by user on 8/18/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPHttpService.h"
#import <AFNetworking/AFNetworking.h>
#import "AppConfig.h"
#import "CAPPhones.h"

@interface CAPHttpService ()
@property (strong, nonatomic) AFHTTPSessionManager *session;
@end

@implementation CAPHttpService
+ (instancetype)defaultService {
    static id instance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.session = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:gCfg.rootURLString]];
    self.session.securityPolicy.allowInvalidCertificates = YES;
    self.session.securityPolicy.validatesDomainName = NO;
    
    AFHTTPRequestSerializer* requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:0];
    requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    requestSerializer.timeoutInterval = 15;
    [requestSerializer setValue:@"1234567890" forHTTPHeaderField:@"App-Key"];
    [requestSerializer setValue:@"1" forHTTPHeaderField:@"App-OS"]; //1-iOS, 2-android, 3-windows
    [requestSerializer setValue:[CAPPhones phoneModel] forHTTPHeaderField:@"App-OS-Model"];
    [requestSerializer setValue:[CAPPhones systemName] forHTTPHeaderField:@"App-OS-SDK"];
    [requestSerializer setValue:[CAPPhones systemVersion] forHTTPHeaderField:@"App-OS-Release"];
    [requestSerializer setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"] forHTTPHeaderField:@"App-Package-Name"];
    [requestSerializer setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"App-Version-Name"];
    [requestSerializer setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forHTTPHeaderField:@"App-Version-Code"];
    [requestSerializer setValue:@"143565456" forHTTPHeaderField:@"App-Install-Time"];
    [requestSerializer setValue:@"143565456" forHTTPHeaderField:@"App-Update-Time"];
    [requestSerializer setValue:[CAPPhones getUUIDString] forHTTPHeaderField:@"App-UDID"];
    [requestSerializer setValue:([CAPPhones isChineseLanguage] ? @"zh-CN" : @"en-US") forHTTPHeaderField:@"App-Language"];
    //    [_session.requestSerializer setValue:session.sdnAuthData.authToken forHTTPHeaderField:@"auth-token"];
    self.session.requestSerializer = requestSerializer;
    
    AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:0];
    responseSerializer.removesKeysWithNullValues = YES;
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    self.session.responseSerializer = responseSerializer;
}

- (void)auth:(NSString *)token {
    NSLog(@"[%@ auth:%@]", [self class], token);
    AFHTTPRequestSerializer* requestSerializer = self.session.requestSerializer;
    [requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
}

- (NSURLSessionDataTask *)send:(CAPHttpRequest *)request reply:(CAPHttpServiceCallback)reply {
    return [self.session  POST:request.URLString parameters:request.parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"success: %@", responseObject);
        reply([CAPHttpResponse responseWithData:responseObject]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error: %@", error);
        reply([CAPHttpResponse responseWithTask:task error:error]);
    }];
}

#pragma mark - API

- (NSURLSessionDataTask *)GET:(CAPHttpRequest *)request reply:(CAPHttpServiceCallback)reply {
    return [self.session  GET:request.URLString parameters:request.parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"GET success: %@", responseObject);
        reply([CAPHttpResponse responseWithData:responseObject]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"GET error: %@", error);
        reply([CAPHttpResponse responseWithTask:task error:error]);
    }];
}

- (NSURLSessionDataTask *)POST:(CAPHttpRequest *)request reply:(CAPHttpServiceCallback)reply {
    return [self.session  POST:request.URLString parameters:request.parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"POST success: %@", responseObject);
        reply([CAPHttpResponse responseWithData:responseObject]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"POST error: %@", error);
        reply([CAPHttpResponse responseWithTask:task error:error]);
    }];
}

- (NSURLSessionDataTask *)PUT:(CAPHttpRequest *)request reply:(CAPHttpServiceCallback)reply {
    return [self.session  PUT:request.URLString parameters:request.parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"PUT success: %@", responseObject);
        reply([CAPHttpResponse responseWithData:responseObject]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"PUT error: %@", error);
        reply([CAPHttpResponse responseWithTask:task error:error]);
    }];
}

- (NSURLSessionDataTask *)DELETE:(CAPHttpRequest *)request reply:(CAPHttpServiceCallback)reply {
    return [self.session  DELETE:request.URLString parameters:request.parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"DELETE success: %@", responseObject);
        reply([CAPHttpResponse responseWithData:responseObject]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"DELETE error: %@", error);
        reply([CAPHttpResponse responseWithTask:task error:error]);
    }];
}

- (NSURLSessionDataTask *)sendRequest:(CAPHttpRequest *)request reply:(CAPHttpServiceCallback)reply {
    NSString *method = request.method;
    NSLog(@"%@ %@\n%@", method, request.URLString, request.parameters);
    if([method isEqualToString:@"GET"]) {
        return [self GET:request reply:reply];
    } else if([method isEqualToString:@"POST"]) {
        return [self POST:request reply:reply];
    } else if([method isEqualToString:@"PUT"]) {
        return [self PUT:request reply:reply];
    } else if([method isEqualToString:@"DELETE"]) {
        return [self DELETE:request reply:reply];
    } else {
        NSLog(@"Invalid request method: %@", method);
        return nil;
    }
}
@end
