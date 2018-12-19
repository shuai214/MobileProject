//
//  CAPFormats.h
//  Neptu
//
//  Created by WeifengYao on 22/3/2018.
//  Copyright © 2018 capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAPFormats : NSObject
+ (NSString *_Nullable)formatSize:(CGFloat)size;
+ (NSString *_Nullable)formatGBSize:(CGFloat)size;
+ (NSString *_Nullable)formatSizePercentage:(CGFloat)usageSize totalSize:(CGFloat)totalSize;
+ (NSString *_Nonnull)formatDuration:(NSUInteger)duration;
+ (NSString *_Nonnull)formatDate1:(NSTimeInterval)secs;
@end
