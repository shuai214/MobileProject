//
//  CAPResponse.m
//  GPSTracker
//
//  Created by user on 8/18/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPResponse.h"
#import "JSONKeyMapper.h"
#import "CAPNotifications.h"

#import "CAPToast.h"

@interface CAPResponse ()
@property (nonatomic, readwrite, strong) NSError *error;
@property (nonatomic, strong) NSDictionary *dict;
@end

@implementation CAPResponse

+ (instancetype)responseWithHttpResponse:(CAPHttpResponse *)response {
    CAPResponse *res;
    if(response.error) {
        res = [[self alloc] init];
        if(response.task.response) {
            res.code = ((NSHTTPURLResponse *)response.task.response).statusCode;
        } else {
            res.code = -1001;
        }
        res.error = response.error;
    } else {
        NSDictionary *dictionary = response.data;
        NSError *error;
        res = [[self alloc] initWithDictionary:dictionary error:&error];
        res.code = [dictionary[@"code"] integerValue];
        res.status = dictionary[@"status"];
        res.message = dictionary[@"message"];
        if(res.code != kResponseCodeSuccess) {
            res.dict = dictionary[@"result"];
        }
        
        if(error) {
            res.error = error;
        } else if(res.code == 0 && dictionary[@"error"]) {
            res.error = dictionary[@"error"];
            res.message = dictionary[@"message"];
        }
    }
    return res;
}

//+ (instancetype)responseWithDictionary:(NSDictionary *)dictionary {
//    NSError *error;
//    CAPResponse *response = [[self alloc] initWithDictionary:dictionary error:&error];
//    response.code = [dictionary[@"code"] integerValue];
//    response.status = dictionary[@"status"];
//    response.message = dictionary[@"message"];
//    if(error) {
//        response.error = error;
//    }
//    return response;
//}
//
//+ (instancetype)responseWithTask:(NSURLSessionDataTask *)task error:(NSError *)error {
//    CAPResponse *response = [[self alloc] init];
//    response.code = ((NSHTTPURLResponse *)task.response).statusCode;
//    response.error = error;
//    return response;
//}

//+ (instancetype)responseWithError:(NSError *)error {
//    CAPResponse *response = [[self alloc] init];
//    response.error = error;
//    return response;
//}

//+ (instancetype)responseWithCode:(NSInteger)code status:(NSString *)status message:(NSString *)message {
//    CAPResponse *response = [[self alloc] init];
//    response.code = code;
//    response.status = status;
//    response.message = message;
//    return response;
//}

+ (JSONKeyMapper *)keyMapper {
//    return [[JSONKeyMapper alloc] initWithDictionary:@{
//                                                       @"code": @"StatusCode",
//                                                       @"message": @"Message",
//                                                       @"status": @"Status"
//                                                       }];
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"StatusCode": @"code",
                                                       @"Message": @"message",
                                                       @"Status": @"status"
                                                       }];
}

//+(BOOL)propertyIsOptional:(NSString*)propertyName {
//    return YES;
//}

- (NSString *)getMessage {
    if(self.error != nil) {
        return @"无法访问服务器";
    } else {
        return _message;
    }
}

- (BOOL)isSucceed {
    return self.error == nil && self.code == kResponseCodeSuccess;
}

- (BOOL)isFailed {
    //return ![self isSucceed];
    return self.error != nil || self.code != kResponseCodeSuccess;
}

- (BOOL)assureSpecificError {
    //- (BOOL)assureSpecificNetworkError:(NSURLResponse *)response {
    //NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
//    CAPResponse *res = response;
    NSString *message;
    if(self.code == -1001) {
        message = NSLocalizedString(@"network_timeout_error", nil);
    } else if(self.code == 400) {
        message = NSLocalizedString(@"httpCode400", nil);
    } else if(self.code == 401) {
        message = NSLocalizedString(@"httpCode401", nil);
    } else if(self.code == 403) {
        message = NSLocalizedString(@"httpCode403", nil);
        //[CAPNotifications notify:kNotificationAccountExpired object:nil];
    } else if(self.code == 404) {
        message = NSLocalizedString(@"httpCode404", nil);
    } else if(self.code == 409) {
        message = NSLocalizedString(@"httpCode409", nil);
    } else if(self.code == 419) {
        message = NSLocalizedString(@"httpCode419", nil);
    } else if(self.code == 429) {
        message = NSLocalizedString(@"httpCode429", nil);
    } else if(self.code == 437) {
        message = NSLocalizedString(@"httpCode437", nil);
    } else if(self.code == 438) {
        message = NSLocalizedString(@"httpCode438", nil);
    } else if(self.code == 439) {
        message = NSLocalizedString(@"httpCode439", nil);
    } else if(self.code == 444) {
        message = NSLocalizedString(@"httpCode444", nil);
    } else if(self.code == 449) {
        if(self.dict && self.dict[@"username"]) {
            message = [NSString stringWithFormat:@"%@ (%@)", NSLocalizedString(@"httpCode449", nil), self.dict[@"username"]];
        } else {
            message = NSLocalizedString(@"httpCode449", nil);
        }
    } else if(self.code == 451) {
        message = NSLocalizedString(@"httpCode451", nil);
    } else if(self.code == 452) {
        message = NSLocalizedString(@"httpCode452", nil);
    } else if(self.code == 453) {
        message = NSLocalizedString(@"httpCode453", nil);
    } else if(self.code == 454) {
        message = NSLocalizedString(@"httpCode454", nil);
    } else if(self.code == 455) {
        message = NSLocalizedString(@"httpCode455", nil);
    } else if(self.code == 457) {
        message = NSLocalizedString(@"httpCode457", nil);
    } else if(self.code == 458) {
        message = NSLocalizedString(@"httpCode458", nil);
    } else if(self.code == 500) {
        message = NSLocalizedString(@"httpCode500", nil);
    } else if(self.code == 501) {
        message = NSLocalizedString(@"httpCode501", nil);
    } else {
        return YES;
    }
    NSLog(@"[%@ specific network error: %@]", [self class], message);
    [CAPToast toastError:message];
    if(self.code == 403) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [CAPNotifications notify:kNotificationAccountExpired object:nil];
        });
    }
    return NO;
}
@end
