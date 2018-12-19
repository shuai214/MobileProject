//
//  CAPHttpResponse.m
//  GPSTracker
//
//  Created by user on 8/18/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPHttpResponse.h"

@interface CAPHttpResponse ()
@property (nonatomic, readwrite, strong) id data;
@property (nonatomic, readwrite, strong) NSURLSessionDataTask *task;
@property (nonatomic, readwrite, strong) NSError *error;
@end

@implementation CAPHttpResponse
+ (instancetype)responseWithData:(id)data {
    CAPHttpResponse *response = [CAPHttpResponse new];
    response.data = data;
    return response;
}

+ (instancetype)responseWithTask:(NSURLSessionDataTask *)task error:(NSError *)error {
    CAPHttpResponse *response = [CAPHttpResponse new];
    response.task = task;
    response.error = error;
    return response;
}

- (BOOL)isSucceed {
    return self.error == nil;
}

- (BOOL)isFailed {
    return self.error != nil;
}
@end
