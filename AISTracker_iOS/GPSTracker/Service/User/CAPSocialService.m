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
#import "CAPNotifications.h"
//#import "CAPSocialUser.h"
#import "CAPHttpRequest.h"
#import "CAPHttpService.h"
#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

@interface CAPSocialService ()

@end
@implementation CAPSocialService
+ (CAPSocialService *)sharedInstance{
    
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        
        return [[self alloc] init];
    });
}
- (id)init {
    if (self = [super init]) {
//        [self setup];
//        [CAPNotifications addObserver:self
//                                 selector:@selector(didReceiveWechatLoginNotification:)
//                                     name:kNotificationWechatLogin
//                                   object:nil];
//
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveWechatLoginNotification:) name:@"111" object:nil];
    }
    return self;
}

//- (void)setup {
//    NSLog(@"[%@ setup] %@", [self class],kNotificationWechatLogin);
//
//
//
//    NSLog(@"Wechat installed? %@", ([WXApi isWXAppInstalled] ? @"YES" : @"NO"));
//}

- (void)wechatLogin {
//    [WXApi registerApp:WECHAT_APP_ID];
//
//    if ([WXApi isWXAppInstalled]) {
//        SendAuthReq* req = [SendAuthReq new];
//        req.scope = @"snsapi_userinfo" ;
//        req.state = @"AIS Tracker" ;
//        [WXApi sendReq:req];
//    } else {
//        [CAPToast toastError:NSLocalizedString(@"no_wechat_error", nil)];
//    }
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
//        [capgApp showHUD];
//        __weak typeof(self)weakSelf = self;
//        [[CAPUserHandler defaultHandler] socialLogin:socialUser reply:^(CAPSocialLoginResponse *res) {
//            [capgApp hideHUD];
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
- (void)didReceiveWechatLogin:(NSString*)code {
    NSLog(@"[%@ didReceiveWechatLoginNotification:]", [self class]);
    NSString* codeStr = code;
    NSDictionary* params = @{
                             @"appid": WECHAT_APP_ID,
                             @"secret": WECHAT_SECRET_KEY,
                             @"code": codeStr,
                             @"grant_type": @"authorization_code",
                             };
    
    CAPHttpRequest *request = [[[CAPHttpRequest newBuilder:@"https://api.weixin.qq.com/sns/oauth2/access_token" method:@"GET"] addParameters:params] build];
    CAPHttpService *service = [CAPHttpService defaultService];
    //req.timeoutInterval = 30;
    __weak typeof(self)weakSelf = self;
//    [capgApp showHUD];
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
            NSString *access_token = dict[@"access_token"];
            if (access_token && [access_token length] != 0) { // 通过验证才可继续登录，如果只有 openId 是不行的，保险起见。
                !self.loginSuccessBlock ? : self.loginSuccessBlock(user);
            }
        } else {
            
        }
    }];
}

- (BOOL)handleOpenURL:(NSURL *)url{
    BOOL ok = NO;
    if ([url.scheme hasPrefix:@"wx"]) {
//        ok = [WXApi handleOpenURL:url delegate:self];
    }
    else if ([url.scheme hasPrefix:@"tencent"]) {
//        ok = [TencentOAuth HandleOpenURL:url];
    }
    else if ([url.scheme hasPrefix:@"wb"]) {
        //ok = [WeiboSDK handleOpenURL:url delegate:self];
    }
    return ok;
}
#pragma mark - WXApiDelegate
/*! @brief 接收并处理来自微信终端程序的事件消息
 *
 * 接收并处理来自微信终端程序的事件消息，期间微信界面会切换到第三方应用程序。
 * WXApiDelegate 会在handleOpenURL:delegate:中使用并触发。
 */

/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
//- (void)onReq:(BaseReq*)req {
////    DLog(@"%s", __FUNCTION__);
//}
//
///*! @brief 发送一个sendReq后，收到微信的回应
// *
// * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
// * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
// * @param resp具体的回应内容，是自动释放的
// */
//- (void)onResp:(BaseResp*)resp {
////    DLog(@"%s", __FUNCTION__);
//    if ([resp isKindOfClass:[SendAuthResp class]]) {
//        SendAuthResp* res = (SendAuthResp*)resp;
//        if (res.code) {
////            NSLog(@"%@", kNotificationWechatLogin);
////            [CAPNotifications notify:kNotificationWechatLogin object:res.code];
////            DLog(@"[*]Wechat Login with code: %@", res.code);
//            [self didReceiveWechatLogin:res.code];
//        }
//    }
//}

@end
