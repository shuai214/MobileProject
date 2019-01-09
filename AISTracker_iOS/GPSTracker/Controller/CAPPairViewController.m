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
@interface CAPPairViewController ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIButton *numberButton;

@end

@implementation CAPPairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.navigationController.viewControllers);

    [self setTitle:NSLocalizedString(@"tether", nil)];
//    [self.infoLabel setText:NSLocalizedString(@"tether", nil)];
//    [self.scanButton setTitle:NSLocalizedString(@"scan", nil) forState:UIControlStateNormal];
//    [self.numberButton setTitle:NSLocalizedString(@"number", nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
        [weakself addDeviceService:successStr owner:NO];
    }];
    [self.navigationController pushViewController:ScanVC animated:YES];
}

- (IBAction)onNumberButtonClicked:(id)sender {
//    [self performSegueWithIdentifier:@"number.segue" sender:nil];
//    CAPAddTrackerViewController *AddTrackerVC = [[UIStoryboard storyboardWithName:@"Pair" bundle:nil] instantiateViewControllerWithIdentifier:@"AddTrackerViewController"];
//    CAPWeakSelf(self);
//    [AddTrackerVC setInputSuccessBlock:^(NSString *successStr) {
//        [weakself addDeviceService:successStr owner:YES];
//    }];
//    [self.navigationController pushViewController:AddTrackerVC animated:YES];
    CAPDeviceSettingViewController *AddTrackerVC = [[UIStoryboard storyboardWithName:@"Pair" bundle:nil] instantiateViewControllerWithIdentifier:@"DeviceSettingViewController"];
    [self.navigationController pushViewController:AddTrackerVC animated:YES];
}

- (void)addDeviceService:(NSString *)deviceNum owner:(BOOL)is{
    [CAPAlerts showSuccess:@"绑定该设备吗？" subTitle:[NSString stringWithFormat:@"GPS ID is : %@",deviceNum] buttonTitle:@"确定"cancleButtonTitle:@"不绑定" actionBlock:^{
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
//                if ([self.navigationController.viewControllers.firstObject isKindOfClass:[CAPTrackerViewController class]]) {
//                    [self.navigationController popViewControllerAnimated:YES];
//                }else{
//                    //                [self performSegueWithIdentifier:@"main.segue" sender:nil];
                    CAPDeviceSettingViewController *AddTrackerVC = [[UIStoryboard storyboardWithName:@"Pair" bundle:nil] instantiateViewControllerWithIdentifier:@"DeviceSettingViewController"];
                    [self.navigationController pushViewController:AddTrackerVC animated:YES];
//                }
            }else{
//                [gApp showNotifyInfo:[NSString stringWithFormat:@"%@",[response.data objectForKey:@"message"]] backGroundColor:nil];
                [CAPAlerts alertWarning:[NSString stringWithFormat:@"%@",[response.data objectForKey:@"message"]] buttonTitle:@"确定" actionBlock:^{
                    
                }];
            }
        }];
    }];
}
@end
