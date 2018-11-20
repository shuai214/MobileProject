//
//  XAspect-ConfigAppDelegate.m
//  MobileProject
//
//  Created by capaipai@sina.com on 2018/11/20.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "AppDelegate.h"
#import "XAspect.h"
#define AtAspect ConfigAppDelegate
#define AtAspectOfClass AppDelegate
@classPatchField(AppDelegate)

@synthesizeNucleusPatch(Default,-, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions);
@synthesizeNucleusPatch(Default,-, BOOL, application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation);
@synthesizeNucleusPatch(Default,-, void, applicationDidBecomeActive:(UIApplication *)application);


AspectPatch(-, BOOL, application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions)
{
    //友盟分享及第三方登录初始化
    [self configureBoardManager];
    
    return XAMessageForward(application:application didFinishLaunchingWithOptions:launchOptions);
}
#pragma mark 键盘收回管理
-(void)configureBoardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.keyboardDistanceFromTextField=60;
    manager.enableAutoToolbar = NO;
}

@end
#undef AtAspectOfClass
#undef AtAspect
