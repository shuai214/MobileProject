//
//  BaseViewController.m
//  MobileProject
//
//  Created by capaipai@sina.com on 2018/11/20.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
- (instancetype)init{
    self = [super init];
    if (self) {
        //setTranslucent=yes 默认的   则状态栏及导航栏底部为透明的
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController setNavigationBarHidden:YES];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // 状态栏不透明(必须设置，并且为NO)
    self.navigationController.navigationBar.translucent = NO;
    // 视图延伸不考虑透明的Bars(这里包含导航栏和状态栏)
    // 意思就是延伸到边界
    self.extendedLayoutIncludesOpaqueBars=YES;
    // 意思就是空出导航栏位置
    // self.extendedLayoutIncludesOpaqueBars=NO;
    [self.navigationController setNavigationBarHidden:NO];
    //设置title
    if ([self respondsToSelector:@selector(setTitle)]) {
        NSMutableAttributedString *titleAttri = [self setTitle];
        [self set_Title:titleAttri];
    }
    //设置导航栏背景图片
    if ([self respondsToSelector:@selector(navBackgroundImage)]) {
        UIImage *bgImage = [self navBackgroundImage];
        [self setNavigationBackGroundImage:bgImage];
    }
    if (![self leftButton]) {
        if ([self respondsToSelector:@selector(set_leftBarButtonItemWithImage)]) {
            UIImage *image = [self set_leftBarButtonItemWithImage];
            UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self  action:@selector(left_click:)];
            self.navigationItem.leftBarButtonItem = item;
        }
    }
    if (![self rightButton]) {
        if ([self respondsToSelector:@selector(set_rightBarButtonItemWithImage)]) {
            UIImage *image = [self set_rightBarButtonItemWithImage];
            UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self  action:@selector(right_click:)];
            self.navigationItem.rightBarButtonItem = item;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置导航栏背景图片
    if ([self respondsToSelector:@selector(set_backGroundColor)]) {
        UIColor *backGroundColor = [self set_backGroundColor];
        UIImage *bgimage = [UIImage imageWithColor:backGroundColor];
        [self.navigationController.navigationBar setBackgroundImage:bgimage forBarMetrics:UIBarMetricsDefault];
    }
    UIImageView* blackLineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    //默认显示黑线
    blackLineImageView.hidden = NO;
    if ([self respondsToSelector:@selector(hideNavigationBottomLine)]) {
        if ([self hideNavigationBottomLine]) {
            //隐藏黑线
            blackLineImageView.hidden = YES;
        }
    }
    
}


#pragma mark ----normal methods

- (void)set_Title:(NSMutableAttributedString *)title{
    UILabel *navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    navTitleLabel.numberOfLines=0;//可能出现多行的标题
    [navTitleLabel setAttributedText:title];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.backgroundColor = [UIColor clearColor];
    navTitleLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleClick:)];
    [navTitleLabel addGestureRecognizer:tap];
    self.navigationItem.titleView = navTitleLabel;
}
-(void)titleClick:(UIGestureRecognizer*)Tap
{
    UIView *view = Tap.view;
    if ([self respondsToSelector:@selector(title_click_event:)]) {
        [self title_click_event:view];
    }
}
- (void)setNavigationBackGroundImage:(UIImage *)image{
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:image ];
    [self.navigationController.navigationBar setShadowImage:image];
}

- (BOOL)leftButton{
    BOOL isLeft = [self respondsToSelector:@selector(set_leftButton)];
    if (isLeft) {
        UIButton *left_button = [self set_leftButton];
        [left_button addTarget:self action:@selector(left_click:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:left_button];
        self.navigationItem.leftBarButtonItem = item;
    }
    return isLeft;
}
- (BOOL)rightButton{
    BOOL isRight = [self respondsToSelector:@selector(set_rightButton)];
    if (isRight) {
        UIButton *left_button = [self set_rightButton];
        [left_button addTarget:self action:@selector(right_click:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:left_button];
        self.navigationItem.rightBarButtonItem = item;
    }
    return isRight;
}


#pragma mark --- button action methods
- (void)left_click:(id)sender{
    if ([self respondsToSelector:@selector(left_Button_event:)]) {
        [self left_Button_event:sender];
    }
}
- (void)right_click:(id)sender{
    if ([self respondsToSelector:@selector(right_Button_event:)]) {
        [self right_Button_event:sender];
    }
}
-(void)changeNavigationBarTranslationY:(CGFloat)translationY
{
    self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, translationY);
}
//找查到Nav底部的黑线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end
