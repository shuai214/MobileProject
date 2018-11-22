
//
//  CSProtocolOptionalViewController.m
//  MobileProject
//
//  Created by capaipai@sina.com on 2018/11/22.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "CSProtocolOptionalViewController.h"
#import "Users.h"
#import "Students.h"
#import "Teachers.h"
@interface CSProtocolOptionalViewController ()

@end

@implementation CSProtocolOptionalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Users *user = [[Users alloc] init];
    [user userShouldStudy:[Students new] indentifier:@"student"];
    [user userShouldStudy:[Teachers new] indentifier:@"teacher"];
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
    return [self changeTitle:@"protocol 学习"];
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
