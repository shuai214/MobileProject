//
//  CAPBaseViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPBaseViewController.h"
#import "CAPColors.h"
#import "CAPViews.h"
#import "CAPToast.h"
#import "CAPNavigationController.h"

@interface CAPBaseViewController ()

@end

@implementation CAPBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"[%@ viewDidLoad]", [self class]);
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"";
//    backButtonItem.accessibilityIdentifier = @"bar_back_button";
    self.navigationItem.backBarButtonItem = backButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"[%@ viewWillAppear:]", [self class]);
    [super viewWillAppear:animated];
//    [self setupNavigationBarAndStatusBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"[%@ viewDidAppear:]", [self class]);
   // ((CAPNavigationController *)self.navigationController).popDelegate = self;
//    [self.navigationItem setHidesBackButton:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationItem setHidesBackButton:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldPopOnBackButton {
    [self goBack];
    return YES;
}

- (void)setBarTitle:(NSString *)title {
    UILabel *label = [UILabel new];
    label.text = title;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [CAPColors white];
    [label sizeToFit];
    self.navigationItem.titleView = label;
    //self.navigationItem.title = title;
}

- (void)setTintColor:(UIColor *)color {
    [self.navigationController.navigationBar setTintColor:color];
    NSLog(@"%@", color);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : color}];
}

- (void)setRightBarTextButton:(NSString *)text textColor:(UIColor *)textColor action:(nullable SEL)action {
    self.navigationItem.rightBarButtonItems = @[[CAPViews newBarButtonWithText:text target:self action:action]];
}

- (void)setRightBarImageButton:(NSString *_Nonnull)imageName action:(nullable SEL)action {
//    self.tabBarController.navigationController.navigationItem.rightBarButtonItems = @[[CAPViews newBarButtonWithImage:imageName target:self action:action]];
    self.tabBarController.navigationItem.rightBarButtonItems = @[[CAPViews newBarButtonWithImage:imageName target:self action:action]];
}

- (void)showBackBarItem {
    NSLog(@"showBackBarItem");
    //    [self.navigationItem setHidesBackButton:NO];
    self.navigationItem.leftBarButtonItem = nil;
}


- (void)hideBackBarItem {
    NSLog(@"hideBackBarItem");
    //    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem new];
}

- (void)setupNavigationBarAndStatusBar {
//    [self.navigationController.navigationBar setHidden:NO];
//    
//    CGRect rect=CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [CAPColors white1].CGColor);
//    //    CGContextSetFillColorWithColor(context, [CAPColors white1].CGColor);
//    CGContextFillRect(context, rect);
//    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setBackgroundImage:theImage forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    
//    //self.preferredStatusBarStyle = UIStatusBarStyleLightContent;
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)goHome {
    NSLog(@"[%@ goHome]", [self class]);
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    });
}

- (void)goBack {
    NSLog(@"[%@ goBack]", [self class]);
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    });
}

- (BOOL)isNetworkReady {
    return YES;
    //return gApp.hasNetwork;
}

- (BOOL)assureNetwork {
    return YES;
//    if(gApp.hasNetwork) {
//        return YES;
//    } else {
//        [CAPToast toastError:NSLocalizedString(@"disconnected_network_error", nil)];
//        return NO;
//    }
}
@end
