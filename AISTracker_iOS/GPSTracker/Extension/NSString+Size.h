//
//  NSString+Size.h
//  GPSTracker
//
//  Created by Weifeng on 11/15/16.
//  Copyright © 2016 Capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Size)
/**
 *  根据文字计算高宽
 */
- (CGSize)sizeWithAttributes:(NSDictionary *)attributes maxSize:(CGSize)maxSize;

+ (NSString *)calculateStringLength:(NSString *)userID;
@end
