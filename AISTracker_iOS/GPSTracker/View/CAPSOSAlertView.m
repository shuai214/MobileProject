//
//  CAPSOSAlertView.m
//  GPSTracker
//
//  Created by 曹帅 on 2019/1/21.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPSOSAlertView.h"

@interface CAPSOSAlertView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sosImageView;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (nonatomic,strong)MQTTInfo *info;
@end
@implementation CAPSOSAlertView

+ (instancetype)instance {
    return [[[NSBundle mainBundle] loadNibNamed:@"CAPSOSAlertView"
                                          owner:nil options:nil]lastObject];
}
- (void)fillData:(MQTTInfo *)info{
    self.info = info;
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@",info.deviceID,CAPLocalizedString(@"message_type_sos")];
    NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:self.info.data options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    // 将NSData转为UIImage
    UIImage *decodedImage = [UIImage imageWithData:decodeData];
    [self.sosImageView setImage:decodedImage];
    [self.deviceImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",info.userProfile.avatarBaseUrl,info.userProfile.avatarPath]] placeholderImage:GetImage(@"ic_default_avatar_new")];
}
- (IBAction)closeButton:(id)sender {
      if (self.closeAddressBlock) self.closeAddressBlock();
}

- (IBAction)intoMapViewAction:(id)sender {
    if (self.okAddressBlock) self.okAddressBlock(self.info);
}

@end
