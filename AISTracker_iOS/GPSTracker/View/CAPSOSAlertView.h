//
//  CAPSOSAlertView.h
//  GPSTracker
//
//  Created by 曹帅 on 2019/1/21.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQTTInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface CAPSOSAlertView : UIView
/**
 *  关闭Block
 */
@property (nonatomic , copy ) void (^closeAddressBlock)(void);
/**
 *  确定Block
 */
@property (nonatomic , copy ) void (^okAddressBlock)(MQTTInfo *info);

+ (instancetype)instance;
- (void)fillData:(MQTTInfo *)info;
@end

NS_ASSUME_NONNULL_END
