//
//  CAPPhotographViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 4/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPPhotographViewController.h"
#import "CAPPhotoService.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface CAPPhotographViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

@end

@implementation CAPPhotographViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"拍照";

    
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

- (void)setDevice:(CAPDevice *)device{
    if (_device != device) {
        _device = device;
    }
}

- (IBAction)onCameraButtonClicked:(id)sender {
    CAPPhotoService *photoService = [[CAPPhotoService alloc] init];
    [photoService takingPicturesWithDeviceID:self.device.deviceID Reply:^(id response) {
        CAPHttpResponse *httpResponse = (CAPHttpResponse *)response;
        NSDictionary *dataDic = httpResponse.data;
        if ([[dataDic objectForKey:@"code"] integerValue] == 200) {
            [gApp showHUD:[dataDic objectForKey:@"message"]];
            
        }
        
    }];
}

@end
