//
//  AESEnrypt.h
//  ChinaScpetDistributor
//
//  Created by 曹帅 on 2018/10/15.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AESEnrypt : NSObject
+ (NSString*) AES128Encrypt:(NSString *)plainText;

+ (NSString*) AES128Decrypt:(NSString *)encryptText;
@end
