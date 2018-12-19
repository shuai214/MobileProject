//
//  UIColor+CAP.m
//  GPSTracker
//
//  Created by user on 7/22/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "UIColor+CAP.h"

@implementation UIColor (CAP)

+ (UIColor*)colorFromHex:(NSInteger)hexValue {
    return [UIColor colorFromHex:hexValue alpha:1.0];
}

+ (UIColor*)colorFromHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (NSString *)hexFromUIColor: (UIColor*) color {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"#%x%x%x", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

+ (UIColor *)randomColor {
    return [UIColor colorWithRed:(arc4random() % 256) /255.0 green:(arc4random() % 256) /255.0 blue:(arc4random() % 256) /255.0 alpha:1];
}

- (UIColor *)darkerShade {
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
                               green:MAX(g - 0.2, 0.0)
                                blue:MAX(b - 0.2, 0.0)
                               alpha:a];
    return self;
}

- (UIColor *)lighterShade {
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r + 0.2, 1.0)
                               green:MAX(g + 0.2, 1.0)
                                blue:MAX(b + 0.2, 1.0)
                               alpha:a];
    return self;
}

- (UIColor *)withAlpha:(CGFloat)alpha {
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:r
                               green:g
                                blue:b
                               alpha:MIN(MAX(alpha, 0.0f), 1.0f)];
    return self;
}

- (NSString *)hexString {
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    return hexString;
}
@end
