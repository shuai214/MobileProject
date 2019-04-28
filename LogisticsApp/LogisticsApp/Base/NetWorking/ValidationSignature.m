//
//  ValidationSignature.m
//  ChinaScpetDistributor
//
//  Created by 曹帅 on 2018/9/21.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "ValidationSignature.h"

@implementation ValidationSignature

+ (NSString *)returnMd5EncryptString:(NSDictionary *)dic{
    return [self Encrypt:dic];;
}

+ (BOOL)validationSignature:(NSDictionary *)dic{
//    NSString *md5String = [self Encrypt:dic];
    if (!kStringIsEmpty([SharedLogin shareInstance].md5_KEY)){
        NSString *md5Str = [NSString stringWithFormat:@"%@=%@&",@"data",dic[@"data"]];
        if (kStringIsEmpty(dic[@"data"])) md5Str = @"";
        NSString *md5String = [HMACMD5ToString MD5ForUpper32Bate:md5Str WithKey:[SharedLogin shareInstance].md5_KEY];

        NSString *signature = [dic objectForKey:SIGNATURE_KEY];
            return [md5String isEqualToString:signature];
    }else{
        return nil;
    }
}

+ (NSString *)Encrypt:(NSDictionary *)dataDic{
    
    NSArray *keys = dataDic.allKeys;
    //字母排序
    NSArray *resultkArrSort1 = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSString *MD5Str = @"";
    for (NSString *key in resultkArrSort1) {
        if (![key isEqualToString:SIGNATURE_KEY]) {
            if (!kStringIsEmpty(dataDic[key])){
                NSString *md5Str = [NSString stringWithFormat:@"%@=%@&",key,dataDic[key]];
                MD5Str = [MD5Str stringByAppendingString:md5Str];
            }
        }
    }
     if (!kStringIsEmpty([SharedLogin shareInstance].md5_KEY)){
         NSString *md5String = [HMACMD5ToString MD5ForUpper32Bate:MD5Str WithKey:[SharedLogin shareInstance].md5_KEY];
         return md5String;
     }else{
         return MD5Str;
     }
}
@end
