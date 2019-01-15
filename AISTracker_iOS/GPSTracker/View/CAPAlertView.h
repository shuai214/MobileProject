//
//  CAPAlertView.h
//  GPSTracker
//
//  Created by 曹帅 on 2019/1/15.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^closeBlock)(void);
typedef void (^okBlock)(void);

@interface CAPAlertView : NSObject
- (void)initAlertWithContent:(NSString *)content closeBlock:(closeBlock)closeBlock okBlock:(okBlock)okBlock;
@end

NS_ASSUME_NONNULL_END
