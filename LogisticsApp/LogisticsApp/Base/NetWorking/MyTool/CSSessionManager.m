//
//  CSSessionManager.m
//  ChinaScpetDistributor
//
//  Created by 曹帅 on 2018/9/17.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "CSSessionManager.h"
NSString *const SESSION_KEY = @"session";

@implementation CSSessionManager
+(void)saveSession:(NSString *)session{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSData *sessionData = [NSKeyedArchiver archivedDataWithRootObject:session];
    [userDefaults setObject:sessionData forKey:SESSION_KEY];
    [userDefaults synchronize];
}

// 读取session
+(NSString *)getsSession{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *sessionData = [userDefaults objectForKey:SESSION_KEY];
    NSString *session = [NSKeyedUnarchiver unarchiveObjectWithData:sessionData];
    [userDefaults synchronize];
    return session;
}

// 清空session
+(void)cleanSession{
    NSUserDefaults *UserLoginState = [NSUserDefaults standardUserDefaults];
    [UserLoginState removeObjectForKey:SESSION_KEY];
    [UserLoginState synchronize];
}


// 跟新session
+(NSString *)refreshSession{
    return nil;
}
@end
