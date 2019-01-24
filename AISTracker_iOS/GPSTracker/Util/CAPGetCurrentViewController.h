//
//  CAPGetCurrentViewController.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/22.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAPGetCurrentViewController : NSObject
+ (UIViewController *)getCurrentViewController;
+ (UIViewController *)findCurrentViewController;
@end

NS_ASSUME_NONNULL_END
