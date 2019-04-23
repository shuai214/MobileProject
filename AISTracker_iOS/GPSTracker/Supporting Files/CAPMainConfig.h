//
//  CAPMainConfig.h
//  GPSTrackerSDK
//
//  Created by capaipai@sina.com on 2019/3/27.
//  Copyright © 2019年 capaipai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAPMainConfig : NSObject
+ (instancetype)mainConfig;
- (void)googleMapConfig;
- (void)trueLoginConfig;
- (void)openFireBase;
@end

NS_ASSUME_NONNULL_END
