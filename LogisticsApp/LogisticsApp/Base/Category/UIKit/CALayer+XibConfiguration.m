//
//  CALayer+XibConfiguration.m
//  ChinaScpet
//
//  Created by 曹帅 on 2018/6/8.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "CALayer+XibConfiguration.h"

@implementation CALayer (XibConfiguration)
-(void)setBorderUIColor:(UIColor*)color

{
    
    self.borderColor = color.CGColor;
    
}

-(UIColor*)borderUIColor

{
    
    return [UIColor colorWithCGColor:self.borderColor];
    
}

@end
