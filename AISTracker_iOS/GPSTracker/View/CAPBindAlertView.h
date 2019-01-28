//
//  CAPBindAlertView.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/24.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CAPBindAlertView : UIView
/**
 *  关闭Block
 */
@property (nonatomic , copy ) void (^closeUserBlock)(void);
/**
 *  确定Block
 */
@property (nonatomic , copy ) void (^okBindUserBlock)(void);

+ (instancetype)instance;

- (void)fillData:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
