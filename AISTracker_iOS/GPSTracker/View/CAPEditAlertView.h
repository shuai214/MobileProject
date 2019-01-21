//
//  CAPEditAlertView.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/21.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAPEditAlertView : UIView
/**
 *  关闭Block
 */
@property (nonatomic , copy ) void (^closeAddressBlock)(void);
/**
 *  确定Block
 */
@property (nonatomic , copy ) void (^okAddressBlock)(NSString *name);

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
