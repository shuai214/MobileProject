//
//  UIView+Extension.h
//  ChinaScpet
//
//  Created by 曹帅 on 2018/5/15.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
// 定义边框方向枚举
typedef NS_ENUM(NSInteger,LineDirection){
    LineDirectionTop = 1 << 1,
    LineDirectionBottom = 1 << 2,
    LineDirectionLeft = 1 << 3,
    LineDirectionRight = 1 << 4
};

/*!
 *  为本view添加边线
 *
 *  @param direction     边线方向 中间加 | 同时添加多个边框
 *  @param color         边框的颜色
 *  @param heightOrwidth 变量的宽度或者高度
 */
- (void)addLineDirection:(LineDirection)direction BackgroundColor:(UIColor *)color HeightOrWidth:(NSInteger)heightOrwidth;

@end
