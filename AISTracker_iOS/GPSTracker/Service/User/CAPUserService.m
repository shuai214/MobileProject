//
//  CAPUserService.m
//  GPSTracker
//
//  Created by user on 8/18/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPUserService.h"
#import "CAPSignInResponse.h"
#import "CAPSignOutResponse.h"
#import "CAPSocialLoginResponse.h"

#import "CAPFetchUserProfileResponse.h"
#import "CAPUpdateUserProfileResponse.h"
#import "CAPReadUserSettingResponse.h"
#import "CAPUpdateUserSettingResponse.h"
#import "CAPPhones.h"
#import "CAPCheckRemoteSettingResponse.h"

@implementation CAPUserService
//+ (instancetype)defaultService {
//    static id instance = NULL;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[self alloc] init];
//    });
//    return instance;
//}

- (void)signIn:(NSString *)phoneNumber countryCode:(NSString *)countryCode captcha:(NSString *)captcha reply:(CAPServiceReply)reply {
    NSString *content = [NSString stringWithFormat:@"iOS,%@,%@", [CAPPhones systemVersion], [CAPPhones phoneType]];
    NSDictionary *params = @{
                             @"mobile": [NSString stringWithFormat:@"%@ %@", countryCode, phoneNumber],
                             @"verifyCode": captcha,
                             @"content": content,
                             @"device_connected": @"1",
                             @"device_uuid": @"1234",
                             @"app_uuid": @"5678"
                             };
    CAPHttpRequest *request = [self buildRequest:@"Account/SignIn" method:@"POST" parameters:params];
    [self sendRequest:request reply:^(CAPHttpResponse *response) {
        reply([CAPSignInResponse responseWithHttpResponse:response]);
    }];
}

- (void)signOut:(CAPServiceResponse)reply {
    CAPHttpRequest *request = [self buildRequest:@"Account/SignOut" method:@"POST"];
    [self sendRequest:request reply:^(CAPHttpResponse *response) {
        reply([CAPResponse responseWithHttpResponse:response]);
    }];
}

- (void)socialLogin:(CAPSocialUser *)user reply:(CAPServiceReply)reply {
    NSLog(@"[%@ socialLogin:]", [self class]);
    NSString *content = [NSString stringWithFormat:@"iOS,%@,%@", [CAPPhones systemVersion], [CAPPhones phoneType]];
    NSDictionary *params = @{
                             @"uid": user.openID,
                             @"accessToken": user.accessToken,
                             @"refreshToken": (user.refreshToken ? user.refreshToken : @""),
                             @"expirationDate": @(user.expirationDate),
                             @"appid": user.appID,
                             @"unionid": (user.unionID ? user.unionID : @""),
                             @"type": @(user.type),
                             @"content": content,
                             @"mobile" : (user.mobile ? user.mobile : @""),
                             @"verifyCode" : (user.verifyCode ? user.verifyCode : @""),
                             @"device_connected": @"1",
                             @"device_uuid": @"1234",
                             @"app_uuid": @"5678"
                             };
    CAPHttpRequest *request = [self buildRequest:(user.mobile && user.mobile ? @"Account/ThirdSignInPlus" : @"Account/ThirdSignIn" ) method:@"POST" parameters:params];
    [self sendRequest:request reply:^(CAPHttpResponse *response) {
        reply([CAPSocialLoginResponse responseWithHttpResponse:response]);
    }];
}

- (void)fetchProfile:(CAPServiceReply)reply {
    CAPHttpRequest *request = [self buildRequest:@"Account/Profile" method:@"GET"];
    [self sendRequest:request reply:^(CAPHttpResponse *response) {
        reply([CAPFetchUserProfileResponse responseWithHttpResponse:response]);
    }];
}

- (void)checkRemoteSetting:(CAPServiceReply)reply {
    CAPHttpRequest *request = [self buildRequest:@"Account/RemoteSetting"];
    [self sendRequest:request reply:^(CAPHttpResponse *response) {
        reply([CAPCheckRemoteSettingResponse responseWithHttpResponse:response]);
    }];
}
@end
