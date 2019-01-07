//
//  CAPGuardianListViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPGuardianListViewController.h"
#import "CAPCheckableTableCell.h"
#import "CAPDeviceService.h"

@interface CAPGuardianListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CAPGuardianListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"监护人列表";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadDeviceBindInfo];
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const cellIdentifier = @"detail_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
//    cell.textLabel.text = self.titles[indexPath.row];
//    cell.detailTextLabel.text = self.details[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
