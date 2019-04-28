//
//  BaseViewController.m
//  ChinaScpetDistributor
//
//  Created by 曹帅 on 2018/9/3.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "BaseViewController.h"
#import "UIImage+Color.h"
@interface BaseViewController ()

@end

@implementation BaseViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIImageView* blackLineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    //默认显示黑线
    blackLineImageView.hidden = YES;
    if ([self respondsToSelector:@selector(hideNavigationBottomLine)]) {
        if ([self hideNavigationBottomLine]) {
            //隐藏黑线
            blackLineImageView.hidden = YES;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)loadEmptyView{
    self.emptyView = [[CSEmptyView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height - TabBarHeight)];
    [self.emptyView loadEmptyView];
    [self.view addSubview:self.emptyView];
}
#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:nil];
    self.view.backgroundColor = HEXCOLOR(@"#F0EFF5");
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIImage *bgimage = [UIImage imageWithColor: RGBA(250,250,250, 1)];
    [self.navigationController.navigationBar setBackgroundImage:bgimage forBarMetrics:UIBarMetricsDefault];
    
//
//    [self changeLineOfTabbarColor]; //修改tabBar顶部横线颜色
//    [self changeTabbarColor]; //修改tabBar背景色
    
    //去除tabBar顶部横线的方法
    self.tabBarController.tabBar.clipsToBounds = YES;
//    for(NSString *fontfamilyname in [UIFont familyNames])
//    {
//        NSLog(@"family:'%@'",fontfamilyname);
//        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
//        {
//            NSLog(@"\tfont:'%@'",fontName);
//        }
//        NSLog(@"-------------");
//    }
//    
   
}
//file:///Users/caoshuai/Desktop/ChinaScpetDistributor/ChinaScpetDistributor/Base.lproj/LaunchScreen.storyboard: error: Illegal Configuration: Safe Area Layout Guide before iOS 9.0

//找查到Nav底部的黑线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

//- (void)loadNetWork:(NSString *)url withParameters:(NSMutableDictionary *)parmas success:(SuccessCallBackBlcok)success failure:(FailureCallBack)failure{
//    self.dataArray = [NSMutableArray array];
//    NSString *loginUrl = [NSString stringWithFormat:@"%@%@",URL,url];
////    dispatch_async(dispatch_queue_create(0, 0), ^{
//        [MyRequest POST:loginUrl withParameters:parmas CacheTime:10 isLoadingView:@"" success:^(id responseObject, BOOL succe, id jsonDic) {
//            if (jsonDic == nil) {
//                [self loadEmptyView];
//                return ;
//            }else{
//                if ([[jsonDic objectForKey:@"status"] isEqualToString:@"0000"]) {
//                    [self.emptyView removeFromSuperview];
//                    self.emptyView = nil;
//                }else if([[jsonDic objectForKey:@"status"] isEqualToString:@"1004"]){
//                    [self loadEmptyView];
//                    return ;
//                }else{
//                    [LoadingView showAlertHUD:[NSString stringWithFormat:@"%@",[jsonDic objectForKey:@"msg"]] duration:0.37];
//                }
//            }
//            if (![ValidationSignature validationSignature:jsonDic]) return;
//            NSData *jsonData = [jsonDic[@"data"] dataUsingEncoding:NSUTF8StringEncoding];
//            id data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//            success(data,jsonDic[@"msg"]);
//        } failure:^(NSError *error) {
//            failure(error);
//        }];
////    });
//}
- (void)changeLineOfTabbarColor {
    CGRect rect = CGRectMake(0.0f, 0.0f, Main_Screen_Width, 0.5);
    UIGraphicsBeginImageContextWithOptions(rect.size,NO, 0);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor RandomColor].CGColor);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBarController.tabBar setShadowImage:image];
    [self.tabBarController.tabBar setBackgroundImage:[UIImage new]];
}
#define DEVICE_IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
- (void)changeTabbarColor {
    CGRect frame;
    UIView *tabBarView = [[UIView alloc] init];
    tabBarView.backgroundColor = [UIColor RandomColor];
    if (DEVICE_IS_IPHONE_X) {
        frame = CGRectMake(0, 0, Main_Screen_Width, 83);
    }else {
        frame = self.tabBarController.tabBar.bounds;
    }
    tabBarView.frame = frame;
    [[UITabBar appearance] insertSubview:tabBarView atIndex:0];
}
@end
