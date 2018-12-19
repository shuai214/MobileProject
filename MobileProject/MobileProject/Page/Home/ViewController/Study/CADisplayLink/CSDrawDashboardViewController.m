//
//  CSDrawDashboard ViewController.m
//  MobileProject
//
//  Created by capaipai@sina.com on 2018/12/17.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "CSDrawDashboardViewController.h"

@interface CSDrawDashboardViewController ()

@end

@implementation CSDrawDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CALayer *mainLayer = ([CALayer layer]);
    mainLayer.frame = CGRectMake(0, 200, 100, 100);
    mainLayer.backgroundColor = [UIColor redColor].CGColor;
    mainLayer.anchorPoint = CGPointMake(1, 1);
    [self.view.layer addSublayer:mainLayer];
    
    [self drawDashboardView];
}

- (void)drawDashboardView{
    self.view.backgroundColor = [UIColor lightGrayColor];
    //渐变背景
    CALayer *gradientLayer = [CALayer layer];
    gradientLayer.frame = CGRectMake((Main_Screen_Width - 300) / 2, (Main_Screen_Height - 300) / 2, 300, 300);

    //渐变图层
    CAGradientLayer *bgGradientLayer = [CAGradientLayer layer];
    bgGradientLayer.frame = CGRectMake(0, 0, 300, 300);
    bgGradientLayer.colors = @[(__bridge id)[UIColor orangeColor].CGColor,(__bridge id)[UIColor greenColor].CGColor];
    bgGradientLayer.locations = @[@(0),@(1)];
    bgGradientLayer.startPoint =  CGPointMake(0.5, 0);
    bgGradientLayer.endPoint = CGPointMake(0.5, 1);
    [gradientLayer addSublayer:bgGradientLayer];
    [self.view.layer addSublayer:gradientLayer];


    //仪表盘起止位置

    CGFloat startP = - M_PI;
    CGFloat endP = 0;

    //最外面的圆弧 ---大圆弧
    UIBezierPath *bigPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(Main_Screen_Width / 2, Main_Screen_Height / 2) radius:150 startAngle:startP endAngle:endP clockwise:YES];

    CAShapeLayer *bigShapeLayer = [CAShapeLayer layer];
    bigShapeLayer.lineCap = kCALineCapButt;
    bigShapeLayer.lineWidth = 4;
    bigShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    bigShapeLayer.fillColor = [UIColor clearColor].CGColor;
    bigShapeLayer.path = bigPath.CGPath;
    [self.view.layer addSublayer:bigShapeLayer];

    //内圆弧 ---内圆弧
    UIBezierPath *centerPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(Main_Screen_Width / 2, Main_Screen_Height / 2) radius:80 startAngle:startP endAngle:endP clockwise:YES];

    CAShapeLayer *centerShapeLayer = [CAShapeLayer layer];
    centerShapeLayer.lineCap = kCALineCapButt;
    centerShapeLayer.lineWidth = 4;
    centerShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    centerShapeLayer.fillColor = [UIColor clearColor].CGColor;
    centerShapeLayer.path = centerPath.CGPath;
    [self.view.layer addSublayer:centerShapeLayer];

    //中间圆弧 ---最中间圆弧
    UIBezierPath *smallPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(Main_Screen_Width / 2, Main_Screen_Height / 2) radius:10 startAngle:startP endAngle:endP clockwise:YES];

    CAShapeLayer *smallShapeLayer = [CAShapeLayer layer];
    smallShapeLayer.lineCap = kCALineCapButt;
    smallShapeLayer.lineWidth = 6;
    smallShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    smallShapeLayer.fillColor = [UIColor clearColor].CGColor;
    smallShapeLayer.path = smallPath.CGPath;
    [self.view.layer addSublayer:smallShapeLayer];


    //进度圆弧
    UIBezierPath *path4 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(150, 150) radius:115 - 2 startAngle:startP endAngle:endP clockwise:YES];
    CAShapeLayer *layer4 = [CAShapeLayer layer];
    layer4.lineCap = kCALineCapButt;
    layer4.fillColor = [UIColor clearColor].CGColor;
    layer4.strokeColor = [UIColor whiteColor].CGColor;
    layer4.lineWidth = 50;
    layer4.path = path4.CGPath;
    layer4.strokeEnd = 1;
    gradientLayer.mask = layer4;
    
//    _progressLayer = layer4;
    
    
    //刻度
    CGFloat perAngle = M_PI / 70;

    for (NSInteger i = 0; i < 71; i++) {
        CGFloat startAngle = startP + perAngle * i;
        CGFloat endAngle = startAngle + perAngle / 5;
        CGFloat minddleAngle = startAngle - endAngle;
        
        UIBezierPath *tickPath = nil;
        CAShapeLayer *perLayer = [CAShapeLayer layer];
        perLayer.strokeColor = [UIColor whiteColor].CGColor;

        if (i % 5 == 0) {
            tickPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(Main_Screen_Width/2, Main_Screen_Height/2) radius:(150-7.5 + 2) startAngle:(startAngle + minddleAngle/2) endAngle:(endAngle + minddleAngle/2) clockwise:YES];
            perLayer.lineWidth   = 15.f;
            CGPoint point      = [self calculateTextPositonWithArcCenter:CGPointMake(Main_Screen_Width/2, Main_Screen_Height/2) Angle:-(startAngle + endAngle)/2];
            NSString *tickText = [NSString stringWithFormat:@"%ld",i * 2];
            
            UILabel *text      = [[UILabel alloc] init];
            text.text          = tickText;
            text.font          = [UIFont systemFontOfSize:10];
            text.textColor     = [UIColor whiteColor];
            text.textAlignment = NSTextAlignmentCenter;
            CGFloat w = [text sizeThatFits:CGSizeZero].width;
            CGFloat h = [text sizeThatFits:CGSizeZero].height;
            text.frame = CGRectMake(point.x - w/2, point.y - h/2, w, h);
            [self.view addSubview:text];
        }else{
            tickPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(Main_Screen_Width/2, Main_Screen_Height/2) radius:(150-5 + 2) startAngle:(startAngle + minddleAngle/2) endAngle:(endAngle + minddleAngle/2) clockwise:YES];
            perLayer.lineWidth   = 5.f;
            
        }
        perLayer.path = tickPath.CGPath;
        [self.view.layer addSublayer:perLayer];
    }
    
    // 指针
    UIView *clockView = [[UIView alloc] initWithFrame:CGRectMake((Main_Screen_Width-140)/2, (Main_Screen_Height-2)/2, 140, 2)];
    clockView.tag = 100;
    clockView.backgroundColor = [UIColor whiteColor];
    clockView.layer.anchorPoint = CGPointMake(1.0, 0.5);
    [self.view addSubview:clockView];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGFloat progress = (arc4random_uniform(40)+60)/100.0;
    UIView *clockView = [self.view viewWithTag:100];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; // 动画快慢
    animation.removedOnCompletion = NO;
    animation.repeatCount = 1;
    animation.autoreverses = YES;
    animation.duration = 1.0f*progress;
    animation.fromValue = @(0);
    animation.toValue = @(M_PI*progress);
    [clockView.layer addAnimation:animation forKey:@"dsgsdg"];
}
// 计算位置,默认半径125
- (CGPoint)calculateTextPositonWithArcCenter:(CGPoint)center Angle:(CGFloat)angel {
    CGFloat x = 165 * cosf(angel);
    CGFloat y = 165 * sinf(angel);
    return CGPointMake(center.x + x, center.y - y);
}
@end
