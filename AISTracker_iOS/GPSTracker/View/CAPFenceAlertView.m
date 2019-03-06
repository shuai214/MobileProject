//
//  CAPFenceAlertView.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/2/19.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPFenceAlertView.h"
@interface CAPFenceAlertView()
@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;

@end
@implementation CAPFenceAlertView

+ (instancetype)instance {
    return [[[NSBundle mainBundle] loadNibNamed:@"CAPFenceAlertView"
                                          owner:nil options:nil]lastObject];
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"CAPFenceAlertView" owner:self options:nil]lastObject];
    }
    return self;
}
- (void)fillData:(CAPDevice *)deviceInfo content:(NSString *)content{
    self.alertLabel.text = content;
    [self.deviceImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",deviceInfo.avatarBaseUrl,deviceInfo.avatarPath]] placeholderImage:GetImage(@"ic_default_avatar_new")];
}
- (IBAction)cloaseButtonAction:(id)sender {
    if (self.closeBlock) self.closeBlock();
}

@end
