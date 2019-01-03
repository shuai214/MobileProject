//
//  CAPAlerts.h
//  GPSTracker
//
//  Created by WeifengYao on 12/7/2017.
//  Copyright © 2017 capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSObject CAPAlert;

typedef void (^CAPAlertActionBlock)(void);
typedef void (^CAPAlertSwitchBlock)(BOOL isOn);
typedef void (^CAPAlertEditBlock)(NSString * _Nullable text);

@interface CAPAlerts : NSObject
+ (CAPAlert *_Nullable)alertSuccess:(NSString *_Nullable)message;
+ (void)alertSuccess:(NSString *_Nullable)message actionBlock:(CAPAlertActionBlock _Nullable)action;
+ (void)alertSuccess:(NSString *_Nullable)message buttonTitle:(NSString *_Nullable)buttonTitle actionBlock:(CAPAlertActionBlock _Nullable)action;
+ (void)showSuccess:(NSString *)message subTitle:(NSString *)subTitle buttonTitle:(NSString *)buttonTitle cancleButtonTitle:(NSString *)cancleTitle actionBlock:(CAPAlertActionBlock)action;
+ (void)alertWarning:(NSString *_Nullable)message;
+ (void)alertWarning:(NSString *_Nullable)title message:(NSString *_Nullable)message;
+ (void)alertWarning:(NSString *_Nullable)message actionBlock:(CAPAlertActionBlock _Nullable)action;
+ (void)alertWarning:(NSString *_Nullable)message buttonTitle:(NSString *_Nonnull)title actionBlock:(CAPAlertActionBlock _Nullable)action;
+ (void)alertWarningWithoutClose:(NSString *_Nullable)message buttonTitle:(NSString *_Nullable)title actionBlock:(CAPAlertActionBlock _Nullable)action;
+ (void)alertWarning:(NSString *_Nullable)message positiveActionBlock:(CAPAlertActionBlock _Nullable)positiveAction negativeActionBlock:(CAPAlertActionBlock _Nullable)negativeAction;

+ (void)alertError:(NSString *_Nullable)message;
+ (void)alertError:(NSString *_Nullable)message actionBlock:(CAPAlertActionBlock _Nullable)action;
+ (void)alertError:(NSString *_Nullable)message actionBlock:(CAPAlertSwitchBlock)action switchLabel:(NSString *_Nonnull)label;
+ (void)alertError:(NSString *_Nullable)message buttonTitle:(NSString *_Nullable)buttonTitle actionBlock:(CAPAlertActionBlock _Nullable)action;
+ (CAPAlert *_Nullable)alertError:(NSString *_Nullable)message positiveTitle:(NSString *_Nullable)positiveTitle positiveActionBlock:(CAPAlertActionBlock _Nullable)positiveAction negativeTitle:(NSString *_Nullable)negativeTitle negativeActionBlock:(CAPAlertActionBlock _Nullable)negativeAction;


+ (void)alertChooser:(NSArray * _Nullable)titles icons:(NSArray * _Nullable)icons target:(nullable id)target action:(nullable SEL)action  currentSelectedIndex:(NSUInteger)index;

+ (void)alertDetail:(NSArray * _Nullable)keys values:(NSArray * _Nullable)values actionBlock:(CAPAlertActionBlock)action;

+ (void)alertEdit:(UIViewController *_Nonnull)vc title:(NSString *_Nullable)title subTitle:(NSString *)subtitle defaultText:(NSString *_Nullable)defaultText  placeholder:(NSString *_Nullable)placeholder actionBlock:(CAPAlertEditBlock _Nullable)action;

+ (void)alertCustomViews:(NSArray *_Nullable)views actionBlock:(CAPAlertActionBlock _Nullable)action;
+ (void)hideAnyAlert;
+ (void)hideAlert;
+ (void)hideAlert:(CAPAlert *_Nonnull)alert;
@end
