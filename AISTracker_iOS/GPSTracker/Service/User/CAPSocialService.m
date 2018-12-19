//
//  CAPSocialService.m
//  GPSTracker
//
//  Created by WeifengYao on 3/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#define WECHAT_APP_ID @"wxc012f97d7d6f3c3f"
#define WECHAT_SECRET_KEY @"446b2b643deb24fe5cdd65565ba5ebb1"

#import "CAPSocialService.h"
#import "CAPToast.h"
#import "WXApi.h"
#import "CAPNotifications.h"
#import "CAPSocialUser.h"
#import "CAPHttpRequest.h"
#import "CAPHttpService.h"

@implementation CAPSocialService

- (id)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    NSLog(@"[%@ setup]", [self class]);
    
    [WXApi registerApp:WECHAT_APP_ID];
    
    [CAPNotifications addObserver:self
                         selector:@selector(didReceiveWechatLoginNotification:)
                             name:kNotificationWechatLogin
                           object:nil];
    
    NSLog(@"Wechat installed? %@", ([WXApi isWXAppInstalled] ? @"YES" : @"NO"));
}

- (void)wechatLogin {
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq* req = [SendAuthReq new];
        req.scope = @"snsapi_userinfo" ;
        req.state = @"AIS Tracker" ;
        [WXApi sendReq:req];
    } else {
        [CAPToast toastError:NSLocalizedString(@"no_wechat_error", nil)];
    }
}

- (void)facebookLogin {
    
}

- (void)lineLogin {
    
}

- (void)socialLogin:(CAPSocialUser *)socialUser {
    NSLog(@"[%@ socialLogin:%@]", [self class], socialUser);
    __weak typeof(self)weakSelf = self;
//    [_userService socialLogin:user reply:^(id response) {
//        CAPSocialLoginResponse *res = response;
//        NSLog(@"[%@ socialLogin: %@]", [weakSelf class], res);
//        if(res.isSucceed) {
//            if(res.result.oauth) {
//                [[CAPHttpService defaultService] auth:res.result.oauth.accessToken];
//            }
//
//            CAPUser *user = res.result;
//            user.type = user.type;
//        }
//        reply(res);
//    }];
    
//    if([self assureNetwork]) {
//        [gApp showHUD];
//        __weak typeof(self)weakSelf = self;
//        [[CAPUserHandler defaultHandler] socialLogin:socialUser reply:^(CAPSocialLoginResponse *res) {
//            [gApp hideHUD];
//            if(res.isSucceed) {
//                CAPUser *user = res.result;
//                user.type = user.type;
//                if([CAPValidators validPhoneNumber:user.info.mobile]) {
//                    [[CAPUserHandler defaultHandler] login:user];
//                } else {
//                    [weakSelf performSegueWithIdentifier:@"mobile.setting.segue" sender:user];
//                }
//            } else if(res.code == 455) {
//                [weakSelf performSegueWithIdentifier:@"mobile.setting.segue" sender:socialUser];
//            } else {
//                if([res assureSpecificError]) {
//                    [CAPToast toastError:NSLocalizedString(@"sign_in_failure_tips", nil)];
//                }
//            }
//        }];
//    }
}

#pragma mark - Notification
- (void)didReceiveWechatLoginNotification:(NSNotification*)noti {
    NSLog(@"[%@ didReceiveWechatLoginNotification:]", [self class]);
    NSString* code = noti.object;
    NSDictionary* params = @{
                             @"appid": WECHAT_APP_ID,
                             @"secret": WECHAT_SECRET_KEY,
                             @"code": code,
                             @"grant_type": @"authorization_code",
                             };
    
    CAPHttpRequest *request = [[[CAPHttpRequest newBuilder:@"https://api.weixin.qq.com/sns/oauth2/access_token" method:@"GET"] addParameters:params] build];
    CAPHttpService *service = [CAPHttpService defaultService];
    //req.timeoutInterval = 30;
    __weak typeof(self)weakSelf = self;
//    [gApp showHUD];
    [service sendRequest:request reply:^(CAPHttpResponse *response) {
        if(response.isSucceed) {
            NSDictionary *dict = response.data;
            NSLog(@"data: %@", dict);
            CAPSocialUser *user = [CAPSocialUser new];
            user.type = CAPUserTypeWechat;
            user.appID = WECHAT_APP_ID;
            user.accessToken = dict[@"access_token"];
            user.expirationDate = [dict[@"expires_in"] doubleValue];
            user.openID = dict[@"openid"];
            user.refreshToken = dict[@"refresh_token"];
            user.unionID = dict[@"unionid"];
        } else {
            NSLog(@"ERROR: %@", response.error);
        }
    }];
}
@end
