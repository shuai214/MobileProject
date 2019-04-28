//
//  LoadingView.h
//  KuaiShouPay
//
//  Created by 曹帅 on 16/12/17.
//  Copyright © 2016年 北京联禾众邦科技有限公司. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LoadingView : NSObject

+ (void)showAlertHUD:(NSString *)aString duration:(CGFloat)duration;
+ (void)showProgressHUD:(NSString *)aString duration:(CGFloat)duration;
+ (void)showProgressHUD:(NSString *)aString;
+ (void)hideProgressHUD;
+ (void)updateProgressHUD:(NSString*)progress;

@end
