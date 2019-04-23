//
//  CAPAddDeviceShareAlertView.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/4/4.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPAddDeviceShareAlertView.h"

@interface CAPAddDeviceShareAlertView()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation CAPAddDeviceShareAlertView
- (IBAction)okAction:(id)sender {
    if (self.okBlock) self.okBlock();
}
+ (instancetype)instance {
    return [[[NSBundle mainBundle] loadNibNamed:@"CAPAddDeviceShareAlertView"
                                          owner:nil options:nil]lastObject];
}

- (void)fillContent:(NSString *)content deviceID:(NSString *)deviceID{
    self.contentLabel.text = content;
    self.deviceLabel.text = deviceID;
    self.sendButton.backgroundColor = [CAPColors red];
    [self.sendButton setTitle:CAPLocalizedString(@"ok") forState:UIControlStateNormal];
    [self.imgView setImage:GetImage(@"ic_default_avatar_new")];
}

@end
