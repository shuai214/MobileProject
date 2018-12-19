//
//  NSData+CAP.m
//  GPSTracker
//
//  Created by WeifengYao on 12/12/2016.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "NSData+CAP.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (CAP)
+ (NSData *)dataFromHexString:(NSString *)hexString {
    NSUInteger length = hexString.length;
    uint8_t bytes[length/2];
    for(int i=0; i<length/2; i++) {
        bytes[i] = 0;
    }
    int hexNumber;
    for(int i=0; i<length; i+=2) {
        const char *hexChar = [[hexString substringWithRange:NSMakeRange(i, 2)] cStringUsingEncoding:NSUTF8StringEncoding];
        sscanf(hexChar, "%x", &hexNumber);
        bytes[i/2] = hexNumber;
    }
    return [NSData dataWithBytes:bytes length:length/2];
}

- (NSData *)md5 {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([self bytes], [self length], result);
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)toString {
    if(self == nil) {
        return @"NULL";
    }
    NSMutableString *str = [NSMutableString stringWithCapacity:self.length*2];
    const unsigned char *bytes = self.bytes;
    for(int  i =0; i<self.length;i++){
        [str appendFormat:@"%02x", bytes[i]];
    }
    return str;
}
@end
