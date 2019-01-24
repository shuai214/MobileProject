//
//  CAPGuardianTableViewCell.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/8.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPGuardianTableViewCell.h"

@interface  CAPGuardianTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@end

@implementation CAPGuardianTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setFrame:(CGRect)frame
{
    //修改cell的左右边距为10;
    //修改cell的Y值下移10;
    //修改cell的高度减少10;
    
    static CGFloat margin = 10;
    frame.origin.x = margin;
    frame.size.width -= 2 * frame.origin.x;
    frame.origin.y += margin;
    frame.size.height -= margin;
    
    [super setFrame:frame];
    self.imgView.layer.cornerRadius =  self.imgView.width/2.0;
    self.imgView.layer.masksToBounds = YES;
}

- (void)setDeviceInfo:(USERS *)user{
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",user.profile.avatarBaseUrl,user.profile.avatarPath]] placeholderImage:GetImage(@"user_default_avatar")];
    self.nameLabel.text = user.profile.firstName;
    self.telLabel.text = user.device.sos ? user.device.sos : @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
