//
//  NSString+Size.m
//  GPSTracker
//
//  Created by Weifeng on 11/15/16.
//  Copyright © 2016 Capelabs. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)
- (CGSize)sizeWithAttributes:(NSDictionary *)attributes maxSize:(CGSize)maxSize {
    return [self boundingRectWithSize:maxSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:attributes context:nil].size;
}

+ (NSString *)calculateStringLength:(NSString *)userID{
    if (userID.length >= 10) {
        return userID;
    }else{
        NSString *zero = @"0";
        NSInteger length = 10 - userID.length;
        for (NSInteger i = 0; i < length; i++) {
           userID = [zero stringByAppendingString:userID];
        }
        return userID;
    }
    return userID;
}

@end
