//
//  CAPAlertView.h
//  GPSTracker
//
//  Created by 曹帅 on 2019/1/15.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

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

- (instancetype)initWithFrame:(CGRect)frame contentDesc:(NSString *)desc;

@end

NS_ASSUME_NONNULL_END
