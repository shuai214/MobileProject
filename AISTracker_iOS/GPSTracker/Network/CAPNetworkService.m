////
////  CAPNetworkService.m
////  GPSTracker
////
////  Created by user on 8/18/16.
////  Copyright © 2016 capelabs. All rights reserved.
////
//
//#import "CAPNetworkService.h"
//#import <AFNetworking/AFNetworking.h>
//
//@interface CAPNetworkService () {
//    AFHTTPSessionManager *_session;
//}
//
//@end
//
//@implementation CAPNetworkService
//+ (instancetype)defaultService {
//    static id instance = NULL;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[CAPNetworkService alloc] init];
//    });
//    return instance;
//}
//
//- (id)init {
//    if (self = [super init]) {
//        [self setup];
//    }
//    return self;
//}
//
//- (void)setup {
//    _session = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"host"]];
//    _session.securityPolicy.allowInvalidCertificates = YES;
//    _session.securityPolicy.validatesDomainName = NO;
//    
//    AFHTTPRequestSerializer* requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:0];
//    requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
//    requestSerializer.timeoutInterval = 90;
//    //[requestSerializer setValue:@"ios" forHTTPHeaderField:@"source"];
////    [_session.requestSerializer setValue:session.sdnAuthData.authToken forHTTPHeaderField:@"auth-token"];
//    _session.requestSerializer = requestSerializer;
//    
//    
//    AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:0];
//    responseSerializer.removesKeysWithNullValues = YES;
//    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
//    _session.responseSerializer = responseSerializer;
//}
//@end
