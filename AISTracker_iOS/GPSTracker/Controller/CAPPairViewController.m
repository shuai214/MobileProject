//
//  CAPPairViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPPairViewController.h"
#import "CAPTrackerViewController.h"
#import "CAPScanViewController.h"
#import "CAPAddTrackerViewController.h"
#import "CAPDevice.h"
#import "CAPDeviceService.h"
#import "MQTTCenter.h"
#import "CAPDeviceSettingViewController.h"
@interface CAPPairViewController ()<YWAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIButton *numberButton;
@property (nonatomic,strong) id <YWAlertViewProtocol>ywAlert;
@end

@implementation CAPPairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:NSLocalizedString(@"tether", nil)];
    [CAPNotifications addObserver:self selector:@selector(registBindUserDevice:) name:kNotificationBINDREPCountChange object:nil];
}

- (void)registBindUserDevice:(NSNotification *)notifi{
    [CAPAlertView initAlertWithContent:@"绑定成功！" title:@"" closeBlock:^{
        
    } okBlock:^{
        [CAPNotifications notify:kNotificationDeviceCountChange];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } alertType:AlertTypeNoClose];
}

- (id<YWAlertViewProtocol>)ywAlert{
    if (!_ywAlert) {
        _ywAlert = [YWAlertView alertViewWithTitle:nil message:@"" delegate:self preferredStyle:YWAlertViewStyleAlert footStyle:YWAlertPublicFootStyleDefalut bodyStyle:YWAlertPublicBodyStyleDefalut cancelButtonTitle:@"cancel" otherButtonTitles:@[@"Ok"]];
    }
    return _ywAlert;
}
- (void)didClickAlertView:(NSInteger)buttonIndex value:(id)value{
    NSLog(@"委托代理=当前点击--%zi",buttonIndex);
    
}
- (void)refreshLocalizedString {
    
}

- (IBAction)onScanButtonClicked:(id)sender {
//    [self performSegueWithIdentifier:@"scan.segue" sender:nil];
    CAPScanViewController *ScanVC = [[UIStoryboard storyboardWithName:@"Pair" bundle:nil] instantiateViewControllerWithIdentifier:@"ScanViewController"];
    CAPWeakSelf(self);
    [ScanVC setScanSuccessBlock:^(NSString *successStr) {
        [weakself addDeviceService:successStr owner:YES];
    }];
    [ScanVC setBindSuccessBlock:^(NSString *successStr) {
        [CAPAlertView initAlertWithContent:[NSString stringWithFormat:@"GPS ID is : %@",successStr] title:@"绑定该设备吗？" closeBlock:^{
            
        } okBlock:^{
            CAPDeviceSettingViewController *deviceSettingVC = [[UIStoryboard storyboardWithName:@"Pair" bundle:nil] instantiateViewControllerWithIdentifier:@"DeviceSettingViewController"];
            deviceSettingVC.deviceStr = successStr;
            [deviceSettingVC setInputDeviceBlock:^(CAPDevice *device) {
                [CAPAlertView initAlertWithContent:[NSString stringWithFormat:@"GPS ID is : %@",device.deviceID] title:@"绑定该设备吗？" closeBlock:^{
                    
                } okBlock:^{
                    
                } alertType:AlertTypeTwoButton];
            }];
            [self.navigationController pushViewController:deviceSettingVC animated:YES];
            
        } alertType:AlertTypeNoClose];
    }];
    [self.navigationController pushViewController:ScanVC animated:YES];
}

- (IBAction)onNumberButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"number.segue" sender:nil];
    CAPAddTrackerViewController *AddTrackerVC = [[UIStoryboard storyboardWithName:@"Pair" bundle:nil] instantiateViewControllerWithIdentifier:@"AddTrackerViewController"];
    CAPWeakSelf(self);
    [AddTrackerVC setInputSuccessBlock:^(NSString *successStr) {
        [weakself addDeviceService:successStr owner:YES];
    }];
    [self.navigationController pushViewController:AddTrackerVC animated:YES];
//    CAPDeviceSettingViewController *AddTrackerVC = [[UIStoryboard storyboardWithName:@"Pair" bundle:nil] instantiateViewControllerWithIdentifier:@"DeviceSettingViewController"];
//    [self.navigationController pushViewController:AddTrackerVC animated:YES];
}




- (void)addDeviceService:(NSString *)deviceNum owner:(BOOL)is{
    [CAPAlertView initAlertWithContent:[NSString stringWithFormat:@"GPS ID is : %@",deviceNum] title:@"绑定该设备吗？" closeBlock:^{
        
    } okBlock:^{
        CAPDevice *device = [[CAPDevice alloc] init];
        [device setDeviceID:deviceNum];
        [device setName:deviceNum];
        [gApp showHUD:@"正在处理，请稍后..."];
        CAPDeviceService *service = [[CAPDeviceService alloc] init];
        [service addDevice:device reply:^(CAPHttpResponse *response) {
            [gApp hideHUD];
            if ([[response.data objectForKey:@"code"] integerValue] == 200) {
                CAPDevice *getDevice = [CAPDevice mj_objectWithKeyValues:[response.data objectForKey:@"result"]];
                [CAPNotifications notify:kNotificationDeviceCountChange object:getDevice];
                CAPDeviceSettingViewController *AddTrackerVC = [[UIStoryboard storyboardWithName:@"Pair" bundle:nil] instantiateViewControllerWithIdentifier:@"DeviceSettingViewController"];
                AddTrackerVC.device = getDevice;
                [self.navigationController pushViewController:AddTrackerVC animated:YES];
            }else{
                [CAPAlerts alertWarning:[NSString stringWithFormat:@"%@",[response.data objectForKey:@"message"]] buttonTitle:@"确定" actionBlock:^{
                    
                }];
            }
        }];
    } alertType:AlertTypeCustom];
//    [CAPAlerts showSuccess:@"绑定该设备吗？" subTitle:[NSString stringWithFormat:@"GPS ID is : %@",deviceNum] buttonTitle:@"确定"cancleButtonTitle:@"不绑定" actionBlock:^{
//        
//    }];
}
@end
