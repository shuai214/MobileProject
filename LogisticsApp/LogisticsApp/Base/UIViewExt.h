//  Created by 曹帅 on 2018/4/28.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (ViewFrameGeometry)
@property CGPoint wtj_origin;
@property CGSize wtj_size;

@property (readonly) CGPoint wtj_bottomLeft;
@property (readonly) CGPoint wtj_bottomRight;
@property (readonly) CGPoint wtj_topRight;

@property CGFloat wtj_height;
@property CGFloat wtj_width;

@property CGFloat wtj_top;
@property CGFloat wtj_left;

@property CGFloat wtj_bottom;
@property CGFloat wtj_right;

@property CGFloat wtj_centerX;
@property CGFloat wtj_centerY;

- (void) moveBy: (CGPoint) delta;
- (void) scaleBy: (CGFloat) scaleFactor;
- (void) fitInSize: (CGSize) aSize;
@end
