//
//  MainViewController.m
//  LogisticsApp
//
//  Created by capaipai@sina.com on 2019/4/28.
//  Copyright © 2019年 capaipai. All rights reserved.
//

#import "MainViewController.h"
#import <SDCycleScrollView.h>
#import "CustomView.h"
@interface MainViewController ()<SDCycleScrollViewDelegate>
/* 轮播图 */
@property (strong , nonatomic)SDCycleScrollView *cycleScrollView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.navigationItem.title = @"首页";
    UIImage *image = [UIImage imageNamed:@"banner01"];

    UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0, TopHeight, Main_Screen_Width, Main_Screen_Width * image.size.height / image.size.width)];

    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, Main_Screen_Width, views.wtj_height) delegate:self placeholderImage:image];
    _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _cycleScrollView.autoScrollTimeInterval = 5.0;
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    NSArray *array = @[@"banner01.jpg",@"banner02.jpg",@"banner03"];
    _cycleScrollView.localizationImageNamesGroup = array;
    [views addSubview:_cycleScrollView];
    [self.view addSubview:views];
    
    CustomView *view1 = [[CustomView alloc] initWithFrame:CGRectMake(10, views.wtj_bottom + 10, (Main_Screen_Width - 30) / 2, (Main_Screen_Height - views.wtj_bottom - 30 - TabBarHeight) / 2)];
    [view1 fillContentView:@"send" title:@"发货" content:@"运输状态，尽在掌握"];
    [self.view addSubview:view1];
    
    CustomView *view2 = [[CustomView alloc] initWithFrame:CGRectMake(view1.wtj_right + 10, views.wtj_bottom + 10, (Main_Screen_Width - 30) / 2, (Main_Screen_Height - views.wtj_bottom - 30 - TabBarHeight) / 2)];
    [view2 fillContentView:@"address" title:@"我的地址" content:@"我的私人地址库"];
    [self.view addSubview:view2];
    
    CustomView *view3 = [[CustomView alloc] initWithFrame:CGRectMake(10, view1.wtj_bottom + 10, (Main_Screen_Width - 30) / 2, (Main_Screen_Height - views.wtj_bottom - 30 - TabBarHeight) / 2)];
    [view3 fillContentView:@"addressSend" title:@"地址上报" content:@"共建物流人自己的地图"];
    [self.view addSubview:view3];
    
    CustomView *view4 = [[CustomView alloc] initWithFrame:CGRectMake(view3.wtj_right + 10, view2.wtj_bottom + 10, (Main_Screen_Width - 30) / 2, (Main_Screen_Height - views.wtj_bottom - 30 - TabBarHeight) / 2)];
    [view4 fillContentView:@"user" title:@"一键客服" content:@"24小时为您服务"];
    [self.view addSubview:view4];
}
#pragma mark - 点击图片Bannar跳转
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
}


@end
