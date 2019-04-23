//
//  CAPLogin.h
//  GPSTrackerSDK
//
//  Created by capaipai@sina.com on 2019/3/27.
//  Copyright © 2019年 capaipai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAPLogin : NSObject
+ (instancetype)login;
//使用True ID 登录，将登录信息传入该接口。
- (void)trueIdLoginUserInfo:(NSDictionary *)loginUserInfo;
@end

NS_ASSUME_NONNULL_END
