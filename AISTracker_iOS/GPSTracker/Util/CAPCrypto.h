//
//  CAPCrypto.h
//  Ruyi
//
//  Created by WeifengYao on 12/12/2016.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAPCrypto : NSObject
+ (NSData *)md5WithData:(NSData *)data;
+ (NSData *)md5WithString:(NSString *)string;
+ (NSData *)md5AtURL:(NSURL *)fileURL;
+ (NSData *)md5AtPath:(NSString *)filePath;

+ (NSData *)encryptWithAES256Key:(NSString *)key data:(NSData *)data;
+ (NSData *)decryptWithAES256Key:(NSString *)key data:(NSData *)data;

+ (NSData *)encryptWithAES192Key:(NSData *)keyData ivData:(NSData *)ivData contentData:(NSData *)contentData;
+ (NSData *)decryptWithAES192Key:(NSData *)keyData ivData:(NSData *)ivData contentData:(NSData *)contentData;

+ (NSData *)encryptWithAES256Key:(NSData *)keyData ivData:(NSData *)ivData contentData:(NSData *)contentData;
+ (NSData *)decryptWithAES256Key:(NSData *)keyData ivData:(NSData *)ivData contentData:(NSData *)contentData;

+ (NSString *)SHA1:(NSString *)text;

+ (NSString *)newNonceOfLength:(NSUInteger)length;
@end
