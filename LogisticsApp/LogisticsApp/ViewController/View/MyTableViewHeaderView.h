//
//  MyHeaderView.h
//  ChinaScpetDistributor
//
//  Created by 曹帅 on 2018/9/12.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewHeaderView : UIView

@property (nonatomic,copy) void (^clickBlock)(void);

- (void)setUserTitle;

@end