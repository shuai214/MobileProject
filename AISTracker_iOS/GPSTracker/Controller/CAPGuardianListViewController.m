//
//  CAPGuardianListViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPGuardianListViewController.h"
#import "CAPGuardianTableViewCell.h"
#import "CAPDeviceService.h"
#import "CAPGuardianInvitationViewController.h"
@interface CAPGuardianListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CAPGuardianListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"监护人列表";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"邀请" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarItemClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 80;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadDeviceBindInfo];
}
- (void)rightBarItemClick:(UIBarButtonItem *)item
{
    CAPGuardianInvitationViewController *GuardianInvitationVC = [[UIStoryboard storyboardWithName:@"MasterSetting" bundle:nil] instantiateViewControllerWithIdentifier:@"GuardianInvitationViewController"];
    GuardianInvitationVC.device = self.device;
//    CAPWeakSelf(self);
//    [AddTrackerVC setInputSuccessBlock:^(NSString *successStr) {
//        [weakself addDeviceService:successStr];
//    }];
    [self.navigationController pushViewController:GuardianInvitationVC animated:YES];
}
- (void)loadDeviceBindInfo{
    CAPDeviceService *deviceServer = [[CAPDeviceService alloc] init];
    [deviceServer getDevice:self.device reply:^(CAPHttpResponse *response) {
        self.device = [CAPDevice mj_objectWithKeyValues:[response.data objectForKey:@"result"]];
         NSLog(@"%@",response);
    }];
}

- (void)refreshLocalizedString {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const cellIdentifier = @"GuardianTableViewCell";
    CAPGuardianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CAPGuardianTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDeviceInfo:self.device];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 45)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, Main_Screen_Width - 30, 15)];
    label.text = @"Administrator";
    [view addSubview:label];
    return view;
}
#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
