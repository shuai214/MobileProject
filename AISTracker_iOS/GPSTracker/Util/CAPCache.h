//
//  CAPCache.h
//  Neptu
//
//  Created by WeifengYao on 20/10/2017.
//  Copyright © 2017 capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAPCache : NSObject

+ (void)storeImage:(UIImage *_Nonnull)image forKey:(NSString *_Nonnull)key;
+ (void)storeImageData:(NSData *_Nonnull)imageData forKey:(NSString *_Nonnull)key;
+ (UIImage *_Nullable)imageForKey:(NSString *_Nonnull)key;
+ (void)removeImageForKey:(NSString *_Nonnull)key;

+ (void)clearWithCompletionBlock:(void(^_Nullable)())completionBlock;
+ (NSUInteger)cacheSize;


/**
 判断是否缓存中key是否存在
 */
//- (BOOL)containsObjectForKey:(NSString *_Nonnull)key;

/**
 返回key对应的对象
 */
//- (nullable id<NSCoding>)objectForKey:(NSString *_Nonnull)key;

/**
 设置key对应的对象
 */
//- (void)storeObject:(nullable id<NSCoding>)object forKey:(NSString *_Nonnull)key;

/**
 移除key对应的对象
 */
//- (void)removeObjectForKey:(NSString *_Nonnull)key;

@end
