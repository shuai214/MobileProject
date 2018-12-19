//
//  UIColor+CAP.h
//  GPSTracker
//
//  Created by user on 7/22/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CAP)
+ (UIColor*)colorFromHex:(NSInteger)hexValue;
+ (UIColor*)colorFromHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (NSString *)hexFromUIColor: (UIColor*) color;
+ (UIColor *)randomColor;

- (UIColor *)darkerShade;
- (UIColor *)lighterShade;
- (UIColor *)withAlpha:(CGFloat)alpha;
- (NSString *)hexString;
@end
