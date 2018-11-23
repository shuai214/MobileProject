

//
//  CSBesierPathViewController.m
//  MobileProject
//
//  Created by capaipai@sina.com on 2018/11/23.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "CSBesierPathViewController.h"
#import "UIColor+Random.h"
@interface CSBesierPathViewController ()
@property(nonatomic,strong)UIImageView *bgView;
@end

@implementation CSBesierPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self drawLine];
    
    [self drawTriangle];
    
    [self drawRounded];
    
    [self drawCurvedLine];
    
    [self drawRectangle];
    
    [self drawDottedLine];
}

/**
 画直线
 */
- (void)drawLine{
    UIBezierPath *bpath = [UIBezierPath bezierPath];
    //两点
    [bpath moveToPoint:CGPointMake(15, 120)];
    [bpath addLineToPoint:CGPointMake(130, 110)];
    //绘制
    [bpath stroke];
    
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.path = bpath.CGPath;
    //绘制颜色
    shaperLayer.strokeColor = [UIColor blackColor].CGColor;
    shaperLayer.fillColor = [UIColor orangeColor].CGColor;
    shaperLayer.lineWidth = 1;
    [self.view.layer addSublayer:shaperLayer];
}

/**
 画三角形
 */
- (void)drawTriangle{
    UIBezierPath *bpath = [UIBezierPath bezierPath];
    [bpath moveToPoint:CGPointMake(90, 90)];
    [bpath addLineToPoint:CGPointMake(180, 90)];
    [bpath addLineToPoint:CGPointMake(180, 180)];
    [bpath stroke];//Draws line 根据坐标点连线
    [bpath closePath];//第三条线通过调用closePath方法得到的
    
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.path = bpath.CGPath;
    //绘制颜色
    shaperLayer.strokeColor = [UIColor blackColor].CGColor;//线条路径颜色
    shaperLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色
    shaperLayer.lineWidth = 3;
    shaperLayer.lineJoin = kCALineJoinRound;//交叉点进行特别处理 ...微圆角
    [self.view.layer addSublayer:shaperLayer];
    
}

/**
 画圆
 */
- (void)drawRounded{
    UIBezierPath *bPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(120, 290, 99, 99) cornerRadius:99 / 2];
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.path = bPath.CGPath;
    shaperLayer.lineWidth = 5;
    shaperLayer.strokeColor = [UIColor orangeColor].CGColor;//线条路径颜色
    shaperLayer.fillColor = [UIColor RandomColor].CGColor;//填充颜色
    [self.view.layer addSublayer:shaperLayer];
    
    /**
     1 keyPath = strokeStart  动画的fromValue = 0，toValue = 1
     表示从路径的0位置画到1 怎么画是按照清除开始的位置也就是清除0 一直清除到1 效果就是一条路径慢慢的消失
     2 keyPath = strokeStart  动画的fromValue = 1，toValue = 0
     表示从路径的1位置画到0 怎么画是按照清除开始的位置也就是1 这样开始的路径是空的（即都被清除掉了）一直清除到0 效果就是一条路径被反方向画出来
     3 keyPath = strokeEnd  动画的fromValue = 0，toValue = 1
     表示 这里我们分3个点说明动画的顺序  strokeEnd从结尾开始清除 首先整条路径先清除后2/3，接着清除1/3 效果就是正方向画出路径
     4 keyPath = strokeEnd  动画的fromValue = 1，toValue = 0
     效果就是反方向路径慢慢消失
     注释： 动画的0-1（fromValue = 0，toValue = 1） 或1-0 （fromValue = 1，toValue = 0） 表示执行的方向 和路径的范围。
     */
    
//    NSString *path = @"strokeStart";
    NSString *path = @"strokeEnd";

    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:path];
    checkAnimation.duration = 5;
//    checkAnimation.fromValue = @0.f;
//    checkAnimation.toValue = @1.f;
    checkAnimation.fromValue = @1.f;
    checkAnimation.toValue = @0.f;
//    checkAnimation.delegate = self;
    [checkAnimation setValue:@"checkAnimation" forKey:@"animationName"];
    [shaperLayer addAnimation:checkAnimation forKey:nil];
    [self animationTest];
}
- (void)animationTest{
    self.bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.bgView.backgroundColor =[UIColor RandomColor];
    [self.view addSubview:self.bgView];
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(test)];
    displayLink.preferredFramesPerSecond = 9;
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
}

- (void)test{
    self.bgView.backgroundColor = [UIColor RandomColor];
}

/**
 画弧线
 */
-(void)drawCurvedLine{
    UIBezierPath *bpath = [UIBezierPath bezierPath];
    bpath.lineWidth = 5.0;
    bpath.lineCapStyle = kCGLineCapRound; //线条拐角
    bpath.lineJoinStyle = kCGLineCapRound; //终点处理
    
    [bpath moveToPoint:CGPointMake(100, 200)]; //左边点
    [bpath addQuadCurveToPoint:CGPointMake(200, 200) controlPoint:CGPointMake(150, 100)]; //右边点  中间点
    
    
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.path = bpath.CGPath;
    shaperLayer.strokeColor = [UIColor orangeColor].CGColor;//线条路径颜色
    shaperLayer.fillColor = [UIColor RandomColor].CGColor;//填充颜色
    [self.view.layer addSublayer:shaperLayer];
}


/**
 画矩形
 */
- (void)drawRectangle{
    
    UIBezierPath *bpath = [UIBezierPath bezierPathWithRect:CGRectMake(200, 200, 100, 100)];
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.path = bpath.CGPath;
    shaperLayer.strokeColor = [UIColor RandomColor].CGColor;//线条路径颜色
    shaperLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色
    [self.view.layer addSublayer:shaperLayer];
    
}


/**
 画虚线
 */
- (void)drawDottedLine{
    UIBezierPath* bpath = [UIBezierPath bezierPath];
    //两点
    [bpath moveToPoint:CGPointMake(200, 130)];
    [bpath addLineToPoint:CGPointMake(320, 130)];
    
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.lineWidth=1;
    shaperLayer.strokeColor=[UIColor RandomColor].CGColor;
    shaperLayer.fillColor = [UIColor RandomColor].CGColor;//填充颜色
    shaperLayer.path=bpath.CGPath;
    shaperLayer.lineDashPattern=@[@9,@1]; //3=线的宽度 1=每条线的间距
    [self.view.layer addSublayer:shaperLayer];
}







#pragma mark 重写BaseViewController设置内容

//设置导航栏背景色
-(UIColor*)set_backGroundColor
{
    return [UIColor whiteColor];
}

//是否隐藏导航栏底部的黑线 默认也为NO
-(BOOL)hideNavigationBottomLine
{
    return YES;
}

////设置标题
-(NSMutableAttributedString*)setTitle
{
    return [self changeTitle:@"UIBezierPath 学习"];
}

//设置左边按键
-(UIButton*)set_leftButton
{
    UIButton *left_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [left_button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [left_button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateHighlighted];
    return left_button;
}

//设置左边事件
-(void)left_Button_event:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle];
    [title addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:CHINESE_SYSTEM(18) range:NSMakeRange(0, title.length)];
    return title;
}
@end
