//
//  SharedLogin.h
//  ChinaScpetDistributor
//
//  Created by 曹帅 on 2018/9/27.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedLogin : NSObject
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *md5_KEY;
@property (nonatomic,copy)NSString *sessionid;
+(instancetype) shareInstance;

- (void)login;
@end
