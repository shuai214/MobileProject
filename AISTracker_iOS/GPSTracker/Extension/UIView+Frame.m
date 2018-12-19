//
//  UIView+Frame.m
//  GPSTracker
//
//  Created by Weifeng on 11/15/16.
//  Copyright © 2016 Capelabs. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
/**
 *  设置x坐标
 */
- (void)setX:(CGFloat)x {
    
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
/**
 *  获取x坐标
 */
- (CGFloat)x {
    
    return self.frame.origin.x;
}
/**
 *  设置y坐标
 */
- (void)setY:(CGFloat)y {
    
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
/**
 *  获取y坐标
 */
- (CGFloat)y {
    
    return self.frame.origin.y;
}
/**
 *  设置width
 */
-(void)setWidth:(CGFloat)width {
    
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
/**
 *  获取width
 */
- (CGFloat)width {
    
    return self.frame.size.width;
}
/**
 *  设置height
 */
- (void)setHeight:(CGFloat)height {
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
/**
 *  获取height
 */
- (CGFloat)height {
    
    return self.frame.size.height;
}
/**
 *  设置size
 */
- (void)setSize:(CGSize)size {
    
    [self setWidth:size.width];
    [self setHeight:size.height];
}
/**
 *  获取size
 */
- (CGSize)size {
    
    return self.frame.size;
}
/**
 *  设置origin
 */
- (void)setOrigin:(CGPoint)origin {
    
    [self setX:origin.x];
    [self setY:origin.y];
}
/**
 *  获取origin
 */
- (CGPoint)origin {
    
    return self.frame.origin;
}
@end
