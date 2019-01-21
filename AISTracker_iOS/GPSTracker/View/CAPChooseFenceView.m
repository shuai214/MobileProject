
//
//  CAPChooseFenceView.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/21.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPChooseFenceView.h"

@interface CAPChooseFenceView()
@property (weak, nonatomic) IBOutlet UILabel *fenceName;
@property (weak, nonatomic) IBOutlet UILabel *fenceRange;
@property (weak, nonatomic) IBOutlet UILabel *addressName;
@property (weak, nonatomic) IBOutlet UILabel *detailAddress;
@property (strong, nonatomic) IBOutlet CAPChooseFenceView *contentView;

@end

@implementation CAPChooseFenceView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"CAPChooseFenceView" owner:self options:nil];
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        self.fenceName.userInteractionEnabled = YES;
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fenceNameTouchUpInside:)];
        [self.fenceName addGestureRecognizer:labelTapGestureRecognizer];
        self.fenceRange.userInteractionEnabled = YES;
        UITapGestureRecognizer *fenceRangeTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fenceRangeTouchUpInside:)];
        [self.fenceRange addGestureRecognizer:fenceRangeTapGestureRecognizer];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"CAPChooseFenceView" owner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
}
- (void)setDatafenceInfo:(CAPFence *)fenceInfo{
    self.fenceName.text = fenceInfo.name;
    self.fenceRange.text = [NSString stringWithFormat:@"%ld%@",(long)fenceInfo.range,CAPLocalizedString(@"m")];
    self.addressName.text = fenceInfo.content;
    self.detailAddress.text = fenceInfo.address;
}

- (IBAction)dissMissAction:(id)sender {
    !_closeButtonBlock ? : _closeButtonBlock(self);
}

- (void)fenceNameTouchUpInside:(UITapGestureRecognizer *)recognizer{
    !_editFenceNameBlock ? : _editFenceNameBlock(self);
}
- (void)fenceRangeTouchUpInside:(UITapGestureRecognizer *)recognizer{
    !_editRangeBlock ? : _editRangeBlock(self);
}
@end
