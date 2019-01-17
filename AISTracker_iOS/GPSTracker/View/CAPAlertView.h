//
//  CAPAlertView.h
//  GPSTracker
//
//  Created by 曹帅 on 2019/1/15.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAPAlertCustomView.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^closeBlock)(void);
typedef void (^okBlock)(void);
typedef void (^okAddressBlock)(NSString *name);

@interface CAPAlertView : NSObject
+ (void)initAlertWithContent:(NSString *)content title:(NSString *)title closeBlock:(closeBlock)closeBlock okBlock:(okBlock)okBlock alertType:(AlertType)alertType;
+ (void)initAlertWithContent:(NSString *)content okBlock:(okBlock)okBlock alertType:(AlertType)alertType;
+ (void)initAddressAlertWithContent:(NSString *)content ocloseBlock:(closeBlock)closeBlock okBlock:(okAddressBlock)okBlock;
@end

NS_ASSUME_NONNULL_END
