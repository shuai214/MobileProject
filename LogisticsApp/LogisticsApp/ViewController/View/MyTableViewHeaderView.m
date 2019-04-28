//
//  MyHeaderView.m
//  ChinaScpetDistributor
//
//  Created by 曹帅 on 2018/9/12.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "MyTableViewHeaderView.h"
#import "ZHWave.h"

@interface MyTableViewHeaderView()
/* 中间title的图片视图 */
@property (strong , nonatomic)UIImageView *topImgView;
/* title的label*/
@property (strong , nonatomic)UILabel *titleLabel;

@end

@implementation MyTableViewHeaderView
#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)HEXCOLOR(@"#0079c1").CGColor,(__bridge id)HEXCOLOR(@"#0079c3").CGColor];
        gradientLayer.locations = @[@0, @1.0];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1.0, 0);
        gradientLayer.frame = self.frame;
        [self.layer addSublayer:gradientLayer];
        ZHWave *WaveView =[[ZHWave alloc]initWithFrame:CGRectMake(0, self.wtj_height - 50, self.wtj_width, 50)];
        WaveView.waveHeight = 50;
        WaveView.waveSpeed = 0.05;
        WaveView.wavecolor = [UIColor colorWithHexString:@"#FFFFFF" withAlpha:0.1];
        [WaveView startWaveAnimation];
        WaveView.backgroundColor = [UIColor clearColor];
        WaveView.alpha = 0.3;
        [self addSubview:WaveView];
        [self setUpUI];
    }
    return self;
}

- (void)setUserTitle{
    if ([SharedLogin shareInstance].name.length <= 0 || kStringIsEmpty([CSSessionManager getsSession])) {
        [self.titleLabel setText:@"点击登录"];
        self.topImgView.userInteractionEnabled = YES;
        self.titleLabel.userInteractionEnabled = YES;
    }else{
        self.topImgView.userInteractionEnabled = NO;
        self.titleLabel.userInteractionEnabled = NO;
        [self.titleLabel setText:[SharedLogin shareInstance].name];
    }
}

- (void)setUpUI
{
    _topImgView = ({
        UIImageView *imgView = [[UIImageView alloc] init];
        [imgView setImage:GetImage(@"userBanner")];
//        imgView.backgroundColor = [UIColor RandomColor];
        imgView.clipsToBounds = YES;
        imgView.layer.cornerRadius = 30;
        imgView;
    });
    
    _titleLabel =({
        UILabel *titleLabel = [[UILabel alloc] init];
        if ([SharedLogin shareInstance].name.length <= 0) {
            [titleLabel setText:@"点击登录"];
        }else{
            [titleLabel setText:[SharedLogin shareInstance].name];
        }
        titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF" withAlpha:1];
        [titleLabel setFont:FontSize_R(16)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel;
    });
    [self addSubview:_topImgView];
    [self addSubview:_titleLabel];
    self.topImgView.userInteractionEnabled = YES;
    self.titleLabel.userInteractionEnabled = YES;

    MPWeakSelf(self);
    [self.topImgView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        !weakself.clickBlock ? : weakself.clickBlock();
    }];
    [self.titleLabel addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        !weakself.clickBlock ? : weakself.clickBlock();
    }];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [_topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-50);
        make.left.equalTo(self.mas_left).offset(20);
        make.height.equalTo(@60);
        make.width.equalTo(@60);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topImgView.mas_centerY).offset(-10);
        make.left.equalTo(self.topImgView.mas_right).offset(10);
        make.height.equalTo(@18);
    }];
}











@end
