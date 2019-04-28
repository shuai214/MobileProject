//
//  UIView+Extension.m
//  ChinaScpet
//
//  Created by 曹帅 on 2018/5/15.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import <Masonry.h>
#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)addLineDirection:(LineDirection)direction BackgroundColor:(UIColor *)color HeightOrWidth:(NSInteger)heightOrwidth{
    
    if (direction & LineDirectionTop) {
        UIImageView *line = [UIImageView new];
        line.backgroundColor = color;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self);
            make.height.equalTo(@(heightOrwidth));
        }];
    }
    
    if (direction & LineDirectionBottom) {
        UIImageView *line = [UIImageView new];
        line.backgroundColor = color;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.equalTo(@(heightOrwidth));
        }];
    }
    
    if (direction & LineDirectionLeft) {
        UIImageView *line = [UIImageView new];
        line.backgroundColor = color;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(heightOrwidth));
            make.left.equalTo(self);
            make.top.bottom.equalTo(self);
        }];
    }
    
    if (direction & LineDirectionRight) {
        UIImageView *line = [UIImageView new];
        line.backgroundColor = color;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(heightOrwidth));
            make.right.equalTo(self);
            make.top.bottom.equalTo(self);
        }];
    }
}

@end
