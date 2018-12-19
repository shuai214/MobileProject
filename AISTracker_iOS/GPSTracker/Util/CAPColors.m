//
//  CAPColors.m
//  Neptu
//
//  Created by WeifengYao on 26/2/2018.
//  Copyright © 2018 capelabs. All rights reserved.
//

#import "CAPColors.h"
#import "UIColor+CAP.h"

@implementation CAPColors
#pragma mark - Style Guide Colors
+ (UIColor *)white {
    return [UIColor colorFromHex:0xFFFFFF];
}

+ (UIColor *)black {
    return [UIColor colorFromHex:0x000000];
}

+ (UIColor *)red {
    return [UIColor colorFromHex:0xFF0000];
}

//+ (UIColor *)white70 {
//    return [self whiteWithAlpha:.73];
//}
//
//+ (UIColor *)white93 {
//    return [self whiteWithAlpha:.93];
//}
//
//+ (UIColor *)whiteWithAlpha:(CGFloat)alpha {
//    return [UIColor colorFromHex:0xededed alpha:alpha];
//}
//
//+ (UIColor *)gray {
//    return [UIColor colorFromHex:0xACACAC];
//}
//
//+ (UIColor *)lightGray {
//    return [UIColor colorFromHex:0xC6CBD0];
//}
//
//+ (UIColor *)darkGray {
//    return [UIColor colorFromHex:0x6A6A6A];
//}
//
//+ (UIColor *)slate1 {
//    return [UIColor colorFromHex:0x181e23];
//}
//
//+ (UIColor *)slate2 {
//    return [UIColor colorFromHex:0x232B31];
//}
//
//+ (UIColor *)slate3 {
//    return [UIColor colorFromHex:0x364349];
//}
//
//+ (UIColor *)slate4 {
//    return [UIColor colorFromHex:0x47565D];
//}
//
//+ (UIColor *)slate5 {
//    return [UIColor colorFromHex:0x364349];
//}
//
//+ (UIColor *)orange1 {
//    return [UIColor colorFromHex:0xf06147];
//}
//
//+ (UIColor *)orange2 {
//    return [UIColor colorFromHex:0xd8573e];
//}
//
//+ (UIColor *)teal {
//    return [UIColor colorFromHex:0x00A2AE];
//}
//
//+ (UIColor *)alertOrange {
//    return [UIColor colorFromHex:0xF18900];
//}
//
//+ (UIColor *)alertYellow {
//    return [UIColor colorFromHex:0xCFB400];
//}
//
//+ (UIColor *)alertYellow1 {
//    return [UIColor colorFromHex:0xFCBB13];
//}
//
//+ (UIColor *)alertRed {
//    return [UIColor colorFromHex:0xB02222];
//}
//
//+ (UIColor *)alertGreen {
//    return [UIColor colorFromHex:0x62c885];
//}
//
+ (UIColor *)green1 {
    return [UIColor colorFromHex:0x79E5B1];
}
+ (UIColor *)green2 {
    return [UIColor colorFromHex:0x50D686]; //80, 214, 134
}
+ (UIColor *)green3 {
    return [UIColor colorFromHex:0x52D763];
}
+ (UIColor *)green4 {
    return [UIColor colorFromHex:0x99FFC2];
}
+ (UIColor *)green5 {
    return [UIColor colorFromHex:0x75A336];
}

//+ (UIColor *)alertBlue {
//    return [UIColor colorFromHex:0x0076FF];
//}

+ (UIColor *)blue1 {
    return [UIColor colorFromHex:0x1371D0]; //(19, 113, 208)
}

+ (UIColor *)blue2 {
    return [UIColor colorFromHex:0x4DA2F0]; //(77, 162, 240)
}

+ (UIColor *)blue3 {
    return [UIColor colorFromHex:0x0078E6]; //(0, 120, 230)
}

+ (UIColor *)blue4 {
    return [UIColor colorFromHex:0x1C72CE]; //(28,114,206)
}

+ (UIColor *)blue5 {
    return [UIColor colorFromHex:0x157EFB]; //(21, 126, 251)
}

+ (UIColor *)blue6 {
    return [UIColor colorFromHex:0x419FCA]; //(65, 159, 202)
}

+ (UIColor *)blue7 {
    return [UIColor colorFromHex:0x1379DC]; //(19, 121, 220)
}

+ (UIColor *)gray1 {
    return [UIColor colorFromHex:0xEBEBEB]; //(235, 235, 235)
}

+ (UIColor *)gray2 {
    return [UIColor colorFromHex:0x6A6A6A]; //(106, 106, 106)
}

+ (UIColor *)gray3 {
    return [UIColor colorFromHex:0xE6E6E6]; //(230, 230, 30)
}

+ (UIColor *)red1 {
    return [UIColor colorFromHex:0xC1272D]; //(193,39,45)
}

+ (UIColor *)white1 {
    return [UIColor colorFromHex:0xFFFFFF alpha:0.4]; //(255, 255, 255)
}

+ (UIColor *)white2 {
    return [UIColor colorFromHex:0xFFFFFF alpha:0.5]; //(255, 255, 255)
}

