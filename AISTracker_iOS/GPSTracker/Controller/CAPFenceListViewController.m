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
@interface CAPFenceListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)CAPFenceList *fenceList;
@property (weak, nonatomic) IBOutlet UITableView *fenceListTableView;
@end

@implementation CAPFenceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"围栏";
    [self setRightBarImageButton:@"bar_add" action:@selector(onAddButtonClicked:)];
    self.fenceListTableView.delegate = self;
    self.fenceListTableView.dataSource = self;
    self.fenceListTableView.rowHeight = 105;
    self.fenceListTableView.tableFooterView = [UIView new];
    [self getFenceList];
}

- (void)getFenceList{
    CAPFenceService *fenceService = [[CAPFenceService alloc] init];
    [fenceService fetchFence:self.device.deviceID reply:^(CAPHttpResponse *response) {
        NSLog(@"%@",response);
        self.fenceList = [CAPFenceList mj_objectWithKeyValues:response.data];
        [self.fenceListTableView reloadData];
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
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)refreshLocalizedString {
    
}
- (void)onAddButtonClicked:(id)sender {
    CAPAddFenceViewController *addFence = [[CAPAddFenceViewController alloc] init];
    addFence.device = self.device;
    [self.navigationController pushViewController:addFence animated:YES];
}
@end
