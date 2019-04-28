//
//  CSSetingViewController.m
//  ChinaScpet
//
//  Created by 曹帅 on 2018/5/22.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "CSSetingViewController.h"
//#import "CSCustomAlertView.h"
//#import "CSChangePwdViewController.h"
//#import "CSLoginViewController.h"
//#import "BaseNavigationController.h"
@interface CSSetingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    float _cacheSize;
}
/* tableview*/
@property(strong , nonatomic)UITableView *setTableView;
@end

@implementation CSSetingViewController

- (UITableView *)setTableView
{
    if (!_setTableView) {
        _setTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _setTableView.dataSource = self;
        _setTableView.delegate = self;
        _setTableView.showsVerticalScrollIndicator = NO;
        _setTableView.frame = CGRectMake(0,TopHeight,Main_Screen_Width,Main_Screen_Height - TopHeight -BottomHeight);
        _setTableView.backgroundColor = HEXCOLOR(@"#F0EFF5");
        [self.view addSubview:_setTableView];
        UIView *footView = [UIView new];
        footView.backgroundColor = HEXCOLOR(@"#F0EFF5");
        _setTableView.tableFooterView = footView;
    }
    return _setTableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:HEXCOLOR(@"#F0EFF5")];
    self.title = @"设置";
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    UIImage *bgimage = [UIImage imageWithColor: RGBA(250,250,250, 1)];
//    [self.navigationController.navigationBar setBackgroundImage:bgimage forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:self.setTableView];
    [self countCacheSize];
}
- (void)countCacheSize
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/default"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //取得一个文件夹下的所有文件的路径
    NSArray *subPath = [fileManager subpathsOfDirectoryAtPath:filePath error:nil];
    //计算本地缓存图片的大小
    long long sum = 0;
    for (NSString *bianli in subPath) {
        NSString *path = [filePath stringByAppendingPathComponent:bianli];
        NSDictionary *dic = [fileManager attributesOfItemAtPath:path error:nil];
        NSNumber *filesize = dic[NSFileSize];
        long long size = [filesize longLongValue];
        sum += size;
    }
    _cacheSize = sum/(1024.0*1024);     //从 Byte 到  M
    if (_cacheSize > 4) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *CachesDirectory = [paths objectAtIndex:0];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *buncachesHopmet = [CachesDirectory stringByAppendingPathComponent:@"com.capaipai.ChinaScpet"];
        BOOL bRet = [fileMgr fileExistsAtPath:buncachesHopmet];
        if (bRet) {
            NSError *err;
            [fileMgr removeItemAtPath:buncachesHopmet error:&err];
        }
    }
}
#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 ) {
        return 3;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cusCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cusCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cusCell.textLabel.text = @"清除缓存";
            cusCell.textLabel.font = FontSize_R(14);
            cusCell.detailTextLabel.text = [NSString stringWithFormat:@"%.1fM",_cacheSize];
            cusCell.detailTextLabel.font = FontSize_L(14);

        }
        if(indexPath.row == 1){
            cusCell.textLabel.text = @"修改密码";
            cusCell.textLabel.font = FontSize_R(14);
            cusCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 2) {
            cusCell.textLabel.text = @"关于";
            cusCell.textLabel.font = FontSize_R(14);
            cusCell.detailTextLabel.text = appMPVersion;
            cusCell.detailTextLabel.font = FontSize_R(14);
            cusCell.detailTextLabel.textColor = [UIColor redColor];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, AdaptedWidth(50))];
//            if (kDictIsEmpty([PlistFile readDataFromPlist:@"login.plist"])) {
//                label.text = @"登   录";
//            }else{
                label.text = @"安全退出";
//            }
            label.textAlignment = NSTextAlignmentCenter;
            label.font = FontSize_M(16);
            label.textColor = RGB(51, 51, 51);
            [cusCell addSubview:label];
        }
    }
    return cusCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //清除缓存  小提示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"清除缓存" message:@"确定清除?" delegate:self cancelButtonTitle:@"不要" otherButtonTitles:@"是的", nil];
            [alert show];
        }
        if (indexPath.row == 1) {
            if (kStringIsEmpty([CSSessionManager getsSession])) {
                [LoadingView showAlertHUD:@"您还未登录！" duration:0.37];
                return;
            }
            NSDictionary *params = @{
                                     @"modify":@"modify"
                                     };
            RouterOptions *options = [RouterOptions optionsWithDefaultParams:params];
            [JKRouter open:@"CSModifyPwdViewController" options:options];
        }
    }
    if(indexPath.section == 1){
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
        if (kStringIsEmpty([CSSessionManager getsSession] )) return;
        [mDic setObject:[CSSessionManager getsSession] forKey:@"sessionId"];
        NSString *md5String = [ValidationSignature returnMd5EncryptString:mDic];
        [mDic setObject:md5String forKey:@"signature"];
//        [self loadNetWork:LOGOUT_URL withParameters:mDic success:^(id jsonDic, NSString *msg) {
//            NSLog(@"%@",jsonDic);
//            if ([msg isEqualToString:@"成功"]) {
//                [CSSessionManager cleanSession];
//                [CSAccountTool removeUserPwd];
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//        } failure:^(NSError *error) {
//
//        }];
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptedWidth(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0||section == 1) {
        return 10;
    }
    return 0;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
//        //清除缓存    Go!!!
        [[SDImageCache sharedImageCache] clearMemory];
//
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//        NSString *CachesDirectory = [paths objectAtIndex:0];
//        NSFileManager *fileMgr = [NSFileManager defaultManager];
//        NSString *cachesHopmet = [CachesDirectory stringByAppendingPathComponent:@"cachesHopmet"];
//        NSString *buncachesHopmet = [CachesDirectory stringByAppendingPathComponent:@"SDDataCache"];
//
//        BOOL bRet = [fileMgr fileExistsAtPath:cachesHopmet];
//        if (bRet) {
//            NSError *err;
//            [fileMgr removeItemAtPath:cachesHopmet error:&err];
//            [fileMgr removeItemAtPath:buncachesHopmet error:&err];
//        }
        [self.setTableView reloadData];
    }
}
@end
