
//
//  CSNavigationController.m
//  MobileProject
//
//  Created by capaipai@sina.com on 2018/11/20.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "CSNavigationController.h"

@interface CSNavigationController ()

@end

@implementation CSNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        //第二级则隐藏底部Tab
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


@end
