//
//  CAPFenceAlertView.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/2/19.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAPDevice.h"
NS_ASSUME_NONNULL_BEGIN

@interface CAPFenceAlertView : UIView
+ (instancetype)instance;
/**
 *  关闭Block
 */
@property (nonatomic , copy ) void (^closeBlock)(void);

- (void)fillData:(CAPDevice *)deviceInfo content:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
