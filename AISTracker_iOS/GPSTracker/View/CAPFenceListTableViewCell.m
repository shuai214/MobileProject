//
//  CAPFenceListTableViewCell.m
//  GPSTracker
//
//  Created by 曹帅 on 2019/1/3.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPFenceListTableViewCell.h"

@interface CAPFenceListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UISwitch *fenSwitch;

@end

@implementation CAPFenceListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setListData:(List *)list{
    self.nameLabel.text = list.name;
    self.creatDateLabel.text = [NSString dateFormateWithTimeInterval:list.createdAt];
    self.addressLabel.text = list.address;
    if ([list.status integerValue] == 1) {
        [self.fenSwitch setOn:YES animated:YES];
    }else{
        [self.fenSwitch setOn:NO animated:YES];
    }
    [self.fenSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];   // 开关事件切换通知

}
-(void)switchChange:(id)sender{
    UISwitch* openbutton = (UISwitch*)sender;
    BOOL ison = openbutton.isOn;
    if(ison){
        !_switchIsBlock ?  : _switchIsBlock(ison,self);
    }else{
        !_switchIsBlock ? : _switchIsBlock(ison,self);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
