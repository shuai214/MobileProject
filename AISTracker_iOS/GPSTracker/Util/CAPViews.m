//
//  CAPViews.m
//  GPSTracker
//
//  Created by user on 8/6/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

//#define UIColorFromHEX(rgbValue) [UIColor \
//colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
//green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
//blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#import "CAPViews.h"
#import "CAPAlerts.h"
//#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "AppConfig.h"
//#import "CAPGradientView.h"
#import "AppConfig.h"
#import "CAPValidators.h"
#import "CAPSession.h"
#import "CAPPhones.h"
#import "CAPColors.h"
#import "CAPImages.h"
#import "CAPToast.h"

@implementation CAPViews

+ (UIBarButtonItem *)newBarButtonWithText:(NSString *)title target:(nullable id)target action:(nullable SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.accessibilityIdentifier = [NSString stringWithFormat:@"%@_button", title];
    //button.titleLabel.textAlignment = NSTextAlignmentRight;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[CAPColors white] forState:UIControlStateNormal];
    [button setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
    [CAPViews updateBarButtonSize:button];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)newBarButtonWithImage:(NSString *)imageName target:(nullable id)target action:(nullable SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.accessibilityIdentifier = [NSString stringWithFormat:@"%@_button", imageName];
    UIImage *image = [UIImage imageNamed:imageName];
    NSLog(@"size: %@", NSStringFromCGSize(image.size));
    CGRect frame = CGRectMake(0, 0, (image.size.width < 44 ? 44 : image.size.width), 44);
    button.frame = frame;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button setImage:image forState:UIControlStateNormal];
    UIImage *activeImage = [CAPImages maskImage:image withColor:[CAPColors white3]];
    [button setImage:activeImage forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (void)updateBarButtonSize:(UIButton *)button {
    [button sizeToFit];
    CGRect frame = CGRectMake(0, 0, (button.bounds.size.width < 44 ? 44 : button.bounds.size.width), 44);
    button.frame = frame;
}

+(UIBarButtonItem *)createFixedSpaceBarButton:(CGFloat)width {
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = width;
    return fixedSpace;
}

+ (UIView *)createTableSectionHeader:(NSString *)title width:(CGFloat)width {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 36)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 36)];
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[CAPColors white1]];
    //    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    [view addSubview:button];
    return view;
}

+ (UIView *)newTableSectionHeader:(NSString *)title withSize:(CGSize)size {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    view.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:view.frame];
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[CAPColors white1]];
    //    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    [view addSubview:button];
    return view;
}

+ (UIView *)createPhotoTimelineSectionHeader:(NSString *)title width:(CGFloat)width {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 50)];
    view.backgroundColor = [CAPColors gray3];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, width, 46)];
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
    //    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    
    [view addSubview:button];
    return view;
}

+ (void)pushFromViewController:(UIViewController *)viewController storyboarName:(NSString *)storyboardName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    [viewController.navigationController pushViewController:[storyboard instantiateInitialViewController] animated:YES];
}

+ (void)pushFromViewController:(UIViewController *)viewController storyboarName:(NSString *)storyboardName withIdentifier:(NSString *)identifier {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    [viewController.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:identifier] animated:YES];
}
@end
