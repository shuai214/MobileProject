//
//  CAPFenceListViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPFenceListViewController.h"
#import "CAPAddFenceViewController.h"
#import "CAPFenceService.h"
#import "CAPFenceList.h"
#import "CAPFenceListTableViewCell.h"
#import "CAPFenceDetailViewController.h"
@interface CAPFenceListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)CAPFenceList *fenceList;
@property (weak, nonatomic) IBOutlet UITableView *fenceListTableView;
@end

@implementation CAPFenceListViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getFenceList];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"围栏";
    [self setRightBarImageButton:@"bar_add" action:@selector(onAddButtonClicked:)];
    self.fenceListTableView.delegate = self;
    self.fenceListTableView.dataSource = self;
    self.fenceListTableView.rowHeight = 80;
    self.fenceListTableView.tableFooterView = [UIView new];
}

- (void)getFenceList{
    [gApp showHUD:@"正在加载，请稍后..."];
    CAPFenceService *fenceService = [[CAPFenceService alloc] init];
    [fenceService fetchFence:self.device.deviceID reply:^(CAPHttpResponse *response) {
        NSLog(@"%@",response);
        self.fenceList = [CAPFenceList mj_objectWithKeyValues:response.data];
        [self.fenceListTableView reloadData];
        [gApp hideHUD];
        if (self.fenceList.result.list.count == 0) {
            [gApp showNotifyInfo:@"您还没有设置围栏！" backGroundColor:[UIColor orangeColor]];
        }
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fenceList.result.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"FenceListTableViewCell";

    CAPFenceListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CAPFenceListTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    List *list = self.fenceList.result.list[indexPath.row];
    [cell setListData:list];
    CAPWeakSelf(self);
    [cell setSwitchIsBlock:^(BOOL isOn,CAPFenceListTableViewCell *Cell) {
        NSIndexPath *indexCellPath = [tableView indexPathForCell:Cell];
        List *cellList = weakself.fenceList.result.list[indexCellPath.row];
        cellList.status = isOn ? @"1":@"0";
        CAPFenceService *fenceService = [[CAPFenceService alloc] init];
        [gApp showHUD:@"正在更新设置，请稍后..."];
        [fenceService editFence:cellList reply:^(CAPHttpResponse *response) {
            NSDictionary *data = response.data;
            if ([[data objectForKey:@"code"] integerValue] == 200) {
                [gApp hideHUD];
            }else{
                [gApp showHUD:[data objectForKey:@"message"] cancelTitle:@"确定" onCancelled:^{
                    [gApp hideHUD];
                }];
            }
        }];
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    List *cellList = self.fenceList.result.list[indexPath.row];
    CAPFenceDetailViewController *fenceDetail = [[CAPFenceDetailViewController alloc] init];
    fenceDetail.listItem = cellList;
    [self.navigationController pushViewController:fenceDetail animated:YES];
}
- (void)refreshLocalizedString {
    
}
- (void)onAddButtonClicked:(id)sender {
    CAPAddFenceViewController *addFence = [[CAPAddFenceViewController alloc] init];
    addFence.device = self.device;
    [self.navigationController pushViewController:addFence animated:YES];
}
@end
