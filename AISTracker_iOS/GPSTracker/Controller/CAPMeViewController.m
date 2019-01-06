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

@interface CAPMeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) NSArray<NSString *> *titles;
@end

@implementation CAPMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Me";
    self.titles = @[@"Name", @"Guardian", @"Update Frequency",
                    @"Untether", @"Firmware version"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    NSLog(@"%@",self.navigationController);
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const cellIdentifier = @"detail_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.titles[indexPath.row];
//    cell.detailTextLabel.text = self.details[indexPath.row];
    return cell;
}


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
