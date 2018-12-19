//
//  CAPBaseViewController.h
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAPBaseViewController : UIViewController

- (void)refreshLocalizedString;

- (void)setBarTitle:(nullable NSString *)title;
- (void)setTintColor:(nullable UIColor *)color;

- (void)setRightBarTextButton:(NSString *_Nonnull)text textColor:(UIColor *_Nonnull)textColor action:(nullable SEL)action;
- (void)setRightBarImageButton:(NSString *_Nonnull)imageName action:(nullable SEL)action;

- (void)showBackBarItem;
- (void)hideBackBarItem;

- (void)goHome;
- (void)goBack;

- (BOOL)isNetworkReady;
- (BOOL)assureNetwork;
@end
