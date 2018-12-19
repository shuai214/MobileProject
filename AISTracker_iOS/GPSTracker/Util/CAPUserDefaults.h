//
//  CAPUserDefaults.h
//  GPSTracker
//
//  Created by WeifengYao on 7/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAPUserDefaults : NSObject

+ (nullable id)objectForKey:(NSString *)defaultName;

+ (void)setObject:(nullable id)value forKey:(NSString *)defaultName;

+ (void)removeObjectForKey:(NSString *)defaultName;

+ (nullable NSString *)stringForKey:(NSString *)defaultName;

+ (nullable NSArray *)arrayForKey:(NSString *)defaultName;

+ (nullable NSDictionary<NSString *, id> *)dictionaryForKey:(NSString *)defaultName;

+ (nullable NSData *)dataForKey:(NSString *)defaultName;

+ (nullable NSArray<NSString *> *)stringArrayForKey:(NSString *)defaultName;

+ (NSInteger)integerForKey:(NSString *)defaultName;

+ (float)floatForKey:(NSString *)defaultName;

+ (double)doubleForKey:(NSString *)defaultName;

+ (BOOL)boolForKey:(NSString *)defaultName;

+ (nullable NSURL *)URLForKey:(NSString *)defaultName API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));

+ (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName;

+ (void)setFloat:(float)value forKey:(NSString *)defaultName;

+ (void)setDouble:(double)value forKey:(NSString *)defaultName;

+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName;

+ (void)setURL:(nullable NSURL *)url forKey:(NSString *)defaultName API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));
@end
