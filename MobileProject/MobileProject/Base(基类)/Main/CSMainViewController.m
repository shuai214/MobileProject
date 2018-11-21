
//
//  CSHomeViewController.m
//  MobileProject
//
//  Created by capaipai@sina.com on 2018/11/20.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "CSMainViewController.h"
#import "CSHomeViewController.h"
#import "CSNavigationController.h"

@implementation CSMainViewController
- (instancetype)init{
    if (self = [super init]) {
        self.tabBar.tintColor = [UIColor orangeColor];
        [self setTabbarController];
    }
    return self;
}

- (void)setTabbarController{
    self.tabBarItemsAttributes = [self tabBarItemsAttributesForController];
    self.viewControllers = [self csViewControllers];//添加标签控制器的子视图
    self.delegate = self;//设置代理
}
- (NSArray *)csViewControllers{
    CSHomeViewController *home1VC = [[CSHomeViewController alloc] init];
    CSNavigationController *nav1VC = [[CSNavigationController alloc] initWithRootViewController:home1VC];
    CSHomeViewController *home2VC = [[CSHomeViewController alloc] init];
    CSNavigationController *nav2VC = [[CSNavigationController alloc] initWithRootViewController:home2VC];
    NSArray *array = @[nav1VC,nav2VC];
    return array;
}

- (NSArray<NSDictionary *>*)tabBarItemsAttributesForController{
    NSDictionary *firstDic = @{
                               CYLTabBarItemTitle : @"首页",
                               CYLTabBarItemImage : @"home_normal",
                               CYLTabBarItemSelectedImage : @"home_highlight",
                               };
    NSDictionary *twoDic = @{
                               CYLTabBarItemTitle : @"首页",
                               CYLTabBarItemImage : @"home_normal",
                               CYLTabBarItemSelectedImage : @"home_highlight",
                               };
    NSArray <NSDictionary *>*array = @[firstDic,twoDic];
    return array;
}

#pragma mark -------- UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}

@end
