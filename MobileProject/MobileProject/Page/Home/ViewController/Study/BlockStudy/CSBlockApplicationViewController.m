//
//  CSBlockApplicationViewController.m
//  MobileProject
//
//  Created by capaipai@sina.com on 2018/12/6.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "CSBlockApplicationViewController.h"

@implementation CSBlockApplicationViewController
static int sum(int a ,int b){
    return a + b;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    int s = sum(1,2);
    NSLog(@"%d",s);
    //block 应用 : 链式编程 + 函数编程
    
    //----------------------
    //链式编程
    //通过点语法,串联操作
//    self.select.where;
   
    
    //viewDidLoad : 数据 --> 方法:SEL(方法选择器)-->IMP-->函数
    //IMP 默认两个隐形参数 self , _cmd
    //方法的底层是函数 : 函数调用就是给某一个对象发送消息 ,消息体就是_cmd
    //IMP里面会影藏两个函数的消息
    
    //block作为返回值   //getter (方法不能传参数)
    NSString *name = self.select.when(@"name");
    NSLog(@"%@",name);
   
    
    //函数变成
    //block 作为参数
    //函数式编程 :y = f(x); ----> y = f(f(x));
    
    [self funcationBlock:^(NSString *success) {
        NSLog(@"%@",success);
    }];
    
    self.when;
    
}

//eg/

- (CSBlockApplicationViewController *)select{
    NSLog(@"111111");
    return self;
}

- (void)where{
    NSLog(@"where");
}

- (NSString * (^)(NSString *))when{
    NSString * (^strBlock)(NSString *) = ^(NSString *word){
        return  [NSString stringWithFormat:@"when : %@ ",word];
    };
    return strBlock;
}

- (void)funcationBlock:(void (^)(NSString *))success{
    if (success) {
        success(@"hello 函数式编程");
    }
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
    return [self changeTitle:@"Block 应用"];
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
