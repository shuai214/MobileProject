//
//  SVProgressAnimatedView.h
//  SDKSVProgressHUD, https://github.com/SDKSVProgressHUD/SDKSVProgressHUD
//
//  Copyright (c) 2017 Tobias Tiemerding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVProgressAnimatedView : UIView

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat strokeThickness;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat strokeEnd;

@end
