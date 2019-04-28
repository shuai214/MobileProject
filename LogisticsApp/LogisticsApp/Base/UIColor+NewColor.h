//
//  UIColor+NewColor.h
//  lesigouProject
//
//  Created by 曹帅 on 15-7-9.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (NewColor)

+ (UIColor*)colorWithHexString:(NSString*)hex;



+ (UIColor*)colorWithHexString:(NSString*)hex withAlpha:(CGFloat)alpha;

@end
