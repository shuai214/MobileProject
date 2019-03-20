

//
//  CAPAddFenceTableViewCell.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/25.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPAddFenceTableViewCell.h"
#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

@interface CAPAddFenceTableViewCell()

@property (strong, nonatomic)  UILabel *fenceName;
@property (strong, nonatomic)  UILabel *fenceDetail;
@property (strong, nonatomic)  UILabel *numLabel;
@property (strong, nonatomic)  UIImageView *fenceImageView;
@end
@implementation CAPAddFenceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _fenceImageView = [UIImageView new];
        
        _numLabel = [UILabel new];
        _numLabel.textColor = [UIColor whiteColor];
        _numLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.numberOfLines = 0;
        _numLabel.backgroundColor = [UIColor clearColor];
        
        _fenceName = [UILabel new];
        _fenceName.textColor = [UIColor lightGrayColor];
        _fenceName.font = [UIFont boldSystemFontOfSize:18.0f];
        _fenceName.textAlignment = NSTextAlignmentLeft;
        _fenceName.numberOfLines = 0;
        
        _fenceDetail = [UILabel new];
        _fenceDetail.textColor = [UIColor lightGrayColor];
        _fenceDetail.font = [UIFont boldSystemFontOfSize:16.0f];
        _fenceDetail.textAlignment = NSTextAlignmentLeft;
        _fenceDetail.numberOfLines = 0;
        [self.contentView sd_addSubviews:@[_fenceImageView,_numLabel,_fenceName,_fenceDetail]];
        
        
        _fenceImageView.sd_layout
        .centerYEqualToView(self.contentView)
        .leftSpaceToView(self.contentView, 10)
        .widthIs(28)
        .heightIs(28);
        
        _numLabel.sd_layout
        .topEqualToView(_fenceImageView)
        .leftEqualToView(_fenceImageView)
        .rightEqualToView(_fenceImageView)
        .heightIs(_fenceImageView.width - 2);
        
        _fenceName.sd_layout
        .topSpaceToView(self.contentView, 5)
        .leftSpaceToView(_fenceImageView, 5)
        .rightSpaceToView(self.contentView, 5)
        .autoHeightRatio(0);
        
        _fenceDetail.sd_layout
        .topSpaceToView(_fenceName, 5)
        .leftSpaceToView(_fenceImageView, 5)
        .rightSpaceToView(self.contentView, 5)
        .autoHeightRatio(0);
        [self setupAutoHeightWithBottomView:_fenceDetail bottomMargin:5];

    }
    return self;
}
- (void)setGooglePlace:(CAPGooglePlace *)googlePlace{
    _googlePlace = googlePlace;
    [_fenceImageView setImage:GetImage(@"map_drop_blue")];
    _fenceName.text = _googlePlace.vicinity;
    _fenceDetail.text = _googlePlace.name;
    _numLabel.text = [NSString stringWithFormat:@"%ld",(long)_googlePlace.index];
    
    [self setupAutoHeightWithBottomView:_fenceDetail bottomMargin:5];

}
@end
