//
//  CSAccountTool.h
//  ChinaScpetDistributor
//
//  Created by 曹帅 on 2018/9/26.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSAccountTool : NSObject
/** *  存储账号信息 *  @param account 需要存储的账号信息：第一个值为用户名；第二个值为密码 */
+ (void)saveAccount:(NSArray *)account;
/** *  返回存储的账号信息 * @return NSArray */
+ (NSArray *)getAccount;
/** *  返回存储的登陆用户名 *  @return NSString */
+ (NSString *)getUserName;
/** *  返回存储的登陆用户密码 *  @return NSString */
+ (NSString *)getPassword;
/*  删除登陆用户密码 */
+ (void)removeUserPwd;
@end
