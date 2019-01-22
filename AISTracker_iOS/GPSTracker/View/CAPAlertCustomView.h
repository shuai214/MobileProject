//
//  CAPAlertView.h
//  GPSTracker
//
//  Created by 曹帅 on 2019/1/15.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, AlertType) {
    AlertTypeCustom= 0,
    AlertTypeNoClose,
    AlertTypeTime,
    AlertTypeTwoButton,
    AlertTypeButton
};
NS_ASSUME_NONNULL_BEGIN

@interface CAPAlertCustomView : UIView
/**
 *  关闭Block
 */
@property (nonatomic , copy ) void (^closeBlock)(void);
/**
 *  确定Block
 */
@property (nonatomic , copy ) void (^okBlock)(void);

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title contentDesc:(NSString *)desc alertType:(AlertType)alertType;

@end

NS_ASSUME_NONNULL_END
