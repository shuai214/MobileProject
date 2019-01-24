//
//  FYLoginViewController.m
//  ChildWatch
//
//  Created by fang yong on 30/7/18.
//  Copyright © 2018年 fang yong. All rights reserved.
//

#import "FYLoginViewController.h"
#import <TrueIDFramework/TrueIDFramework-Swift.h>
//#import "TYDPushHandle.h"
#import "AppDelegate.h"
//#import "TYDDataCenter.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "CAPUserService.h"
#import "CAPSocialLoginResponse.h"
#import "CAPSocialUser.h"
//#import "OpenPlatformAppRegInfo.h"
//#import "TYDAppProfileController.h"
@interface FYLoginViewController ()<TrueSDKLoginDelegate, TrueSDKRegisterDelegate, TrueSDKRefreshTokenDelegate>
@property (strong, nonatomic) NSDictionary *profileDic;
@property (strong, nonatomic) NSString *openID;
@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSDictionary *userInfoDic;

@end

@implementation FYLoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
  
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TrueIdPlatformAuth shareInstance].registerDelegate = self;
    [TrueIdPlatformAuth shareInstance].loginDelegate = self;
    [TrueIdPlatformAuth shareInstance].refreshTokenDelegate = self;
    UIImageView *backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    backImgView.image = [UIImage imageNamed:@"AW_Login_Screen_Find_for_U_OK"];
    [self.view addSubview:backImgView];
    
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 80)];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    loginBtn.xCenter = Main_Screen_Width * 0.5;
    loginBtn.yCenter = 35.0 / 96 * Main_Screen_Height;
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 80)];
    [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    registerBtn.xCenter = loginBtn.xCenter;
    registerBtn.yCenter = (1283.0 / 1920) * Main_Screen_Height;
    [registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];

    Boolean isLogin = [[TrueIdPlatformAuth shareInstance] getAccessToken] != NULL;
    NSLog(@"%@",[[TrueIdPlatformAuth shareInstance] getAccessToken]);
    if (isLogin == TRUE){
        
        [self loginAction];
        
    }
    
}


- (void)loginAction{
    [[TrueIdPlatformAuth shareInstance] startService];
    [[TrueIdPlatformAuth shareInstance] login];
}

- (void)registerAction{
    
    [[TrueIdPlatformAuth shareInstance] registerWithIsAutoLogin:YES];
}


- (void)onRegisterSuccessWithUserProfileData:(NSDictionary * _Nullable)userProfileData{
    
    NSLog(@"register success:%@",userProfileData);
//    self.noticeText = TYDLocalizedString(@"registerSuccess");
}
- (void)onRegisterErrorWithErrorMessage:(NSString * _Nullable)errorMessage{
    
    NSLog(@"register error:%@",errorMessage);
//    self.noticeText = TYDLocalizedString(@"注册失败");
}



- (void)onLoginSuccess:(NSDictionary * _Nonnull)userProfileData expiredTimeInSecond:(NSInteger)expiredTimeInSecond{
    NSLog(@"success:%@",userProfileData);
//    [self progressHUDShowWithText:nil];
    [[TrueIdPlatformAuth shareInstance] setTokenForLoginFromTempServiceWithRefreshToken:[userProfileData objectForKey:@"access_token"] accessToken:[userProfileData objectForKey:@"refresh_token"]];
    CAPWeakSelf(self);
    [[TrueIdPlatformAuth shareInstance] getLoginInfo:^(NSDictionary * _Nonnull userInfo) {
//        [wself progressHUDHideImmediately];
        NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionary];
        weakself.account = userInfo[@"account"];
        userInfoDic[@"account"] = weakself.account;
        weakself.openID = userInfo[@"sub"];
        NSDictionary *profileDic = userInfo[@"profile"];

        if (profileDic != nil) {
            
            NSString *appid = userInfo[@"aud"];
            NSString *nickName = profileDic[@"display_name"];
            NSString *openId = profileDic[@"uid"];
            NSString *phone = profileDic[@"account_mobile"];
            NSString *expirationDate = profileDic[@"iat"];
            NSString *email = profileDic[@"account_email"];

            if (nickName) userInfoDic[@"name"] = nickName;
            if (openId)   userInfoDic[@"uid"] = openId;
            if (appid)   userInfoDic[@"appid"] = appid;
            if (phone)    userInfoDic[@"mobile"] = phone;
            if (email)    userInfoDic[@"email"] = email;
            userInfoDic[@"type"] = [NSString stringWithFormat:@"%ld",CAPUserTypeTrue];
            userInfoDic[@"accessToken"] = openId;

         
        }
        
        self.profileDic = userInfoDic;
        
        [weakself userInfoDownloadWithOpenID:weakself.openID];
        
    } failed:^(NSDictionary * _Nonnull error) {

        NSLog(@"error:%@",error);
    }];
    
}
- (void)onLoginError:(NSDictionary * _Nonnull)errorMessage{
//    self.noticeText = TYDLocalizedString(@"logFail");
    [CAPToast toastError:@"logFail"];
//    [[TrueIdPlatformAuth shareInstance] recoveryWithIsAutoLogin:YES];
}
- (void)onForgetPasswordSuccess:(NSDictionary * _Nonnull)response{
    
}
- (void)cancelLoginTrueIDView{
    
}
- (void)onRevokeAlready{
    
}


//与服务器交互
- (void)userInfoDownloadWithOpenID:(NSString *)openID
{

    [gApp showHUD:@"正在加载，请稍候..."];
    CAPUserService *userService = [[CAPUserService alloc] init];
    [userService socialLogin:self.profileDic reply:^(id response) {
        NSLog(@"%@",response);
        if ([response isKindOfClass:[CAPSocialLoginResponse class]]) {
            CAPSocialLoginResponse *loginResponse = response;
            if(loginResponse.isSucceed) {
                [gApp hideHUD];
                CAPUser *user = loginResponse.result;

                [self showMainPage];

                [CAPNotifications notify:kNotificationLoginDeviceCount object:user];
                [CAPUserDefaults setObject:user.oauth.accessToken forKey:@"accessToken"];
                [CAPUserDefaults setObject:user.oauth.refreshToken forKey:@"refreshToken"];
                [CAPUserDefaults setObject:user.account.userID forKey:@"userID"];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
                [CAPUserDefaults setObject:data forKey:@"CAP_User"];
            }
        }
    }];
}
- (void)showMainPage {
    [self performSegueWithIdentifier:@"main.segue" sender:nil];
}
- (void)showPairPage{
    [self performSegueWithIdentifier:@"choose.segue" sender:nil];
}

@end
