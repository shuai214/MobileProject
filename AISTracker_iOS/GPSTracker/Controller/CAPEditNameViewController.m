//
//  CAPEditNameViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPEditNameViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CAPUserService.h"
#import "CAPDeviceService.h"
#import "CAPFetchUserProfileResponse.h"
@interface CAPEditNameViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation CAPEditNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.avatarImageView sd_setImageWithURL:self.avatarURL];
    self.title = CAPLocalizedString(@"nickname");
    
    self.nameTextField.placeholder = CAPLocalizedString(@"please_enter");
    if(self.defaultName) {
        self.nameTextField.text = self.defaultName;
    }
    if (self.capUser) {
        UIImage *avatar = GetImage(@"ic_default_avatar_new");
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",self.capUser.profile.avatarBaseUrl,self.capUser.profile.avatarPath]] placeholderImage:avatar];
        self.avatarImageView.layer.cornerRadius =  self.avatarImageView.width/2.0;
        self.avatarImageView.layer.masksToBounds = YES;
    }else if (self.capDevice){
        UIImage *avatar = GetImage(@"ic_default_avatar_new");
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",self.capDevice.setting.avatarBaseUrl,self.capDevice.setting.avatarPath]] placeholderImage:avatar];
        self.avatarImageView.layer.cornerRadius =  self.avatarImageView.width/2.0;
        self.avatarImageView.layer.masksToBounds = YES;
    }
}

- (void)refreshLocalizedString {
    
}

- (IBAction)onOkButtonClicked:(id)sender {

    if (self.nameTextField.text.length != 0) {
        if (!self.isUser) {
            self.capDevice.name = self.nameTextField.text;
        }else{
            self.capUser.profile.firstName = self.nameTextField.text;
        }
    }else{
        [gApp showNotifyInfo:CAPLocalizedString(@"please_enter") backGroundColor:[CAPColors red1]];
        return;
    }
    CAPWeakSelf(self);
    if (!self.isUser) {
        CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
        [deviceService updateDevice:self.capDevice reply:^(CAPHttpResponse *response) {
            NSDictionary *data = response.data;
            if ([[data objectForKey:@"code"] integerValue] == 200) {
                [gApp hideHUD];
                self.capDevice.name = [data objectForKey:@"name"];
                [CAPNotifications notify:kNotificationDeviceCountChange object:self.capDevice];
                [CAPAlertView initAlertWithContent:CAPLocalizedString(@"update_success") okBlock:^{
                    self->_updateSuccessBlock ?: self->_updateSuccessBlock(weakself.capDevice);
                    [weakself.navigationController popViewControllerAnimated:YES];
                } alertType:AlertTypeNoClose];
            }else{
                [gApp showHUD:[data objectForKey:@"message"] cancelTitle:@"确定" onCancelled:^{
                    [gApp hideHUD];
                }];
            }
        }];
    }else{
        CAPUserService *userService = [[CAPUserService alloc] init];
        [gApp showHUD:CAPLocalizedString(@"loading")];
        [userService putProfile:self.capUser reply:^(CAPFetchUserProfileResponse *response) {
            if (response.code == 200) {
                [gApp showNotifyInfo:CAPLocalizedString(@"update_success") backGroundColor:[CAPColors green1]];
                [CAPNotifications notify:kNotificationChangeNickName];
                [CAPAlertView initAlertWithContent:CAPLocalizedString(@"update_success") okBlock:^{
                    self->_updateSuccessBlock ?: self->_updateSuccessBlock( weakself.capUser);
                    [weakself.navigationController popViewControllerAnimated:YES];
                } alertType:AlertTypeNoClose];
            }
            [gApp hideHUD];
        }];
    }
}


@end
