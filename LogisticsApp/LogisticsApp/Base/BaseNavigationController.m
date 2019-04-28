//
//  BaseNavigationController.m
//  LogisticsApp
//
//  Created by capaipai@sina.com on 2019/4/28.
//  Copyright © 2019年 capaipai. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName]; //UITextAttributeTextColor
    self.navigationBar.titleTextAttributes = dict;
    self.navigationBar.tintColor=[UIColor whiteColor];
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"common_naviBackBtn.png"];
    
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"common_naviBackBtn"];
    
    
    CGRect rect=CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"#0079c3"].CGColor);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //        self.navigationController.navigationBar.translucent = YES;
    [self.navigationBar setBackgroundImage:theImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
    
    //    self.preferredStatusBarStyle = UIStatusBarStyleDefault;
    //        [self.navigationBar setTintColor:[UIColor whiteColor]];
    //        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    
    //    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 返回
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    [super pushViewController:viewController animated:animated];
}

@end
