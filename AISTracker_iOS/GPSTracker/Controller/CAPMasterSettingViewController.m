//
//  CAPMasterSettingViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPMasterSettingViewController.h"
#import "CAPBatteryView.h"
#import "CAPEditNameViewController.h"
#import "CAPGuardianListViewController.h"
#import "CAPDeviceService.h"
#import "CAPGuardianListViewController.h"
#import "CAPSOSMobileViewController.h"
#import "CAPUploadFrequencyViewController.h"
@interface CAPMasterSettingViewController () <UITableViewDataSource, UITableViewDelegate,YWAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet CAPBatteryView *batteryView;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<NSString *> *titles;
@property (strong, nonatomic) NSArray<NSString *> *details;
@property (nonatomic,strong) id <YWAlertViewProtocol>ywAlert;

@end

@implementation CAPMasterSettingViewController
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备详情";
    self.titles = @[@"名称", @"Device ID", @"Device IMEI",
                    @"Device Number", @"监护人",@"SOS号码",@"更新频率",@"解绑",@"固件版本"];
    self.details = @[self.device? self.device.name:@"", self.device?self.device.deviceID:@"", @"XXXX", self.device?self.device.deviceID:@"", @"",@"",[CAPUserDefaults objectForKey:@"uploadTime"] ? [CAPUserDefaults objectForKey:@"uploadTime"] : @"",@"",@""];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIImage *avatar = GetImage(@"ic_default_avatar");
    
    [self.avatarImageView setImage:[self OriginImage:avatar scaleToSize:CGSizeMake(self.avatarImageView.frame.size.width, self.avatarImageView.frame.size.width)]];
    self.deviceLabel.text = [@"Device ID: " stringByAppendingString:self.device ? self.device.deviceID:@""];
}
//- (void)loadDeviceInfo{
//    [gApp showHUD:@"正在处理，请稍后..."];
//
//    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
//    [deviceService getDevice:self.device reply:^(id response) {
//
//    }];
//    //    [deviceService getDeviceBindinfo:self.device reply:^(CAPHttpResponse *response) {
//    //        self.deviceBindInfo = [CAPDeviceBindInfo mj_objectWithKeyValues:response.data];
//    //        if (self.deviceBindInfo.code == 200) {
//    //            self.details = @[self.deviceBindInfo.result.bindinfo.name? self.deviceBindInfo.result.bindinfo.name:@"", self.deviceBindInfo.result.deviceID?self.deviceBindInfo.result.deviceID:@"", @"XXXX", self.deviceBindInfo.result.mobile?self.deviceBindInfo.result.mobile:@"", @"",@"",@"",@"",@""];
//    //            [self.tableView reloadData];
//    //            [gApp hideHUD];
//    //        }
//    //    }];
//}

- (void)refreshLocalizedString {
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    [deviceService fetchDevice:self.device.deviceID reply:^(CAPHttpResponse *response) {
         CAPDevice *getDevice = [CAPDevice mj_objectWithKeyValues:[response.data objectForKey:@"result"]];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const cellIdentifier = @"right_detail_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.titles[indexPath.row];
    cell.detailTextLabel.text = self.details[indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
        case 0:
//            [self performSegueWithIdentifier:@"edit.name.segue" sender:nil];
        {UIStoryboard *story = [UIStoryboard storyboardWithName:@"EditName" bundle:nil];
            CAPEditNameViewController *EditNameVC = [story instantiateViewControllerWithIdentifier:@"EditNameViewController"];
        [self.navigationController pushViewController:EditNameVC animated:YES];
        }
            break;
        case 1:
//            [self performSegueWithIdentifier:@"guardian.list.segue" sender:nil];GuardianListViewController
//        {UIStoryboard *story = [UIStoryboard storyboardWithName:@"MasterSetting" bundle:nil];
//            CAPGuardianListViewController *GuardianVC = [story instantiateViewControllerWithIdentifier:@"GuardianListViewController"];
//            [self.navigationController pushViewController:GuardianVC animated:YES];
//        }
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
        {UIStoryboard *story = [UIStoryboard storyboardWithName:@"MasterSetting" bundle:nil];
            CAPGuardianListViewController *GuardianVC = [story instantiateViewControllerWithIdentifier:@"GuardianListViewController"];
            GuardianVC.device = self.device;
            [self.navigationController pushViewController:GuardianVC animated:YES];
        }
            break;
        case 5:
        {
            CAPSOSMobileViewController *sosVC = [[CAPSOSMobileViewController alloc] init];
            [self.navigationController pushViewController:sosVC animated:YES];
        }
            break;
        case 6:
        {
            CAPUploadFrequencyViewController *uploadVC = [[CAPUploadFrequencyViewController alloc] init];
            uploadVC.device = self.device;
            [self.navigationController pushViewController:uploadVC animated:YES];
        }
            break;
        case 7:
        {
            id <YWAlertViewProtocol>alert = [YWAlertView alertViewWithTitle:nil message:[NSString stringWithFormat:@"确定要解绑这台设备吗？"] delegate:self preferredStyle:YWAlertViewStyleAlert footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:@"cancel" otherButtonTitles:@[@"Ok"]];
            [alert setButtionTitleFontWithName:@"AmericanTypewriter" size:16 index:1];
            [alert setButtionTitleFontWithName:@"AmericanTypewriter-Bold" size:16 index:0];
            [alert show];
        }
            break;
        default:
            break;
    }
}
- (id<YWAlertViewProtocol>)ywAlert{
    if (!_ywAlert) {
        _ywAlert = [YWAlertView alertViewWithTitle:nil message:@"" delegate:self preferredStyle:YWAlertViewStyleAlert footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:@"cancel" otherButtonTitles:@[@"Ok"]];
    }
    return _ywAlert;
}
- (void)didClickAlertView:(NSInteger)buttonIndex value:(id)value{
    if (buttonIndex) {
        [gApp showHUD:@"正在处理，请稍后..."];
        CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
        [deviceService deleteDevice:self.device reply:^(CAPHttpResponse *response) {
            NSDictionary *data = response.data;
            if ([[data objectForKey:@"code"] integerValue] == 200) {
                [gApp hideHUD];
                [CAPNotifications notify:kNotificationDeviceCountChange object:nil];
                [CAPUserDefaults removeObjectForKey:@"userSetting"];//setObject:@"YES" forKey:@"userSetting"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [gApp showHUD:[data objectForKey:@"message"] cancelTitle:@"确定" onCancelled:^{
                    
                }];
            }
            
        }];
    }
    
}
@end

