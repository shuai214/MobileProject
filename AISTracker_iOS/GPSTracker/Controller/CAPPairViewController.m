//
//  CAPPairViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPPairViewController.h"
#import "CAPScanViewController.h"
#import "CAPAddTrackerViewController.h"
#import "CAPDevice.h"
#import "CAPDeviceService.h"
#import "MQTTCenter.h"
#import "NSString+Size.h"
@interface CAPPairViewController ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIButton *numberButton;

@end

@implementation CAPPairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Pair" bundle:nil];
    CAPScanViewController *ScanVC = [story instantiateViewControllerWithIdentifier:@"ScanViewController"];

    [ScanVC setScanSuccessBlock:^(NSString *successStr) {
        [CAPAlerts showSuccess:@"绑定该设备吗？" subTitle:[NSString stringWithFormat:@"GPS ID is : %@",successStr] buttonTitle:@"确定"cancleButtonTitle:@"不绑定" actionBlock:^{
            CAPDevice *device = [[CAPDevice alloc] init];
            [device setDeviceID:successStr];
            [device setName:successStr];
            CAPDeviceService *service = [[CAPDeviceService alloc] init];
            [service addDevice:device reply:^(CAPHttpResponse *response) {
                CAPDevice *getDevice = [CAPDevice mj_objectWithKeyValues:[response.data objectForKey:@"result"]];
                MQTTCenter *mqttCenter = [MQTTCenter center];
                MQTTConfig *config = [[MQTTConfig alloc] init];
                config.host = @"mqtt.kvtel.com";
                config.port = 1883;
                config.username = @"demo_app";
                config.password = @"demo_890_123_654";
                config.userID = [CAPUserDefaults objectForKey:@"userID"];
                config.keepAliveInterval = 20;
                config.deviceType = MQTTDeviceTypeApp;
                config.clientID = [getDevice.deviceID stringByAppendingString:[NSString calculateStringLength:[CAPUserDefaults objectForKey:@"userID"]]];
                [mqttCenter open:config];
                [CAPNotifications notify:kNotificationDeviceCountChange object:nil];
                
            }];
        }];
    }];
    [self.navigationController pushViewController:ScanVC animated:YES];
}

- (IBAction)onNumberButtonClicked:(id)sender {
//    [self performSegueWithIdentifier:@"number.segue" sender:nil];
}
@end
