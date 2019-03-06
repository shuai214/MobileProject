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

- (void)socialLogin:(NSMutableDictionary *)user reply:(CAPServiceReply)reply {
    NSLog(@"[%@ socialLogin:]", [self class]);
    
    CAPHttpRequest *request = [self buildRequest:@"Account/ThirdSignInPlus"method:@"POST" parameters:user];
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
- (void)putProfile:(CAPUser *)user reply:(CAPServiceReply)reply{
    if (user) {
        NSDictionary *params = @{
                                 @"firstName": (user.profile.firstName ? user.profile.firstName:@""),
                                 @"mobile": (user.info.mobile ? user.info.mobile:@""),
                                 @"avatarPath": (user.profile.avatarPath ? user.profile.avatarPath:@""),
                                 @"avatarBaseUrl": (user.profile.avatarBaseUrl ? user.profile.avatarBaseUrl:@""),
                                 @"locale":(user.profile.locale ? user.profile.locale : @"")
                                 };
        CAPHttpRequest *request = [self buildRequest:@"Account/Profile" method:@"PUT" parameters:params];
        [self sendRequest:request reply:^(CAPHttpResponse *response) {
            reply([CAPFetchUserProfileResponse responseWithHttpResponse:response]);
        }];
    }else{
        [gApp hideHUD];
    }
    
}
- (void)checkRemoteSetting:(CAPServiceReply)reply {
    CAPHttpRequest *request = [self buildRequest:@"Account/RemoteSetting"];
    [self sendRequest:request reply:^(CAPHttpResponse *response) {
        reply([CAPCheckRemoteSettingResponse responseWithHttpResponse:response]);
    }];
}
@end
