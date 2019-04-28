//
//  MeViewController.m
//  LogisticsApp
//
//  Created by capaipai@sina.com on 2019/4/28.
//  Copyright © 2019年 capaipai. All rights reserved.
//

#import "MeViewController.h"
#import "MyTableViewHeaderView.h"
#import "CSLoginViewController.h"
#import "CSSetingViewController.h"
@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIButton *rigthCarButton;
/* tableview*/
@property(strong , nonatomic)UITableView *myTableView;
/* tableview headerView*/
@property(strong , nonatomic)MyTableViewHeaderView *headerView;
@end

@implementation MeViewController
#pragma mark - LazyLoad
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.frame =  CGRectMake(0,-Application_StatusBar_Height, Main_Screen_Width, Main_Screen_Height - TabBarHeight);
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}
- (MyTableViewHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[MyTableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, AdaptedWidth(200) + Application_StatusBar_Height)];
        MPWeakSelf(self);
        _headerView.clickBlock = ^{
            [weakself.navigationController pushViewController:[CSLoginViewController new] animated:YES];
        };
    }
    return _headerView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置一张空的图片
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
//    //清除边框，设置一张空的图片
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    [self.headerView setUserTitle];
    self.navigationController.navigationBarHidden = YES;

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor RandomColor];
    
    
    self.rigthCarButton = [self creatButton:CGRectMake(0, 0, 60, 44)];
    //    [self.rigthCarButton addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:self.rigthCarButton];
    //    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    self.myTableView.backgroundColor = self.view.backgroundColor = HEXCOLOR(@"#F0EFF5");
    self.myTableView.tableHeaderView = self.headerView;
    
}
#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 1;
    }
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cusCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cusCell.selectionStyle = UITableViewCellSelectionStyleNone;
    cusCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cusCell.textLabel.text = @"公司信息";
            cusCell.textLabel.font = FontSize_R(14);
            cusCell.textLabel.textColor = HEXCOLOR(@"#333333");
            [cusCell.imageView setImage:GetImage(@"company_msg")];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cusCell.textLabel.text = @"我的供货商";
            cusCell.textLabel.font = FontSize_R(14);
            cusCell.textLabel.textColor = HEXCOLOR(@"#333333");
            [cusCell.imageView setImage:GetImage(@"gonghuoshang")];
            
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cusCell.textLabel.text = @"反馈与帮助";
            cusCell.textLabel.font = FontSize_R(14);
            cusCell.textLabel.textColor = HEXCOLOR(@"#333333");
            [cusCell.imageView setImage:GetImage(@"help")];
            cusCell.detailTextLabel.text = kTel_num;
            cusCell.detailTextLabel.font = FontSize_R(14);
            cusCell.detailTextLabel.textColor = HEXCOLOR(@"#030303");
        }
        if (indexPath.row == 1) {
            cusCell.textLabel.text = @"设置";
            cusCell.textLabel.font = FontSize_R(14);
            cusCell.textLabel.textColor = HEXCOLOR(@"#333333");
            [cusCell.imageView setImage:GetImage(@"seting")];
        }
    }
    return cusCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([CSSessionManager getsSession].length <= 0) {
            [LoadingView showAlertHUD:@"您还未登录！" duration:0.37];
            return;
        }
        NSDictionary *params = @{
                                 @"uid":[SharedLogin shareInstance].uid,
                                 @"titleName":@"公司信息",
                                 @"loadUrl":User_Info
                                 };
        RouterOptions *options = [RouterOptions optionsWithDefaultParams:params];
        [JKRouter open:@"CSCompanyInfoViewController" options:options];
    }
    if (indexPath.section == 1) {
        if ([CSSessionManager getsSession].length <= 0) {
            [LoadingView showAlertHUD:@"您还未登录！" duration:0.37];
            return;
        }
        [JKRouter open:@"CSSupplierListViewController" options:nil];
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [CSActionSheet showWithTitle:nil destructiveTitle:nil otherTitles:@[kTel_num,@"呼叫"] block:^(int index) {
                if (index == 1 || index == 0) {
                    NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@",kTel_num];
                    if (FSystemVersion >= 10.0) {
                        /// 大于等于10.0系统使用此openURL方法
                        if (@available(iOS 10.0, *)) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:^(BOOL success) {
                            }];
                        } else {
                            // Fallback on earlier versions
                        }
                    } else {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
                    }
                }
            }];
        }
        if (indexPath.row == 1) {
            [self.navigationController pushViewController:[CSSetingViewController new] animated:YES];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptedWidth(50);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (UIButton *)creatButton:(CGRect)frame{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    /* 获取按钮文字的宽度 获取按钮图片和文字的间距 获取图片宽度 */
    CGFloat    space = 5;// 图片和文字的间距
    NSString    * titleString = [NSString stringWithFormat:@"购物车"];
    CGFloat    titleWidth = [titleString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
    UIImage    * btnImage = GetImage(@"back");// 11*6
    CGFloat    imageWidth = btnImage.size.width;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:titleString forState:UIControlStateNormal];
    [button setImage:btnImage forState:UIControlStateNormal];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -(imageWidth+space*0.5), 0, (imageWidth+space*0.5))];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, (titleWidth + space*0.5), 0, -(titleWidth + space*0.5))];
    return button;
}

@end

