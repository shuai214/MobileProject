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
@interface CAPFenceListViewController ()

@end

@implementation CAPFenceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"围栏";
    [self setRightBarImageButton:@"bar_add" action:@selector(onAddButtonClicked:)];
    [self getFenceList];
}

- (void)getFenceList{
    CAPFenceService *fenceService = [[CAPFenceService alloc] init];
    [fenceService fetchFence:self.device.deviceID reply:^(CAPHttpResponse *response) {
        NSLog(@"%@",response);
    }];

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
- (void)onAddButtonClicked:(id)sender {
    CAPAddFenceViewController *addFence = [[CAPAddFenceViewController alloc] init];
    addFence.device = self.device;
    [self.navigationController pushViewController:addFence animated:YES];
}
@end
