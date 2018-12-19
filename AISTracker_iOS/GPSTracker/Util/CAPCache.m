//
//  CAPCache.m
//  Neptu
//
//  Created by WeifengYao on 20/10/2017.
//  Copyright © 2017 capelabs. All rights reserved.
//

#import "CAPCache.h"
#import "AppConfig.h"
#import <SDWebImage/SDImageCache.h>

@implementation CAPCache

+ (void)storeImage:(UIImage *)image forKey:(NSString *)key {
    if(!gCfg.cacheOff) {
        [[SDImageCache sharedImageCache] storeImage:image forKey:key toDisk:YES];
    }
}

+ (void)storeImageData:(NSData *)imageData forKey:(NSString *)key {
    if(!gCfg.cacheOff) {
        [[SDImageCache sharedImageCache] storeImageDataToDisk:imageData forKey:key];
    }
}

+ (UIImage *)imageForKey:(NSString *)key {
    UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key];
    if(!image) {
        image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    }
    return image;
}

+ (void)removeImageForKey:(NSString *)key {
    [[SDImageCache sharedImageCache] removeImageForKey:key];
}

+ (void)clearWithCompletionBlock:(void(^)())completionBlock {
    //[CAPToast toastSuccess:[NSString stringWithFormat:@"cache size-1 %lu", [[SDImageCache sharedImageCache] getSize]]];
    //[[SDImageCache sharedImageCache] cleanDisk];
    
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:completionBlock];
    //    [[SDImageCache sharedImageCache] cleanDiskWithCompletionBlock:completionBlock];
    //
    //    [CAPToast toastSuccess:[NSString stringWithFormat:@"cache size-2 %lu", [[SDImageCache sharedImageCache] getSize]]];
}

+ (NSUInteger)cacheSize {
    return [[SDImageCache sharedImageCache] getSize];
}

/**
 判断是否缓存中key是否存在
 */
- (BOOL)containsObjectForKey:(NSString *)key {
    return NO;
}

- (nullable id<NSCoding>)objectForKey:(NSString *)key {
    return nil;
}

- (void)storeObject:(nullable id<NSCoding>)object forKey:(NSString *)key {
    
}

- (void)removeObjectForKey:(NSString *)key {
    
}

@end
