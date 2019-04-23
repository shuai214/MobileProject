//
//  CAPTabBarController.m
//  GPSTracker
//
//  Created by WeifengYao on 8/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPTabBarController.h"
#import "CAPNotifications.h"
#import "CAPBaseViewController.h"
#import "CAPColors.h"

@interface CAPTabBarController ()

@end

@implementation CAPTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.viewControllers);

    [CAPNotifications addObserver:self selector:@selector(didReceiveNotificationLanguageChange:) name:kNotificationLanguageChange object:nil];
    [[UITabBar appearance] setBarTintColor:[CAPColors red]];
}

- (void)didReceiveNotificationLanguageChange:(NSNotification*)notification {
    NSLog(@"[%@ didReceiveNotificationLanguageChange]", [self class]);
    [self refreshLocalizedString:self.viewControllers];
    [self refreshLocalizedString:self.navigationController.viewControllers];
}

- (void)refreshLocalizedString:(NSArray<UIViewController *> *)viewControllers {
    for(UIViewController *controller in viewControllers) {
        if([controller isKindOfClass:[CAPBaseViewController class]]) {
            CAPBaseViewController *baseViewController = (CAPBaseViewController *)controller;
            [baseViewController refreshLocalizedString];
        }
    }
}

@end