+ (UIColor *)white3 {
    return [UIColor colorFromHex:0xFFFFFF alpha:0.8]; //(255, 255, 255)
}

+ (UIColor *)white4 {
    return [UIColor colorFromHex:0xFFFFFF alpha:0.6]; //(255, 255, 255)
}

+ (UIColor *)black1 {
    return [UIColor colorFromHex:0x000058 alpha:0.1];
}

+ (UIColor *)yellow1 {
    return [UIColor colorFromHex:0xFFD110]; //(255,209,16)
}

+ (UIColor *)yellow2 {
    return [UIColor colorFromHex:0xFDF8E2]; //(253,248,226)
}
//+ (UIColor *)gray1 {
//    return [UIColor colorFromHex:0xA1A7AB];
//}
//
//+ (UIColor *)gray2 {
//    return [UIColor colorFromHex:0xBDBAC7];
//}
//
//+ (UIColor *)gray3 {
//    return [UIColor colorFromHex:0xD4D9DE];
//}
//
//+ (UIColor *)gray4 {
//    return [UIColor colorFromHex:0xE0E0E0];
//}
//
//+ (UIColor *)gray5 {
//    return [UIColor colorFromHex:0xEAEAEA];
//}
//
//+ (UIColor *)gray6 {
//    return [UIColor colorFromHex:0xF3F3F3];
//}
//
//+ (UIColor *)gray7 {
//    return [UIColor colorFromHex:0x9B9B9B];
//}
//
//+(UIColor *)gray8 {
//    return [UIColor colorFromHex:0xebeaea];
//}
//
//+(UIColor *)gray9 {
//    return [UIColor colorFromHex:0x959595];
//}
//
//#pragma mark - Miscellaneous
//+ (UIColor *)navigationControlDarkBackground {
//    return [self slate1];
//}
//
//+ (UIColor *)dropDownCellDarkBackground {
//    return [UIColor colorFromHex:0xF3F3F3];
//}
//
//+ (UIColor *)dropDownCellLightBackground {
//    return [UIColor colorFromHex:0xEAEAEA];
//}
//
//+ (UIColor *)dropDownCellSelectedBackground {
//    return [UIColor colorFromHex:0x232B31];
//}
//
//+ (UIColor *)chevronDropDownColor {
//    return [UIColor colorFromHex:0x1F2C33];
//}
//
//+ (UIColor *)fordDarkBackgroundDimmer {
//    return [UIColor colorFromHex:0x000000 alpha:0.5];
//}
//
//+ (UIColor *)loginGradientCenterColor {
//    return [UIColor colorFromHex:0xF2F2F2];
//}
//
//+ (UIColor *)loginGradientEdgeColor {
//    return [UIColor colorFromHex:0xE7E8E8];
//}
//
//+ (UIColor *)defaultLineSeperatorColor {
//    return [self gray4];
//}
//
//+ (UIColor *)darkLineSeparatorColor {
//    return [UIColor colorFromHex:0xC8CBCD];
//}
//
//#pragma mark - Color Utilities
//+ (CAGradientLayer *)verticalLinearGradiantForStartColor:(UIColor *)startColor
//                                                endColor:(UIColor *)endColor {
//    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
//    gradientLayer.backgroundColor = [UIColor clearColor].CGColor;
//    gradientLayer.colors = @[(id)startColor.CGColor,
//                             (id)endColor.CGColor];
//    
//    return gradientLayer;
//}
//
//+ (CAGradientLayer *)verticalLinearGradientForColor:(UIColor *)color
//                                fadeOutEdgesToColor:(UIColor *)fadeOutColor {
//    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
//    gradientLayer.backgroundColor = [UIColor clearColor].CGColor;
//    
//    gradientLayer.colors = @[(id)fadeOutColor.CGColor,
//                             (id)color.CGColor,
//                             (id)fadeOutColor.CGColor];
//    
//    return gradientLayer;
//}
//
////+ (CAGradientLayer *)radialGradientWithCenterColor:(UIColor *)centerColor
////                                         edgeColor:(UIColor *)edgeColor {
////    RadialGradientLayer *gradientLayer = [[RadialGradientLayer alloc] initWithCenterColor:centerColor
////                                                                                edgeColor:edgeColor];
////    return gradientLayer;
////}
//
//+ (UIColor *)gradientColorAtIndex:(NSUInteger)index
//                         forCount:(NSUInteger)count
//                       startColor:(UIColor*)startColor
//                         endColor:(UIColor*)endColor {
//    
//    CGFloat percent = ((CGFloat)index)/count;
//    
//    const CGFloat *startColorComponents = CGColorGetComponents(startColor.CGColor);
//    const CGFloat *endColorComponents = CGColorGetComponents(endColor.CGColor);
//    
//    CGFloat resultRed = startColorComponents[0] + percent * (endColorComponents[0] - startColorComponents[0]);
//    CGFloat resultGreen = startColorComponents[1] + percent * (endColorComponents[1] - startColorComponents[1]);
//    CGFloat resultBlue = startColorComponents[2] + percent * (endColorComponents[2] - startColorComponents[2]);
//    
//    return [UIColor colorWithRed:resultRed green:resultGreen blue:resultBlue alpha:1];
//}
@end
