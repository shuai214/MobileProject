//
//  CAPMeViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPMeViewController.h"
#import "CAPViews.h"
#import "MQTTCenter.h"

@interface CAPMeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation CAPMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)onFeedbackButtonClicked:(id)sender {
//    [CAPViews pushFromViewController:self storyboarName:@"Me" withIdentifier:@"FeedbackViewController"];
//    [self.navigationController performSegueWithIdentifier:@"feedback.segue" sender:nil];
    [self performSegueWithIdentifier:@"feedback.segue" sender:nil];
}

- (IBAction)onLogoutButtonClicked:(id)sender {
//    [self performSegueWithIdentifier:@"language.segue" sender:nil];
//     [self performSegueWithIdentifier:@"feedback.segue" sender:nil];
    MQTTConfig *config = [[MQTTConfig alloc] init];
    config.host = @"www.capelabs.net";
    config.port = 1883;
    config.username = @"demo_app";
    config.password = @"demo_890_123_654";
    config.clientID = @"X3211fd93441ed535NVWR4E00120000000052";
    config.userID = @"130";
    config.deviceType = MQTTDeviceTypeApp;
    config.platformID = @"TRUEIOT";
    config.keepAliveInterval = 20;
    [[MQTTCenter center] open:config];
}


@end
