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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
