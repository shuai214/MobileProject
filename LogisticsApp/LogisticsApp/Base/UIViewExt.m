//  Created by 曹帅 on 2018/4/28.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "UIViewExt.h"

CGPoint CGRectGetCenter(CGRect rect)
{
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}

CGRect CGRectMoveToCenter(CGRect rect, CGPoint center)
{
    CGRect newrect = CGRectZero;
    newrect.origin.x = center.x-CGRectGetMidX(rect);
    newrect.origin.y = center.y-CGRectGetMidY(rect);
    newrect.size = rect.size;
    return newrect;
}

@implementation UIView (ViewGeometry)

// Retrieve and set the origin
- (CGPoint) wtj_origin
{
    return self.frame.origin;
}

- (void)setWtj_origin:(CGPoint)wtj_origin{
    CGRect newframe = self.frame;
    newframe.origin = wtj_origin;
    self.frame = newframe;
}

// Retrieve and set the size
- (CGSize) wtj_size
{
    return self.frame.size;
}

- (void) setWtj_size: (CGSize) aSize
{
    CGRect newframe = self.frame;
    newframe.size = aSize;
    self.frame = newframe;
}

// Query other frame locations
- (CGPoint) wtj_bottomRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) wtj_bottomLeft
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    return CGPointMake(x, y);
}

- (CGPoint) wtj_topRight
{
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    return CGPointMake(x, y);
}


// Retrieve and set height, width, top, bottom, left, right
- (CGFloat) wtj_height
{
    return self.frame.size.height;
}

- (void) setWtj_height: (CGFloat) wtj_height
{
    CGRect newframe = self.frame;
    newframe.size.height = wtj_height;
    self.frame = newframe;
}

- (CGFloat) wtj_width
{
    return self.frame.size.width;
}

- (void) setWtj_width: (CGFloat) wtj_width
{
    CGRect newframe = self.frame;
    newframe.size.width = wtj_width;
    self.frame = newframe;
}

- (CGFloat) wtj_top
{
    return self.frame.origin.y;
}

- (void) setWtj_top: (CGFloat) newtop
{
    CGRect newframe = self.frame;
    newframe.origin.y = newtop;
    self.frame = newframe;
}

- (CGFloat) wtj_left
{
    return self.frame.origin.x;
}

- (void) setWtj_left: (CGFloat) newleft
{
    CGRect newframe = self.frame;
    newframe.origin.x = newleft;
    self.frame = newframe;
}

- (CGFloat) wtj_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void) setWtj_bottom: (CGFloat) newbottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = newbottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat) wtj_right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void) setWtj_right: (CGFloat) newright
{
    CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}
-(CGFloat)wtj_centerX{
    
    return self.center.x;
}

-(void)setWtj_centerX:(CGFloat)wtj_centerX{
    
    CGPoint wtjFrmae = self.center;
    wtjFrmae.x = wtj_centerX;
    self.center = wtjFrmae;
}

-(CGFloat)wtj_centerY{
    
    return self.center.y;
}

-(void)setWtj_centerY:(CGFloat)wtj_centerY{
    
    CGPoint wtjFrmae = self.center;
    wtjFrmae.y = wtj_centerY;
    self.center = wtjFrmae;
}
// Move via offset
- (void) moveBy: (CGPoint) delta
{
    CGPoint newcenter = self.center;
    newcenter.x += delta.x;
    newcenter.y += delta.y;
    self.center = newcenter;
}

// Scaling
- (void) scaleBy: (CGFloat) scaleFactor
{
    CGRect newframe = self.frame;
    newframe.size.width *= scaleFactor;
    newframe.size.height *= scaleFactor;
    self.frame = newframe;
}

// Ensure that both dimensions fit within the given size by scaling down
- (void) fitInSize: (CGSize) aSize
{
    CGFloat scale;
    CGRect newframe = self.frame;
    
    if (newframe.size.height && (newframe.size.height > aSize.height))
    {
        scale = aSize.height / newframe.size.height;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    if (newframe.size.width && (newframe.size.width >= aSize.width))
    {
        scale = aSize.width / newframe.size.width;
        newframe.size.width *= scale;
        newframe.size.height *= scale;
    }
    
    self.frame = newframe;
}
@end
