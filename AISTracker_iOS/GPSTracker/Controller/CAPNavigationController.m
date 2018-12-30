//
//  CAPNavigationController.m
//  Ruyi
//
//  Created by user on 7/12/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#import "CAPNavigationController.h"
#import "AppConfig.h"
#import "AppDelegate.h"
#import "CAPToast.h"
#import "CAPColors.h"

@interface CAPNavigationController ()
@property (nonatomic, assign) BOOL isPortrait;
@end

@implementation CAPNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor * color = [CAPColors white];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName]; //UITextAttributeTextColor
    self.navigationBar.titleTextAttributes = dict;
    
        CGRect rect=CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [CAPColors green1].CGColor);
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

//#pragma mark - ScreenOrientation
//
//- (BOOL)shouldAutorotate {
//    return [self.topViewController shouldAutorotate];
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return [self.topViewController supportedInterfaceOrientations];
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return [self.topViewController preferredInterfaceOrientationForPresentation];
//}
//
//- (void)deviceOrientationDidChange {
//    NSLog(@"[%@ deviceOrientationDidChange:%ld]", [self class], (long)[UIDevice currentDevice].orientation);
//    NSLog(@"AUTO Rotate: %@", ([self.topViewController shouldAutorotate] ? @"YES" : @"NO"));
//    
//    if([self shouldAutorotate]) {
//        return;
//    }
//    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//    if(orientation == UIDeviceOrientationPortrait) {
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
//        [self changeOrientation:NO];
//    } else if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
//    }
//}
//
//- (void)changeOrientation:(BOOL)isLandscape {
//    NSLog(@"[%@ changeOrientation: %@]", [self class], (isLandscape ? @"landscape" : @"portrait"));
////    NSLog(@"Screen: %@", NSStringFromCGSize([UIScreen mainScreen].bounds.size));
////    CGFloat width = [UIScreen mainScreen].bounds.size.width;
////    CGFloat height = [UIScreen mainScreen].bounds.size.height;
////    if (isLandscape) {
////        [UIView animateWithDuration:0.2f animations:^{
////            self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
////            self.view.bounds = CGRectMake(0, 0, width, height);
////        }];
////    } else {
////        [UIView animateWithDuration:0.2f animations:^{
////            self.view.transform = CGAffineTransformMakeRotation(0);
////            self.view.bounds = CGRectMake(0, 0, width, height);
////        } completion:^(BOOL finished) {
////        }];
////    }
//}
//
////- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
////    BOOL shouldPop = YES;
////
//////    if(self.popDelegate) {
//////        shouldPop = [self.popDelegate shouldPopOnBackButton];
//////    }
//////
//////    NSLog(@"=======should pop: %@", (shouldPop ? @"YES" : @"NO"));
//////    if(shouldPop) {
////////        dispatch_async(dispatch_get_main_queue(), ^{
////////            [self popViewControllerAnimated:YES];
////////        });
//////    } else {
//////        // 取消 pop 后，复原返回按钮的状态
//////        for(UIView *subview in [navigationBar subviews]) {
//////            if(0. < subview.alpha && subview.alpha < 1.) {
//////                [UIView animateWithDuration:.25 animations:^{
//////                    subview.alpha = 1.;
//////                }];
//////            }
//////        }
//////    }
////
////    return shouldPop;
////}

@end
