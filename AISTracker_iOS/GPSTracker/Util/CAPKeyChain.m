//
//  CAPKeyChain.m
//  Neptu
//
//  Created by WeifengYao on 31/10/2017.
//  Copyright © 2017 capelabs. All rights reserved.
//

#import "CAPKeyChain.h"
#import <Security/Security.h>

NSString * const MLM_KEYCHAIN_KEY = @"com.capelabs.neptu.keychain";

@implementation CAPKeyChain

+ (NSMutableDictionary *)keychainService:(NSString *)serviceKey {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            serviceKey, (id)kSecAttrService,
            serviceKey, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (id)read {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self keychainService:MLM_KEYCHAIN_KEY];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"ERROR: unarchive failed: %@", e);
        } @finally {
        }
    }
    if (keyData) {
        CFRelease(keyData);
    }
    return ret;
}

+ (void)save:(id)data {
    NSMutableDictionary *keychainQuery = [self keychainService:MLM_KEYCHAIN_KEY];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (void)remove {
    NSMutableDictionary *keychainQuery = [self keychainService:MLM_KEYCHAIN_KEY];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

+ (void)save:(NSString *)key data:(id)data {
    NSMutableDictionary *dict = [self read];
    if(!dict) {
        dict = [NSMutableDictionary dictionaryWithCapacity:8];
    }
    [dict setObject:data forKey:key];
    [self save:dict];
}

+ (id)read:(NSString *)key {
    NSDictionary *dict = [self read];
    return (dict ? [dict objectForKey:key] : nil);
}

+ (void)remove:(NSString *)key {
    NSMutableDictionary *dict = [self read];
    if(dict) {
        [dict removeObjectForKey:key];
        [self save:dict];
    }
}

@end
