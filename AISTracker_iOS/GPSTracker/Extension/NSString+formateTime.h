//
//  NSString+formateTime.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2018/12/30.
//  Copyright © 2018年 Capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (formateTime)
+ (NSString *)dateFormateWithTimeInterval:(NSTimeInterval)timeInterval;
@end

NS_ASSUME_NONNULL_END
