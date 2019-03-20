//
//  CAPDeviceVerAlertView.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/2/17.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAPDeviceVerAlertView : UIView
/**
 *  关闭Block
 */
@property (nonatomic , copy ) void (^closeBlock)(void);
/**
 *  确定Block
 */
@property (nonatomic , copy ) void (^okBlock)(void);
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title buttonTitle:(NSString *)buttonTitle;
@end

NS_ASSUME_NONNULL_END
