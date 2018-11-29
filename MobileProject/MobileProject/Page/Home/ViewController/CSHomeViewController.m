
//
//  CSHomeViewController.m
//  
//
//  Created by capaipai@sina.com on 2018/11/21.
//

#import "CSHomeViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "TableViewDataSource.h"
#import "SecondViewController.h"
#import "CSProtocolOptionalViewController.h"
#import "CSCADisplayLinkerViewController.h"
#import "CSBesierPathViewController.h"
#import "CSTextTestViewController.h"
@interface CSHomeViewController ()<UITableViewDelegate>
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) TableViewDataSource *dataSource;

@end

@implementation CSHomeViewController

- (UITableView *)myTableView{
    //初始化表格
    if (!_myTableView) {
        _myTableView                                = [[UITableView alloc] initWithFrame:CGRectMake(0,0.5, Main_Screen_Width, Main_Screen_Height) style:UITableViewStylePlain];
        _myTableView.showsVerticalScrollIndicator   = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
//        _myTableView.dataSource                     = self;
        _myTableView.delegate                       = self;
        [_myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [self.view addSubview:_myTableView];
        [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return _myTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //隐藏导航栏
    self.fd_prefersNavigationBarHidden=YES;
    [self.view addSubview:self.myTableView];
    [self setTableViewDataSource];
}

- (void)setTableViewDataSource{
    TableViewCellConfigureBlock block = ^(UITableViewCell *cell,NSString *cellData){
        cell.textLabel.text = cellData;
    };
    self.dataSource = [[TableViewDataSource alloc] initWithItems:@[@"protocol的学习",@"CADisplayLink学习",@"UIBezierPath 学习",@"YYText 学习"] cellIdentifier:NSStringFromClass([UITableViewCell class]) cellConfigureBlock:block];
    self.myTableView.dataSource = self.dataSource;
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            [self.navigationController pushViewController:[CSProtocolOptionalViewController new] animated:YES];
            break;
        }
        case 1:
        {
            [self.navigationController pushViewController:[CSCADisplayLinkerViewController new] animated:YES];
            break;
        }
        case 2:
        {
            [self.navigationController pushViewController:[CSBesierPathViewController new] animated:YES];
            break;
        }
        case 3:
        {
            [self.navigationController pushViewController:[CSTextTestViewController new] animated:YES];
            break;
        }
    }
}
@end
