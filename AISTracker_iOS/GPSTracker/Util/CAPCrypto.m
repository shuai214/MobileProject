//
//  CAPCrypto.m
//  Ruyi
//
//  Created by WeifengYao on 12/12/2016.
//  Copyright © 2016 capelabs. All rights reserved.
//
#define FileHashDefaultChunkSizeForReadingData 1024*8

#import "CAPCrypto.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

static NSString* const kNonceBase = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

@implementation CAPCrypto
+ (NSData *)md5WithData:(NSData *)data {
    const char *original_str = (const char *)[data bytes];
    unsigned char digist[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, [data length], digist);
    
    return [NSData dataWithBytes:digist length:CC_MD5_DIGEST_LENGTH];
}

+ (NSData *)md5WithString:(NSString *)string {
    const char* original_str=[string UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), digist);
    
    return [NSData dataWithBytes:digist length:CC_MD5_DIGEST_LENGTH];
}

+ (NSData *)md5AtURL:(NSURL *)fileURL {
    return [self md5AtPath:[fileURL path]];
}
+ (NSData *)md5AtPath:(NSString *)filePath {
    return FileMD5HashCreateWithPath((__bridge CFStringRef)filePath, FileHashDefaultChunkSizeForReadingData);
}

NSData* FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
    // Declare needed variables
    //CFStringRef result = NULL;
    NSData *result = nil;
    CFReadStreamRef readStream = NULL;
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  (CFStringRef)filePath,
                                  kCFURLPOSIXPathStyle,
                                  (Boolean)false);
    if (!fileURL) goto done;
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    // Initialize the hash object
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }
    // Feed the data to the hash object
    bool hasMoreData = true;
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        if (readBytesCount == -1) break;
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    }
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    
    // Compute the string result
    result = [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    
done:
    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }
    //return result;
    return result;
}

+ (NSData *)encryptWithAES256Key:(NSString *)key data:(NSData *)data {
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    size_t bufferSize = data.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          data.bytes, data.length,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

+ (NSData *)decryptWithAES256Key:(NSString *)key data:(NSData *)data {
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    //NSUInteger dataLength = [self length];
    size_t bufferSize = data.length + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          data.bytes, data.length,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        
    }
    free(buffer);
    return nil;
}

