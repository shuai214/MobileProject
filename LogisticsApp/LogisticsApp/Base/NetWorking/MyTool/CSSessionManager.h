//
//  CSSessionManager.h
//  ChinaScpetDistributor
//
//  Created by 曹帅 on 2018/9/17.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSSessionManager : NSObject
// 存储session
+(void)saveSession:(NSString *)session;
// 读取session
+(NSString *)getsSession;
// 清空session
+(void)cleanSession;
// 跟新session
+(NSString *)refreshSession;
@end
