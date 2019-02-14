//
//  CAPToast.m
//  Neptu
//
//  Created by WeifengYao on 22/3/2018.
//  Copyright © 2018 capelabs. All rights reserved.
//

#import "CAPToast.h"
#import "CRToast.h"
#import "CAPColors.h"
#import "CAPPhones.h"
#import "AppConfig.h"
#import "CAPSession.h"

@implementation CAPToast
+(void)toastSuccess:(NSString *)message {
    NSLog(@"[CAPToast toastSuccess: %@]", message);
    static NSMutableDictionary *options;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        options = [@{
                     kCRToastTextKey : @"",
                     kCRToastFontKey: [UIFont systemFontOfSize:15],
                     kCRToastTimeIntervalKey : @(1.5),
                     kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                     kCRToastBackgroundColorKey : [CAPColors green1],
                     kCRToastNotificationTypeKey :  @(CRToastTypeNavigationBar),
                     kCRToastNotificationPresentationTypeKey :  @(CRToastPresentationTypeCover),
                     kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                     kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                     kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                     kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
//                     kCRToastImageKey : [UIImage imageNamed:@"end.png"],
                     kCRToastImageAlignmentKey : @(CRToastAccessoryViewAlignmentCenter)
                     } mutableCopy];
    });
    [options setObject:message forKey:kCRToastTextKey];
    
    [CRToastManager dismissAllNotifications:NO];
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:nil];
}

+(void)toastWarning:(NSString *)message {
    NSLog(@"[CAPToast toastWarning: %@]", message);
    static NSMutableDictionary *options;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        options = [@{
                     kCRToastTextKey : @"",
                     kCRToastFontKey: [UIFont systemFontOfSize:15],
                     kCRToastTimeIntervalKey : @(1.5),
                     kCRToastTextAlignmentKey : @(NSTextAlignmentLeft),
                     kCRToastBackgroundColorKey : [CAPColors yellow1],
                     kCRToastNotificationTypeKey :  @(CRToastTypeNavigationBar),
                     kCRToastNotificationPresentationTypeKey :  @(CRToastPresentationTypeCover),
                     kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                     kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                     kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                     kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
//                     kCRToastImageKey : [UIImage imageNamed:@"alert_icon.png"],
                     kCRToastImageAlignmentKey : @(CRToastAccessoryViewAlignmentLeft)
                     } mutableCopy];
    });
    [options setObject:message forKey:kCRToastTextKey];
    
    [CRToastManager dismissAllNotifications:NO];
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:nil];
}

+(void)toastError:(NSString *)message {
    NSLog(@"[CAPToast toastError: %@]", message);
    static NSMutableDictionary *options;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        options = [NSMutableDictionary dictionary];
        options = [@{
                     kCRToastTextKey : @"",
                     kCRToastFontKey: [UIFont systemFontOfSize:15],
                     kCRToastTimeIntervalKey : @(1.5),
                     kCRToastTextAlignmentKey : @(NSTextAlignmentLeft),
                     kCRToastBackgroundColorKey : [CAPColors red1],
                     kCRToastNotificationTypeKey :  @(CRToastTypeNavigationBar),
                     kCRToastNotificationPresentationTypeKey :  @(CRToastPresentationTypeCover),
                     kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                     kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                     kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                     kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
//                     kCRToastImageKey : [UIImage imageNamed:@"dialog_close_red"],
                     kCRToastImageAlignmentKey : @(CRToastAccessoryViewAlignmentLeft)
                     } mutableCopy];
    });
    [options setObject:message forKey:kCRToastTextKey];
    
    [CRToastManager dismissAllNotifications:NO];
    [CRToastManager showNotificationWithOptions:options
                                completionBlock:nil];
}

+(void)toastDebug:(NSString *)message {
    [CAPToast toastError:[NSString stringWithFormat:@"[调试] %@", message]];
}
@end
