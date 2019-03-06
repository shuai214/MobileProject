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
    [self mqttConnect];
}
- (void)mqttConnect{
    MQTTCenter *mqttCenter = [MQTTCenter center];
    MQTTConfig *config = [[MQTTConfig alloc] init];
    config.host = @"mqtt.kvtel.com";
    config.port = 1883;
    config.username = @"demo_app";
    config.password = @"demo_890_123_654";
    config.userID = [CAPUserDefaults objectForKey:@"userID"];
    config.keepAliveInterval = 20;
    config.deviceType = MQTTDeviceTypeApp;
    config.platformID = @"KVTELIOT";
    config.clientID = [[CAPPhones getUUIDString] stringByAppendingString:[NSString calculateStringLength:[CAPUserDefaults objectForKey:@"userID"]]];
    [mqttCenter open:config];
}
- (void)registBindUserDevice:(NSNotification *)notifi{
    [CAPAlertView initAlertWithContent:CAPLocalizedString(@"pair_success") title:@"" closeBlock:^{
        
    } okBlock:^{
        [CAPNotifications notify:kNotificationDeviceCountChange];
        [self performSegueWithIdentifier:@"main.segue" sender:nil];

//        [self.navigationController popToRootViewControllerAnimated:YES];
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
        [CAPAlertView initAlertWithContent:[NSString stringWithFormat:@"%@%@",CAPLocalizedString(@"confirm_pair_device"),successStr] title:@"" closeBlock:^{
            
        } okBlock:^{
            CAPDeviceSettingViewController *deviceSettingVC = [[UIStoryboard storyboardWithName:@"Pair" bundle:nil] instantiateViewControllerWithIdentifier:@"DeviceSettingViewController"];
            deviceSettingVC.deviceStr = successStr;
            [deviceSettingVC setInputDeviceBlock:^(CAPDevice *device) {
                [CAPAlertView initAlertWithContent:[NSString stringWithFormat:@"%@%@",CAPLocalizedString(@"confirm_pair_device"),device.deviceID] title:@"" closeBlock:^{
                    
                } okBlock:^{
                    [CAPAlertView initAlertWithContent:[NSString stringWithFormat:@"%@%@",CAPLocalizedString(@"confirm_pair_device"),device.deviceID] title:@"" closeBlock:^{
                        
                    } okBlock:^{
                        
                    } alertType:AlertTypeTwoButton];
                } alertType:AlertTypeNoClose];
            }];
            [self.navigationController pushViewController:deviceSettingVC animated:YES];
            
        } alertType:AlertTypeCustom];
    }];
    [self.navigationController pushViewController:ScanVC animated:YES];
}

- (IBAction)onNumberButtonClicked:(id)sender {
    CAPAddTrackerViewController *AddTrackerVC = [[UIStoryboard storyboardWithName:@"Pair" bundle:nil] instantiateViewControllerWithIdentifier:@"AddTrackerViewController"];
    CAPWeakSelf(self);
    [AddTrackerVC setInputSuccessBlock:^(NSString *successStr) {
        [weakself addDeviceService:successStr owner:YES];
    }];
    [self.navigationController pushViewController:AddTrackerVC animated:YES];

}




- (void)addDeviceService:(NSString *)deviceNum owner:(BOOL)is{
    [CAPAlertView initAlertWithContent:[NSString stringWithFormat:@"%@%@",CAPLocalizedString(@"confirm_pair_device"),deviceNum] title:@"" closeBlock:^{
        
    } okBlock:^{
        CAPDevice *device = [[CAPDevice alloc] init];
        [device setDeviceID:deviceNum];
        [device setName:deviceNum];
//        [gApp showHUD:@"正在处理，请稍后..."];
//        CAPDeviceService *service = [[CAPDeviceService alloc] init];
//        [service addDevice:device reply:^(CAPHttpResponse *response) {
//            [gApp hideHUD];
//            if ([[response.data objectForKey:@"code"] integerValue] == 200) {
//                CAPDevice *getDevice = [CAPDevice mj_objectWithKeyValues:[response.data objectForKey:@"result"]];
//                [CAPNotifications notify:kNotificationDeviceCountChange object:getDevice];
                CAPDeviceSettingViewController *deviceSeting = [[UIStoryboard storyboardWithName:@"Pair" bundle:nil] instantiateViewControllerWithIdentifier:@"DeviceSettingViewController"];
                deviceSeting.device = device;
                [self.navigationController pushViewController:deviceSeting animated:YES];
//            }else{
//                [CAPAlerts alertWarning:[NSString stringWithFormat:@"%@",[response.data objectForKey:@"message"]] buttonTitle:@"确定" actionBlock:^{
//
//                }];
//            }
//        }];
    } alertType:AlertTypeCustom];
}
@end
