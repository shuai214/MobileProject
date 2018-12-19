//
//  CAPTrackerView.m
//  GPSTracker
//
//  Created by WeifengYao on 6/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPTrackerView.h"

@interface CAPTrackerView ()
@property (weak, nonatomic) IBOutlet UIButton *fenceButton;
@property (weak, nonatomic) IBOutlet UIButton *footprintButton;
@property (weak, nonatomic) IBOutlet UIButton *photographButton;
@property (weak, nonatomic) IBOutlet UIButton *navigationButton;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;

@end

@implementation CAPTrackerView

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"CAPTrackerView" owner:self options:nil];
    [self addSubview:self.contentView];
    
    [self initButton:self.fenceButton];
    [self initButton:self.footprintButton];
    [self initButton:self.photographButton];
    [self initButton:self.navigationButton];
    [self initButton:self.settingButton];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.contentView.frame = self.bounds;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [self.contentView layoutSubviews];
//}

//- (instancetype)init:(NSCoder *)aDecoder {
//    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"CAPTrackerView" owner:self options:nil] lastObject];
//    if (view) {
//        self.frame = self.bounds;
//        [self addSubview:view];
//    }
//    return self;
//}

//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    self = [[[NSBundle mainBundle] loadNibNamed:@"CAPTrackerView" owner:self options:nil] lastObject];
//    if (self) {
//        self.frame = frame;
//    }
//    return self;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)onFenceButtonClicked:(id)sender {
    NSLog(@"onFenceButtonClicked");
    [self performAction:CAPTrackerViewActionFence];
}

- (IBAction)onFootprintButtonClicked:(id)sender {
    [self performAction:CCAPTrackerViewActionFootprint];
}

- (IBAction)onPhotographButtonClicked:(id)sender {
    [self performAction:CAPTrackerViewActionPhotograph];
}

- (IBAction)onNavigationButtonClicked:(id)sender {
    [self performAction:CAPTrackerViewActionNavigation];
}

- (IBAction)onSettingButtonClicked:(id)sender {
    [self performAction:CAPTrackerViewActionSetting];
}

-(void)initButton:(UIButton*)button {
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [button setTitleEdgeInsets:UIEdgeInsetsMake(button.imageView.frame.size.height+12 ,-button.imageView.frame.size.width, 0.0, 0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -button.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}

- (void)performAction:(CAPTrackerViewAction)action {
    if(self.delegate) {
        [self.delegate onTrackerViewActionPerformed:action];
    }
}
@end
