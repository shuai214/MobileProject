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
@property (strong , nonatomic)NSMutableArray *dataArray;
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
    self.dataArray = [NSMutableArray array];
    [self loadDeviceBindUserInfo];
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
- (void)loadDeviceBindUserInfo{
    [gApp showHUD:@"正在加载，请稍后..."];
    CAPDeviceService *deviceServer = [[CAPDeviceService alloc] init];
    [deviceServer getDevice:self.device reply:^(CAPHttpResponse *response) {
        [gApp hideHUD];
        if ([[response.data objectForKey:@"code"] integerValue] == 200) {
           NSArray *array = [response.data objectForKey:@"result"];
            for (NSInteger i = 0 ;i < array.count ;i++) {
                NSDictionary *dic = array[i];
                self.device = [CAPDevice mj_objectWithKeyValues:dic];
                [self.dataArray addObject:self.device];
            }
        }else{
            [gApp showNotifyInfo:[response.data objectForKey:@"message"] backGroundColor:[CAPColors gray1]];
        }
        [self.tableView reloadData];
    }];
}

- (void)refreshLocalizedString {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const cellIdentifier = @"GuardianTableViewCell";
    CAPGuardianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CAPGuardianTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CAPDevice *device = self.dataArray[indexPath.row];
    [cell setDeviceInfo:device];
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
