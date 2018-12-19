//
//  CAPHttpResponse.h
//  GPSTracker
//
//  Created by user on 8/18/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAPHttpResponse : NSObject
@property (nonatomic, readonly, strong) id data;
@property (nonatomic, readonly, strong) NSURLSessionDataTask *task;
@property (nonatomic, readonly, strong) NSError *error;

+ (instancetype)responseWithData:(id)data;
+ (instancetype)responseWithTask:(NSURLSessionDataTask *)task error:(NSError *)error;

- (BOOL)isSucceed;
- (BOOL)isFailed;
@end