+ (NSData *)encryptWithAES192Key:(NSData *)keyData ivData:(NSData *)ivData contentData:(NSData *)contentData {
    if(keyData.length != kCCKeySizeAES192) {
        NSLog(@"illegal AES key data length is not 24");
        return nil;
    }
    
    char keyPtr[kCCKeySizeAES192+1];
    bzero(keyPtr, sizeof(keyPtr));
    const uint8_t *keyBytes = keyData.bytes;
    for(int i=0; i<keyData.length; i++) {
        keyPtr[i] = (char)keyBytes[i];
    }
    
    if(ivData.length != kCCKeySizeAES128) {
        NSLog(@"illegal iv data length is not 16");
        return nil;
    }
    char ivPtr[kCCKeySizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    const uint8_t *ivBytes = ivData.bytes;
    for(int i=0; i<ivData.length; i++) {
        ivPtr[i] = (char)ivBytes[i];
    }
    
    NSUInteger dataLength = contentData.length;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    NSInteger nLen=contentData.length;
    //nLen=nLen+ (kCCKeySizeAES128-nLen%kCCKeySizeAES128);
    char *pBuf=malloc(nLen);
    memset(pBuf, 0x20, nLen);//在这个地方 千万不要去填0 ，要不然就出错了，无论你怎么测都又问题
    memcpy(pBuf, contentData.bytes, nLen);
    dataLength=nLen;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          0x0000,
                                          keyPtr,
                                          kCCKeySizeAES192,
                                          ivPtr,
                                          pBuf,
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

+ (NSData *)decryptWithAES192Key:(NSData *)keyData ivData:(NSData *)ivData contentData:(NSData *)contentData {
    if(keyData.length != kCCKeySizeAES192) {
        NSLog(@"illegal key data length is not 24");
        return nil;
    }
    
    char keyPtr[kCCKeySizeAES192+1];
    bzero(keyPtr, sizeof(keyPtr));
    const uint8_t *keyBytes = keyData.bytes;
    for(int i=0; i<keyData.length; i++) {
        keyPtr[i] = (char)keyBytes[i];
    }
    
    if(ivData.length != kCCKeySizeAES128) {
        NSLog(@"illegal iv data length is not 16");
        return nil;
    }
    char ivPtr[kCCKeySizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    const uint8_t *ivBytes = ivData.bytes;
    for(int i=0; i<ivData.length; i++) {
        ivPtr[i] = (char)ivBytes[i];
    }
    
    NSUInteger dataLength = contentData.length;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    NSInteger nLen=contentData.length;
    //nLen=nLen+ (kCCKeySizeAES128-nLen%kCCKeySizeAES128);
    char *pBuf=malloc(nLen);
    memset(pBuf, 0x20, nLen);//在这个地方 千万不要去填0 ，要不然就出错了，无论你怎么测都又问题
    memcpy(pBuf, contentData.bytes, nLen);
    dataLength=nLen;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          0x0000,
                                          keyPtr,
                                          kCCKeySizeAES192,
                                          ivPtr,
                                          pBuf,
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

+ (NSData *)encryptWithAES256Key:(NSData *)keyData ivData:(NSData *)ivData contentData:(NSData *)contentData {
    if(keyData.length != kCCKeySizeAES256) {
        NSLog(@"illegal AES key data length is not 32");
        return nil;
    }

    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    const uint8_t *keyBytes = keyData.bytes;
    for(int i=0; i<keyData.length; i++) {
        keyPtr[i] = (char)keyBytes[i];
    }

    if(ivData.length != kCCKeySizeAES128) {
        NSLog(@"illegal iv data length is not 16");
        return nil;
    }
    char ivPtr[kCCKeySizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    const uint8_t *ivBytes = ivData.bytes;
    for(int i=0; i<ivData.length; i++) {
        ivPtr[i] = (char)ivBytes[i];
    }

    NSUInteger dataLength = contentData.length;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    NSInteger nLen=contentData.length;
    //nLen=nLen+ (kCCKeySizeAES128-nLen%kCCKeySizeAES128);
    char *pBuf=malloc(nLen);
    memset(pBuf, 0x20, nLen);//在这个地方 千万不要去填0 ，要不然就出错了，无论你怎么测都又问题
    memcpy(pBuf, contentData.bytes, nLen);
    dataLength=nLen;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          0x0000,
                                          keyPtr,
                                          kCCKeySizeAES256,
                                          ivPtr,
                                          pBuf,
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

+ (NSData *)decryptWithAES256Key:(NSData *)keyData ivData:(NSData *)ivData contentData:(NSData *)contentData {
    if(keyData.length != kCCKeySizeAES256) {
        NSLog(@"illegal key data length is not 32");
        return nil;
    }
    
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    const uint8_t *keyBytes = keyData.bytes;
    for(int i=0; i<keyData.length; i++) {
        keyPtr[i] = (char)keyBytes[i];
    }
    
    if(ivData.length != kCCKeySizeAES128) {
        NSLog(@"illegal iv data length is not 16");
        return nil;
    }
    char ivPtr[kCCKeySizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    const uint8_t *ivBytes = ivData.bytes;
    for(int i=0; i<ivData.length; i++) {
        ivPtr[i] = (char)ivBytes[i];
    }
    
    NSUInteger dataLength = contentData.length;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    NSInteger nLen=contentData.length;
    //nLen=nLen+ (kCCKeySizeAES128-nLen%kCCKeySizeAES128);
    char *pBuf=malloc(nLen);
    memset(pBuf, 0x20, nLen);//在这个地方 千万不要去填0 ，要不然就出错了，无论你怎么测都又问题
    memcpy(pBuf, contentData.bytes, nLen);
    dataLength=nLen;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          0x0000,
                                          keyPtr,
                                          kCCKeySizeAES256,
                                          ivPtr,
                                          pBuf,
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

+ (NSString *)SHA1:(NSString *)text {
    const char *cstr = [text cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:text.length];

    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

+ (NSString *)newNonceOfLength:(NSUInteger)length {
    NSMutableString *sb = [[NSMutableString alloc] initWithCapacity:length];
    NSUInteger index;
    for (NSUInteger i = 0; i < length; i++) {
        index = arc4random()%kNonceBase.length;
        [sb appendString:[kNonceBase substringWithRange:NSMakeRange(index, 1)]];
    }
    return sb;
}

@end
