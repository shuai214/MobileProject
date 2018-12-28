//
//  CAPMessageListViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPMessageListViewController.h"
#import "CAPMessageListTableViewCell.h"
@interface CAPMessageListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *listData;
@property (strong, nonatomic) UIView *editingView;
@property (assign , nonatomic)CGFloat tableHeight;
@end

@implementation CAPMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableHeight = self.tableView.frame.size.height;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self loadData];
    [self layoutSubviews];
    [self.tableView reloadData];
    [self.view addSubview:self.editingView];
}
- (void)loadData
{
    self.listData = [NSMutableArray array];
    for (int i = 0; i < 40 ; i++) {
        [self.listData addObject:@(i)];
    }
}
- (void)layoutSubviews
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarItemClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
- (void)rightBarItemClick:(UIBarButtonItem *)item
{
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
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld条",(long)indexPath.row + 1];
    
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

@end
