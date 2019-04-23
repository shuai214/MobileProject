//
//  CAPAlertMessageView.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/3/22.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAPAlertMessageView : UIView
+ (instancetype)instance;
/**
 *  关闭Block
 */
@property (nonatomic , copy ) void (^closeBlock)(void);
- (void)initContentView:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
