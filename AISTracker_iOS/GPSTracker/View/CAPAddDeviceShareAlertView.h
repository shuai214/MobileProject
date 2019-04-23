//
//  CAPAddDeviceShareAlertView.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/4/4.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAPAddDeviceShareAlertView : UIView
+ (instancetype)instance;
- (void)fillContent:(NSString *)content deviceID:(NSString *)deviceID;
/**
 *  关闭Block
 */
@property (nonatomic , copy ) void (^okBlock)(void);

@end

NS_ASSUME_NONNULL_END
