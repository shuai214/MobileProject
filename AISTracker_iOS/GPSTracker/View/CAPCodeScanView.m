//
//  CAPCodeScanView.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2018/12/22.
//  Copyright © 2018年 Capelabs. All rights reserved.
//

#import "CAPCodeScanView.h"
@interface CAPCodeScanView()
//横线
@property (nonatomic,strong)UIImageView *lineImage;

@end
@implementation CAPCodeScanView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self someInit];
    }
    return self;
}

- (void)someInit
{
    //边框图片
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imageview.image = [UIImage imageNamed:@"frame_icon"];
    [self addSubview:imageview];
    UIImage *scan_line = GetImage(@"scan_line");
    //横线
    self.lineImage = [[UIImageView alloc] initWithImage:scan_line];
    self.lineImage.frame = CGRectMake(0, 0, self.frame.size.width, 20);
    [self addSubview:self.lineImage];
    CABasicAnimation *animation = [CAPCodeScanView moveYTime:2 fromY:[NSNumber numberWithFloat:0] toY:[NSNumber numberWithFloat:self.frame.size.height-10] rep:OPEN_MAX];
    [self.lineImage.layer addAnimation:animation forKey:@"LineAnimation"];
}
+ (CABasicAnimation *)moveYTime:(float)time fromY:(NSNumber *)fromY toY:(NSNumber *)toY rep:(int)rep
{
    CABasicAnimation *animationMove = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animationMove setFromValue:fromY];
    [animationMove setToValue:toY];
    animationMove.duration = time;
    animationMove.delegate = self;
    animationMove.repeatCount  = rep;
    animationMove.fillMode = kCAFillModeForwards;
    animationMove.removedOnCompletion = NO;
    animationMove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animationMove;
}
/**
 *  @author Whde
 *
 *  去除扫码动画
 */
- (void)removeAnimation{
    [self.lineImage.layer removeAnimationForKey:@"LineAnimation"];
    self.lineImage.hidden = YES;
}

@end
