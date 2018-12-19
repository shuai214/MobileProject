//
//  CAPLoginViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPLoginViewController.h"
#import "CAPViews.h"

@interface CAPLoginViewController ()

@end

@implementation CAPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)onWechatButtonClicked:(id)sender {
    [self showMainPage];
}

- (IBAction)onFacebookButtonClicked:(id)sender {
    [self showMainPage];
}

- (IBAction)onLineButtonClicked:(id)sender {
    [self showMainPage];
}

- (void)showMainPage {
    [self performSegueWithIdentifier:@"main.segue" sender:nil];
}

@end
