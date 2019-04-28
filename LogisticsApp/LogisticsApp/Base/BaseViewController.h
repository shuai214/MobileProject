//
//  BaseViewController.h
//  ChinaScpetDistributor
//
//  Created by 曹帅 on 2018/9/3.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSEmptyView.h"
typedef void (^SuccessCallBackBlcok)  (id jsonDic,NSString *msg);

@protocol  BBBaseViewControllerDataSource<NSObject>

@optional
-(BOOL)hideNavigationBottomLine;
@end
@interface BaseViewController : UIViewController<BBBaseViewControllerDataSource>
@property (strong , nonatomic)NSMutableArray *dataArray;
//- (void)loadNetWork:(NSString *)url withParameters:(NSMutableDictionary *)parmas success:(SuccessCallBackBlcok)success failure:(FailureCallBack)failure;
@property(nonatomic,strong)CSEmptyView *emptyView;

- (void)loadEmptyView;

@end
