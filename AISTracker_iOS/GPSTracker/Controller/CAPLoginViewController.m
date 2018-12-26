//
//  CAPLoginViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPLoginViewController.h"
#import "CAPViews.h"
#import "CAPSocialLoginResponse.h"
#import "CAPSocialService.h"
#import "CAPUser.h"
#import "CAPUserService.h"
@interface CAPLoginViewController ()

@end

@implementation CAPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)refreshLocalizedString {
    
}

- (IBAction)onWechatButtonClicked:(id)sender {
    CAPSocialService *service = WXAUTH;
    [service wechatLogin];
    service.loginSuccessBlock = ^(CAPSocialUser *socialUser) {
//        [self showMainPage];
        [self loadLoginUrl:socialUser];
    };
}

- (IBAction)onFacebookButtonClicked:(id)sender {
    [self showMainPage];
}

- (IBAction)onLineButtonClicked:(id)sender {
    [self showMainPage];
}

- (void)showMainPage {
    [self performSegueWithIdentifier:@"main.segue" sender:nil];
}
- (void)showPairPage{
    [self performSegueWithIdentifier:@"pair.segue" sender:nil];
}
- (void)loadLoginUrl:(CAPSocialUser *)user{
    CAPUserService *userService = [[CAPUserService alloc] init];
    [userService socialLogin:user reply:^(id response) {
        NSLog(@"%@",response);
        if ([response isKindOfClass:[CAPSocialLoginResponse class]]) {
            CAPSocialLoginResponse *loginResponse = response;
            if(loginResponse.isSucceed) {
                CAPUser *user = loginResponse.result;
                if (user.devices.count == 0) {
                    [self showPairPage];
                }else{
                    [self showMainPage];
                }
                [CAPUserDefaults setObject:user.oauth.accessToken forKey:@"accessToken"];
                [CAPUserDefaults setObject:user.oauth.refreshToken forKey:@"refreshToken"];
                [CAPUserDefaults setObject:user.account.userID forKey:@"userID"];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
                [CAPUserDefaults setObject:data forKey:@"CAP_User"];
            }
        }
        }];

}

@end
