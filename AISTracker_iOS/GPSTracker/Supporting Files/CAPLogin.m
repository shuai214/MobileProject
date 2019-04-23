//
//  CAPLogin.m
//  GPSTrackerSDK
//
//  Created by capaipai@sina.com on 2019/3/27.
//  Copyright © 2019年 capaipai. All rights reserved.
//

#import "CAPLogin.h"
#import "CAPUserService.h"
#import "CAPSocialLoginResponse.h"
#import "CAPSocialUser.h"
#import "CAPChooseDeviceTypeViewController.h"

@interface CAPLogin()
@property (strong, nonatomic) NSDictionary *profileDic;
@property (strong, nonatomic) UIWindow *window;

@end
@implementation CAPLogin
+ (instancetype)login {
    static id instance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (void)trueIdLoginUserInfo:(NSDictionary *)loginUserInfo{
    if (loginUserInfo == nil) {
        [capgApp showHUD:@"有误"];
        return;
    }
    self.profileDic = [NSDictionary dictionary];
    NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionary];
    userInfoDic[@"account"] = loginUserInfo[@"account"];
    NSDictionary *profileDic = loginUserInfo[@"profile"];
    NSString *openID = loginUserInfo[@"sub"];
    if (profileDic != nil) {
        NSString *appid = loginUserInfo[@"aud"];
        NSString *uid = loginUserInfo[@"sub"];
        NSString *email = profileDic[@"account_email"];
        NSString *expirationDate = [NSString stringWithFormat:@"%ld",([profileDic[@"exp"] integerValue] - [profileDic[@"iat"] integerValue])];
        NSString *accessToken = profileDic[@"account_email"];
        if (accessToken.length == 0) {
            accessToken = profileDic[@"account_mobile"];
        }
        NSString *name = profileDic[@"display_name"];
        
        if (name) userInfoDic[@"name"] = name;
        if (uid)   userInfoDic[@"uid"] = uid;
        if (appid)   userInfoDic[@"appid"] = appid;
        if (email)    userInfoDic[@"email"] = uid;
        if (accessToken)    userInfoDic[@"accessToken"] = accessToken;
        if (expirationDate)  userInfoDic[@"expiration"] = expirationDate;
        userInfoDic[@"type"] = [NSString stringWithFormat:@"%ld",CAPUserTypeTrue];
        NSString *content = [NSString stringWithFormat:@"iOS,%@,%@", [CAPPhones systemVersion], [CAPPhones phoneType]];
        userInfoDic[@"content"]=content;
    }
    self.profileDic = userInfoDic;
    [self userInfoDownloadWithOpenID:openID];
}

//与服务器交互
- (void)userInfoDownloadWithOpenID:(NSString *)openID{
    [capgApp showHUD:CAPLocalizedString(@"loading")];
    CAPUserService *userService = [[CAPUserService alloc] init];
    [userService socialLogin:self.profileDic reply:^(id response) {
        NSLog(@"%@",response);
        if ([response isKindOfClass:[CAPSocialLoginResponse class]]) {
            CAPSocialLoginResponse *loginResponse = response;
            if(loginResponse.code == 200){
                [CAPUserDefaults setObject:self.profileDic forKey:@"user_profileDic"];
                if(loginResponse.isSucceed) {
                    [capgApp hideHUD];
                    CAPUser *user = loginResponse.result;
                    [self showMainPage];
                    [CAPNotifications notify:kNotificationLoginDeviceCount object:user];
                    [CAPUserDefaults setObject:user.oauth.accessToken forKey:@"accessToken"];
                    [CAPUserDefaults setObject:user.oauth.refreshToken forKey:@"refreshToken"];
                    [CAPUserDefaults setObject:user.account.userID forKey:@"userID"];
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
                    [CAPUserDefaults setObject:data forKey:@"CAP_User"];
                }
            }else{
                [capgApp hideHUD];
                [CAPAlertView initAlertWithContent:loginResponse.message okBlock:^{
                    
                } alertType:AlertTypeNoClose];
            }
        }
    }];
}
- (void)showMainPage {
    self.window = [[UIApplication sharedApplication] keyWindow];
    CAPChooseDeviceTypeViewController *chooseDeviceVC = [[UIStoryboard storyboardWithName:@"ChooseDevice" bundle:nil] instantiateViewControllerWithIdentifier:@"CAPChooseDeviceTypeViewController"];
    if ([self.getCurrentViewController isKindOfClass:[UIWindow class]]) {
        UIViewController *viewController = chooseDeviceVC;
        UIViewController *vc = self.window.rootViewController;
        self.window.rootViewController = viewController;
        [vc removeFromParentViewController];
    }else{
        [self.getCurrentViewController presentViewController:chooseDeviceVC animated:YES completion:^{
            
        }];
    }
}
- (UIViewController *)getCurrentViewController
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到它
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    id nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
    //1、通过present弹出VC，appRootVC.presentedViewController不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        //2、通过navigationcontroller弹出VC
        NSLog(@"subviews == %@",[window subviews]);
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){//1、tabBarController
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //或者 UINavigationController * nav = tabbar.selectedViewController;
        result = nav.childViewControllers.lastObject;
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){//2、navigationController
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{//3、viewControler
        result = nextResponder;
    }
    return result;
}
@end
