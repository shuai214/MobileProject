//
//  CAPAlertView.h
//  GPSTracker
//
//  Created by 曹帅 on 2019/1/15.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAPAlertCustomView.h"
#import "MQTTInfo.h"
#import "CAPDevice.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^closeBlock)(void);
typedef void (^okBlock)(void);
typedef void (^okAddressBlock)(NSString *name);
typedef void (^okMQTTInfoBlock)(MQTTInfo *info);
typedef void (^takingPhotoBlock)(void);
typedef void (^albumBlock)(void);

@interface CAPAlertView : NSObject
+ (void)initAlertWithContent:(NSString *)content title:(NSString *)title closeBlock:(closeBlock)closeBlock okBlock:(okBlock)okBlock alertType:(AlertType)alertType;
+ (void)initAlertWithContent:(NSString *)content okBlock:(okBlock)okBlock alertType:(AlertType)alertType;
+ (void)initCloseAlertWithContent:(NSString *)content title:(NSString *)title closeBlock:(closeBlock)closeBlock alertType:(AlertType)alertType;
+ (void)initAddressAlertWithContent:(NSString *)content ocloseBlock:(closeBlock)closeBlock okBlock:(okAddressBlock)okBlock;
+ (void)initAddressEditWithContent:(NSString *)content ocloseBlock:(closeBlock)closeBlock okBlock:(okAddressBlock)okBlock;
+ (void)initSOSAlertViewWithContent:(MQTTInfo *)contentInfo ocloseBlock:(closeBlock)closeBlock okBlock:(okMQTTInfoBlock)okMQTTInfoBlock;
+ (void)initTakingPhotoBlock:(takingPhotoBlock)takingBlock albumBlock:(albumBlock)albumBlock closeBlock:(closeBlock)closeBlock;
+ (void)initBindAlertViewWithContent:(NSString *)content ocloseBlock:(closeBlock)closeBlock okBlock:(okBlock)okBlock;
+ (void)initDeviceVerWithContent:(NSString *)content closeBlock:(closeBlock)closeBlock okBlock:(okBlock)okBlock;
+ (void)initDeviceFenceAlertView:(CAPDevice *)deviceInfo content:(NSString *)content closeBlock:(closeBlock)closeBlock;
@end

NS_ASSUME_NONNULL_END
