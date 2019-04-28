//
//  CS- (void)loadEmptyView{      } CS- (void)loadEmptyView{      } CSEmptyView.m
//  ChinaScpet
//
//  Created by 曹帅 on 2018/7/2.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "CSEmptyView.h"

@implementation CSEmptyView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)loadEmptyView{
    UIImage *img = GetImage(@"Empty");
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.wtj_width - img.size.width) / 2, self.wtj_centerY - 100, img.size.width, img.size.height)];
    [imgView setImage:img];
    [self addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.wtj_bottom + 5, Main_Screen_Width, 20)];
    label.text = @"暂无内容…";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = FontSize_L(14);
    label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    [self addSubview:label];
}


@end
