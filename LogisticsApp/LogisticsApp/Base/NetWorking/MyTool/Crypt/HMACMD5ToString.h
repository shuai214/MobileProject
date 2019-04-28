//
//  HMACMD5ToString.h
//  ChinaScpetDistributor
//
//  Created by 曹帅 on 2018/9/13.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMACMD5ToString : NSObject
+ (NSString *)HMACMD5WithString:(NSString *)toEncryptStr WithKey:(NSString *)keyStr;
+(NSString *)MD5ForUpper32Bate:(NSString *)str WithKey:(NSString *)keyStr;
@end
