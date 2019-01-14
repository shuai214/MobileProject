//
//  CAPMessageListViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPMessageListViewController.h"
#import "CAPMessageListTableViewCell.h"
#import "CAPDeviceService.h"
#import "CAPDeviceLogs.h"
#import "MJRefresh.h"
#import "CAPCoreData.h"
#import "DeviceMessageInfo+CoreDataClass.h"
@interface CAPMessageListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<DeviceMessageInfo *> *listData;
@property (strong, nonatomic) UIView *editingView;
@property (assign , nonatomic)CGFloat tableHeight;
@property (strong, nonatomic) CAPDeviceLogs *deviceLogs;
@property (assign , nonatomic)NSInteger page;
@end

@implementation CAPMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"消息";
    self.tableHeight = self.tableView.frame.size.height;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self layoutSubviews];
    [self.tableView reloadData];
    [self.view addSubview:self.editingView];
    
    self.listData = [NSMutableArray array];
    self.page = 0;
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    self.tableView.mj_footer = footer;
    [footer setTitle:@"正在加载中" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    footer.stateLabel.font = [UIFont systemFontOfSize:15.0f];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 马上进入刷新状态
    [header beginRefreshing];
    // 设置header
    self.tableView.mj_header = header;
}
- (void)loadNewData{
    self.listData = [NSMutableArray array];
//    self.page = 0;
    [self loadData:NO];
}
//
//- (void)loadMoreData{
//    [self loadData:YES];
//}

- (void)loadData:(BOOL)isLoadMore;
{
//    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
//    [deviceService getDeviceLogs:@"0" page:self.page reply:^(CAPHttpResponse *response) {
//        self.deviceLogs = [CAPDeviceLogs mj_objectWithKeyValues:response.data];
//        NSLog(@"%@",response);
//        [self.listData addObjectsFromArray:self.deviceLogs.result.list];
//        if (!isLoadMore) {
//            self.page = 1;
//            self.tableView.mj_footer.hidden = NO;
//        }else{
//            if (self.page == (self.deviceLogs.result.pages - 1)) {
//                self.tableView.mj_footer.hidden = YES;
//            }else{
//                self.page ++;
//            }
//        }
//        [self.tableView reloadData];
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//    }];
    CAPCoreData *coreData = [CAPCoreData coreData];
    [coreData creatResource:@"MessageLogs"];
    NSArray *array = [coreData readData:@"DeviceMessageInfo"];
    self.listData = [NSMutableArray arrayWithArray:array];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
//    [self.tableView.mj_footer endRefreshing];

}
- (void)layoutSubviews
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarItemClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
- (void)rightBarItemClick:(UIBarButtonItem *)item{
    if ([item.title isEqualToString:@"编辑"]) {
        if (self.listData.count == 0) {
            return;
        }
        item.title = @"取消";
        [self.tableView setEditing:YES animated:YES];
        [self showEitingView:YES];
    }else{
        item.title = @"编辑";
        [self.tableView setEditing:NO animated:YES];
        
        [self showEitingView:NO];
    }
}
- (void)showEitingView:(BOOL)isShow
{
    [UIView animateWithDuration:0.3 animations:^{
        self.editingView.frame = CGRectMake(0, isShow ? Main_Screen_Height - 45 - BottomHeight - TabBarHeight - TopHeight: Main_Screen_Height - BottomHeight - TabBarHeight - TopHeight, Main_Screen_Width, 45);
        self.tableView.frame = CGRectMake(0, self.tableView.frame.origin.y, self.tableView.frame.size.width, isShow ? self.tableHeight - 45 : self.tableHeight);
    }];
}

#pragma mark -- UITabelViewDelegate And DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photos";
    CAPMessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[CAPMessageListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    DeviceMessageInfo *list = self.listData[indexPath.row];
//    if (list.logContent.data) {
//        NSData *_decodedImageData   = [[NSData alloc] initWithBase64Encoding:list.logContent.data];
//        UIImage *_decodedImage      = [UIImage imageWithData:_decodedImageData];
//        [cell.imageView setImage:_decodedImage];
//    }else{
//        [cell.imageView setImage:nil];
//    }
    NSString *time = [NSString dateFormateWithTimeInterval:list.deviceMessageTime];
    cell.textLabel.text = list.deviceMessage;
    cell.textLabel.text = time;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing)
    {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (UIView *)editingView
{
    if (!_editingView) {
        _editingView = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height, Main_Screen_Width, 45)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor redColor];
        [button setTitle:@"删除" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p__buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(Main_Screen_Width / 2, 0, Main_Screen_Width / 2, 45);
        [_editingView addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor darkGrayColor];
        [button setTitle:@"全选" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(p__buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, Main_Screen_Width / 2, 45);
        [_editingView addSubview:button];
    }
    return _editingView;
}
- (void)p__buttonClick:(UIButton *)sender
{
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"删除"]) {
        NSMutableIndexSet *insets = [[NSMutableIndexSet alloc] init];
        [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [insets addIndex:obj.row];
        }];
        CAPCoreData *coreData = [CAPCoreData coreData];
        [coreData creatResource:@"MessageModel"];
        [coreData deleteAllData];
        [self.listData removeObjectsAtIndexes:insets];
        [self.tableView deleteRowsAtIndexPaths:[self.tableView indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
        
        if (self.listData.count == 0) {
            self.navigationItem.rightBarButtonItem.title = @"编辑";
            [self.tableView setEditing:NO animated:YES];
            [self showEitingView:NO];
        }
        
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全选"]) {
        [self.listData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }];
        
        [sender setTitle:@"全不选" forState:UIControlStateNormal];
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全不选"]){
        
        [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tableView deselectRowAtIndexPath:obj animated:NO];
        }];
        
        [sender setTitle:@"全选" forState:UIControlStateNormal];
        
    }
}

- (void)refreshLocalizedString {
    
}

@end
