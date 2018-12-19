//
//  CAPViews.h
//  GPSTracker
//
//  Created by user on 8/6/16.
//  Copyright © 2016 capelabs. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface CAPViews : NSObject
+ (UIBarButtonItem *_Nullable)newBarButtonWithText:(NSString *_Nonnull)title target:(nullable id)target action:(nullable SEL)action;
+ (UIBarButtonItem *_Nullable)newBarButtonWithImage:(NSString *_Nullable)imageName target:(nullable id)target action:(nullable SEL)action;
+ (void)updateBarButtonSize:(UIButton *_Nonnull)button;
+ (UIBarButtonItem *_Nonnull)createFixedSpaceBarButton:(CGFloat)width;

+ (UIView *_Nullable)createTableSectionHeader:(NSString *_Nullable)title width:(CGFloat)width;
+ (UIView *_Nullable)newTableSectionHeader:(NSString *_Nullable)title withSize:(CGSize)size;
+ (UIView *_Nonnull)createPhotoTimelineSectionHeader:(NSString *_Nonnull)title width:(CGFloat)width;

+ (void)pushFromViewController:(UIViewController *)viewController storyboarName:(NSString *)storyboardName;
+ (void)pushFromViewController:(UIViewController *)viewController storyboarName:(NSString *)storyboardName withIdentifier:(NSString *)identifier;
@end
