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
#import "CAPDeviceMessage.h"
@interface CAPMessageListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<CAPDeviceMessage *> *listData;
@property (strong, nonatomic) UIView *editingView;
@property (assign , nonatomic)CGFloat tableHeight;
@property (strong, nonatomic) CAPDeviceLogs *deviceLogs;
@property (copy, nonatomic) NSString *selectAll;
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
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    
   
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    header.automaticallyChangeAlpha = YES;
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 马上进入刷新状态
    [header beginRefreshing];
    // 设置header
    self.tableView.mj_header = header;
}


- (void)loadData{
    self.listData = [NSMutableArray array];
    CAPCoreData *coreData = [CAPCoreData coreData];
    [coreData creatResource:@"GPSTracker"];
    NSArray *array = [coreData readData:@"DeviceMessageInfo"];
    for (DeviceMessageInfo *messageInfo in array) {
        // 根据模型数据创建frame模型
       CAPDeviceMessage *deviceMessage = [[CAPDeviceMessage alloc] init];
        deviceMessage.messageInfo = messageInfo;
        [self.listData addObject:deviceMessage];
    }
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];

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
    CAPDeviceMessage *deviceMessage  = self.listData[indexPath.row];
    cell.deviceMessage = deviceMessage;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CAPDeviceMessage *cellF = self.listData[indexPath.row];
    return cellF.cellHeight;
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //只要实现这个方法，就实现了默认滑动删除！！！！！
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


- (UIView *)editingView
{
    self.selectAll = @"NO";
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
        NSMutableArray *indexArray = [[NSMutableArray alloc] init];
        [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [insets addIndex:obj.row];
            [indexArray addObject:self.listData[obj.row].messageInfo.deviceMessageTime];
        }];
        [self.listData removeObjectsAtIndexes:insets];
        [self.tableView deleteRowsAtIndexPaths:[self.tableView indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
        if (self.listData.count == 0) {
            self.navigationItem.rightBarButtonItem.title = @"编辑";
            [self.tableView setEditing:NO animated:YES];
            [self showEitingView:NO];
        }
        
        CAPCoreData *coreData = [CAPCoreData coreData];
        [coreData creatResource:@"GPSTracker"];
        if ([self.selectAll isEqualToString:@"NO"]) {
            [coreData deleteData:indexArray];
            [self loadData];
            [self.tableView setEditing:NO animated:YES];
            [self showEitingView:NO];
            self.navigationItem.rightBarButtonItem.title = @"编辑";
        }else{
            [coreData deleteAllData];
            [self loadData];
            [self.tableView setEditing:NO animated:YES];
            [self showEitingView:NO];
            self.navigationItem.rightBarButtonItem.title = @"编辑";
        }
        
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全选"]) {
        [self.listData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }];
        self.selectAll = @"YES";
        [sender setTitle:@"全不选" forState:UIControlStateNormal];
    }else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"全不选"]){
        
        [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tableView deselectRowAtIndexPath:obj animated:NO];
        }];
        self.selectAll = @"NO";
        [sender setTitle:@"全选" forState:UIControlStateNormal];
        
    }
}

- (void)refreshLocalizedString {
    
}

@end
