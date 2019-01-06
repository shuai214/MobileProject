//
//  CAPFootprintViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPFootprintViewController.h"
#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GoogleMaps.h>
#import "HMWeeklySelectDateView.h"

@interface CAPFootprintViewController ()
@property (weak, nonatomic) IBOutlet GMSMapView *gmsMapView;
@property (nonatomic, strong) HMWeeklySelectDateView *dateSelectView;

@end

@implementation CAPFootprintViewController
- (HMWeeklySelectDateView *)dateSelectView {
    if (!_dateSelectView) {
        _dateSelectView = [[HMWeeklySelectDateView alloc] initWithStartDate:[NSDate date]];
        [_dateSelectView dateCellClick:^(NSDate *selectedDate) {
            [self setTitle:[selectedDate formattedDateWithFormat:@"yyyy-MM-dd"]];
        }];
    }
    return _dateSelectView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"轨迹";
    [self.view addSubview:self.dateSelectView];
    [self.dateSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(TopHeight);
        make.height.equalTo(@100);
    }];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
}

- (void)rightClick {
    [self.dateSelectView configDate:[NSDate date]];
    [self setTitle:[[NSDate date] formattedDateWithFormat:@"yyyy-MM-dd"]];
}


- (void)refreshLocalizedString {
    
}

@end
