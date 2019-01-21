//
//  CAPChooseDeviceTypeViewController.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/18.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPChooseDeviceTypeViewController.h"
#import "CAPUser.h"
@interface CAPChooseDeviceTypeViewController ()
@property(nonatomic,strong)CAPUser *user;
@end

@implementation CAPChooseDeviceTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [CAPNotifications addObserver:self selector:@selector(notification:) name:kNotificationLoginDeviceCount object:nil];
}

- (void)notification:(NSNotification *)noti{
    self.user = noti.object;
}
- (IBAction)trackerAction:(id)sender {
    if (self.user.devices.count == 0) {
        [self showPairPage];
    }else{
        [self showMainPage];
    }
}

- (void)showMainPage {
    [self performSegueWithIdentifier:@"main.segue" sender:nil];
}
- (void)showPairPage{
    [self performSegueWithIdentifier:@"pair.segue" sender:nil];
}
@end
