//
//  CSAccountTool.m
//  ChinaScpetDistributor
//
//  Created by 曹帅 on 2018/9/26.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "CSAccountTool.h"

@implementation CSAccountTool
+ (void)saveAccount:(NSArray *)account{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //保存数据 用户信息；用户名；用户密码
    [userDefaults setObject:account  forKey:@"account" ];
    [userDefaults setObject:[account objectAtIndex:0]  forKey:@"userName" ];
    [userDefaults setObject:[account objectAtIndex:1]  forKey:@"passWord" ];
}
+ (NSArray *)getAccount{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userDefaults objectForKey:@"account"];
    return array;
    
}
+ (NSString *)getUserName{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:@"userName"];
    return userName;
    
}
+ (NSString *)getPassword{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *passWord = [userDefaults objectForKey:@"passWord"];
    return passWord;
    
}
+ (void)removeUserPwd{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"userName"];
    [defaults removeObjectForKey:@"passWord"];
    [defaults synchronize];
}
@end
