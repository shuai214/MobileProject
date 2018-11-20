//
//  BaseViewController.h
//  MobileProject
//
//  Created by capaipai@sina.com on 2018/11/20.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Color.h"

NS_ASSUME_NONNULL_BEGIN


@protocol CSBaseViewControllerDelegate <NSObject>
@optional
- (void)left_Button_event:(UIButton *)sender;
- (void)right_Button_event:(UIButton *)sender;
- (void)title_click_event:(UIView *)sender;
@end

@protocol CSBaseViewControllerDataSource <NSObject>
@optional
- (NSMutableAttributedString *)setTitle;//设置title
- (UIButton *)set_leftButton;
- (UIButton *)set_rightButton;
- (UIImage  *)set_leftBarButtonItemWithImage;
- (UIImage  *)set_rightBarButtonItemWithImage;
- (UIColor  *)set_backGroundColor;
- (UIImage  *)navBackgroundImage;
- (BOOL)hideNavigationBottomLine;//隐藏导航栏底部的线条
@end

@interface BaseViewController : UIViewController<CSBaseViewControllerDelegate,CSBaseViewControllerDataSource>
/**
 导航栏高度 如果想隐藏导航栏可以设置TranslationY为 -64；
 */
- (void)changeNavigationBarTranslationY:(CGFloat)TranslationY;
/**
 设置controller的title
*/
-(void)set_Title:(NSMutableAttributedString *)title;

@end

NS_ASSUME_NONNULL_END
