//
//  CSCADisplayLinkerViewController.m
//  MobileProject
//
//  Created by capaipai@sina.com on 2018/11/22.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "CSCADisplayLinkerViewController.h"

@interface CSCADisplayLinkerViewController ()
@property(nonatomic,strong)CADisplayLink *displayLink;

@property(nonatomic)CAShapeLayer *shapeLayer;
@property(nonatomic,assign)CGFloat startAngle;
@property(nonatomic,assign)CGFloat endAngle;
@property(nonatomic,assign)CGFloat progress;

@end

@implementation CSCADisplayLinkerViewController
/**
 //CADisplayLink知识点
 CADisplayLink是一个能让我们以和屏幕刷新率相同的频率将内容画到屏幕上的定时器。
 我们在应用中创建一个新的CADisplayLink 对象，把它添加到一个runloop中，并且给它提供一个target
 和selector在屏幕刷新的时候调用。
 一旦CADisplayLink 以特定的模式注册到runloop之后，每当屏幕需要刷新的时候，runloop就会调用
 CADisplayLink绑定的target上的selector方法，这时target就可以读到CADisplayLink的每次调用的时间戳，
 用来准备下一帧显示需要的数据。
 eg：一个视频应用使用时间戳来计算下一帧x要显示的视频数据。在UI做动画的过程中，需要通过时间戳来计算
 UI对象在动画的下一帧要更新的大小等等。。
 在添加进runloop的时候我们应该选用高一些的优先级来保证动画的平滑。可以设想一下，
 我们在动画的过程中，runloop被添加进来了一个高优先级的任务，那么下一次的调用就会被暂停
 转而先去执行高优先级的任务，然后再接着执行CADisplayLink的调用，从而造成动画过程的卡顿，使动画不流畅。
 
 
 duration属性提供了每帧之间的时间，也就是屏幕每次刷新之间的时间，我们可以使用这个时间来计算出下一帧
 要显示的UI的数值。但是duration只是个大概的时间，如果CPU忙于其他的计算，就没办法保证以相同的b频率执行
 屏幕的绘制z操作，这样会g跳过几次调用回调方法的机会、
 
 frameInterval属性是可读可写的NSIntergere类型值、标识间隔多少帧调用一尺selector方法，默认值1.
 即每帧都调用一次。如果每帧都调用一次的话，对于iOS设备来说那刷新频率就是60HZ也就是每秒60次。如果
 franeInterval设为2，那么就会两帧调用一次，也就变成每秒刷新30次。
 
 我们通过pause属性来控制CADisplayLink的运行。当我们想结束一个CADisplayLink的时候，
 应该调用-（void）invalidate;
 
 timestamp属性：只读的CFTimeInterval值，表示屏幕显示的上一帧的时间戳，这个属性通常被
 target用来计算下一帧中应该显示的内容，打印timestamp的值，其样式类似于：179699.631584。
 
 从runloop中删除并删除之前绑定的target跟selector；
 
 另外----------------- CADisplayLink 不能被继承
 
 
 */





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /**
     初始化CADisplayLink

     @param displayLinkAction CADisplayLink的对象要相应的方法
     @return 返回一个CADisplayLink的对象
     */
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
    
    //将self.displayLink 对象添加到 mainrunloop
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    [self setUI];
    
    
}


- (void)setUI{
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.bounds = CGRectMake(0, 0, 60, 60);
    _shapeLayer.position = CGPointMake(Main_Screen_Width / 2, Main_Screen_Height / 2); //锚点
    _shapeLayer.fillColor = [UIColor orangeColor].CGColor; //图形的填充颜色
    _shapeLayer.strokeColor = [UIColor redColor].CGColor; // 路径颜色
    _shapeLayer.lineWidth = 5; //线宽
    _shapeLayer.lineCap = kCALineCapRound;//线端口类型
    [self.view.layer addSublayer:_shapeLayer];
    [self updateAnimationLayer];

}


- (void)displayLinkAction{
    
    _progress += [self speed];
    if (_progress >= 1) {
        _progress = 0;
    }
    [self updateAnimationLayer];
}

-(void)updateAnimationLayer{
    _startAngle = -M_PI_2;
    _endAngle = -M_PI_2 +_progress * M_PI * 2;
    if (_endAngle > M_PI) {
        CGFloat progress1 = 1 - (1 - _progress)/0.25;
        _startAngle = -M_PI_2 + progress1 * M_PI * 2;
    }
    CGFloat radius = _shapeLayer.bounds.size.width/2.0f - 5/2.0f;
    CGFloat centerX = _shapeLayer.bounds.size.width/2.0f;
    CGFloat centerY = _shapeLayer.bounds.size.height/2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:_startAngle endAngle:_endAngle clockwise:true];
    path.lineCapStyle = kCGLineCapRound;
    
    _shapeLayer.path = path.CGPath;
}

-(CGFloat)speed{
    if (_endAngle > M_PI) {
        return 0.3/60.0f;
    }
    return 2/60.0f;
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
    return [self changeTitle:@"CADisplayLink 学习"];
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
