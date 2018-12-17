//
//  CSTextTestViewController.m
//  MobileProject
//
//  Created by capaipai@sina.com on 2018/11/29.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "CSTextTestViewController.h"

@interface CSTextTestViewController ()

@end

@implementation CSTextTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self layoutYYText];
    [self print];
//    NSLog(@"%@ --- %@",[self class],[super class]);
}
- (void)print
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"A");
    });
//    NSLog(@"B");
    dispatch_queue_t queuetmp = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_sync(queuetmp, ^{
        NSLog(@"C");
    });
    dispatch_async(queuetmp, ^{
        NSLog(@"D");
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"E");
    });
//    [self performSelector:@selector(method) withObject:nil afterDelay:0.0f];
//    NSLog(@"F");
    
}

- (void)method
{
    NSLog(@"G");
}
- (void)layoutYYText{
    
    /**
     YYLabel 普通显示
     */
    YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(10, 100, Main_Screen_Width - 20, 20)];
    label.font = CHINESE_SYSTEM(14);
    label.textColor = [UIColor RandomColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = @"我是第一个测试内容，关于yylabel的简单运用；good";
    [self.view addSubview:label];
    
    /**
     YYLable 运用textLayout计算高宽
     */
    CGSize size = CGSizeMake(Main_Screen_Width - 20, CGFLOAT_MAX);
    NSMutableAttributedString *attributerString = [[NSMutableAttributedString alloc] initWithString:@"测试文本内容的长度控制，并且显示文体的内容，测试文本内容的长度控制，并且显示文体的内容，测试文本内容的长度控制，并且显示文体的内容测试文本内容的长度控制，并且显示文体的内容，测试文本内容的长度控制，并且显示文体的内容，测试文本内容的长度控制，并且显示文体的内容测试文本内容的长度控制，并且显示文体的内容，测试文本内容的长度控制，并且显示文体的内容，测试文本内容的长度控制，并且显示文体的内容测试文本内容的长度控制，并且显示文体的内容，测试文本内容的长度控制，并且显示文体的内容，测试文本内容的长度控制，并且显示文体的内容"];
    attributerString.yy_lineSpacing = 8; //设置行间距
    attributerString.yy_font = CHINESE_SYSTEM(14);
    attributerString.yy_color = [UIColor RandomColor];
    
    YYTextLayout *yyLayout = [YYTextLayout layoutWithContainerSize:size text:attributerString];
    YYLabel *aLabel = [[YYLabel alloc] initWithFrame:CGRectMake(10,130,yyLayout.textBoundingSize.width,yyLayout.textBoundingSize.height)];
    aLabel.textLayout = yyLayout;
    [self.view addSubview:aLabel];
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
    return [self changeTitle:@"YYText 学习"];
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
