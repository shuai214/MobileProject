//
//  NSObject+KVO.h
//  MobileProject
//
//  Created by capaipai@sina.com on 2018/11/30.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CSObserverBlock)(id observerObject , NSString *obertverKey,id oldValue,id newValue);
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KVO)
- (void)CS_addObserver:(NSObject *)observer forKey:(NSString *)key block:(CSObserverBlock)block;

- (void)CS_removeObserver:(NSObject *)observer forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
