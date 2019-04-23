//
//  CAPConfig.h
//  GPSTrackerSDK
//
//  Created by capaipai@sina.com on 2019/3/26.
//  Copyright © 2019年 capaipai. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^CAPHUDCancelReply)();

NS_ASSUME_NONNULL_BEGIN

@interface CAPConfig : NSObject
- (instancetype)init;
- (void)showHUD;
- (void)showHUD:(NSString *)title;
- (void)showHUDWithCancelTitle:(NSString *)cancelTitle onCancelled:(CAPHUDCancelReply)cancelBlock;
- (void)showHUD:(NSString *)title cancelTitle:(NSString *)cancelTitle onCancelled:(CAPHUDCancelReply)cancelBlock;
- (void)showHUDWithCancel;

- (void)updateProgress:(CGFloat)progress;
- (void)showNotifyInfo:(NSString *)info backGroundColor:(UIColor *)color;
- (void)hideHUD;
@end

extern CAPConfig* capgApp;

NS_ASSUME_NONNULL_END
