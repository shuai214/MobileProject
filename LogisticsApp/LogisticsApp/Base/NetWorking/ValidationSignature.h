//
//  ValidationSignature.h
//  ChinaScpetDistributor
//
//  Created by 曹帅 on 2018/9/21.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidationSignature : NSObject
//MD5加密
+ (NSString *)returnMd5EncryptString:(NSDictionary *)dic;
//验签
+ (BOOL)validationSignature:(NSDictionary *)dic;
@end
