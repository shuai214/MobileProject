//
//  LoadingView.m
//  KuaiShouPay
//
//  Created by 曹帅 on 16/12/17.
//  Copyright © 2016年 北京联禾众邦科技有限公司. All rights reserved.
//




#import "LoadingView.h"
#import "MBProgressHUD.h"

static MBProgressHUD  *s_progressHUD = nil;

@implementation LoadingView

//UIWindow *kKeyWindow {
//    id appDelegate = [UIApplication sharedApplication].delegate;
//    if (appDelegate && [appDelegate respondsToSelector:@selector(window)]) {
//        return [appDelegate window];
//    }
//
//    NSArray *windows = [UIApplication sharedApplication].windows;
//    if ([windows count] == 1) {
//        return [windows firstObject];
//    }
//    else {
//        for (UIWindow *window in windows) {
//            if (window.windowLevel == UIWindowLevelNormal) {
//                return window;
//            }
//        }
//    }
//    return nil;
//}

+ (void)showProgressHUD:(NSString *)aString duration:(CGFloat)duration {
    [self hideProgressHUD];
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:kKeyWindow];
    [kKeyWindow addSubview:progressHUD];
    progressHUD.animationType = MBProgressHUDAnimationFade;
    progressHUD.labelText = aString;
    
    progressHUD.removeFromSuperViewOnHide = YES;
    progressHUD.opacity = 0.7;
    [progressHUD show:NO];
    [progressHUD hide:YES afterDelay:duration];
}

+ (void)showProgressHUD:(NSString *)aString {
    if (!s_progressHUD) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            s_progressHUD = [[MBProgressHUD alloc] initWithView:kKeyWindow];
        });
    }else{
        [s_progressHUD hide:NO];
    }
    [kKeyWindow addSubview:s_progressHUD];
    s_progressHUD.removeFromSuperViewOnHide = YES;
    s_progressHUD.animationType = MBProgressHUDAnimationFade;
    if ([aString length]>0) {
        s_progressHUD.labelText = aString;
    }
    else s_progressHUD.labelText = nil;
    
    s_progressHUD.opacity = 0.7;
    [s_progressHUD show:YES];
    
}

+ (void)showAlertHUD:(NSString *)aString duration:(CGFloat)duration {
    [self hideProgressHUD];
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:kKeyWindow];
    [kKeyWindow addSubview:progressHUD];
    progressHUD.animationType = MBProgressHUDAnimationFade;
    progressHUD.labelText = aString;
    progressHUD.removeFromSuperViewOnHide = YES;
    progressHUD.opacity = 0.7;
    progressHUD.mode = MBProgressHUDModeText;
    [progressHUD show:NO];
    if (duration > 0.5) {
        duration = 2;
    }
    [progressHUD hide:YES afterDelay:duration];
}

+ (void)hideProgressHUD {
    if (s_progressHUD) {
        [s_progressHUD hide:YES];
    }
}

+ (void)updateProgressHUD:(NSString*)progress {
    if (s_progressHUD) {
        s_progressHUD.labelText = progress;
    }
}


@end
