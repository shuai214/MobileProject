//
//  CAPResponse.h
//  GPSTracker
//
//  Created by user on 8/18/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAPBaseJSON.h"
#import "CAPHttpResponse.h"

static const NSUInteger kResponseCodeSuccess = 200;

@interface CAPResponse : CAPBaseJSON
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, readonly, strong) NSError *error;

//@property (strong, nonatomic) NSNumber<Optional>* uuid;
//@property (strong, nonatomic) NSString<Ignore>* customProperty;
+ (instancetype)responseWithHttpResponse:(CAPHttpResponse *)response;
//+ (instancetype)responseWithDictionary:(NSDictionary *)dictionary;
////+ (instancetype)responseWithError:(NSError *)error;
//+ (instancetype)responseWithTask:(NSURLSessionDataTask *)task error:(NSError *)error;

//+ (JSONKeyMapper *)keyMapper;
//+ (instancetype)responseWithCode:(NSInteger)code status:(NSString *)status message:(NSString *)message;
- (BOOL)isSucceed;
- (BOOL)isFailed;
- (BOOL)assureSpecificError;
@end
