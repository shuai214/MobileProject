//
//  CAPAddTrackerViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPAddTrackerViewController.h"

@interface CAPAddTrackerViewController ()
@property (weak, nonatomic) IBOutlet UITextField *numField;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation CAPAddTrackerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = CAPLocalizedString(@"device_no_enter");
    self.numField.placeholder = CAPLocalizedString(@"please_enter");
    [self.okButton setTitle:CAPLocalizedString(@"ok") forState:UIControlStateNormal];

}
- (IBAction)addDevice:(UIButton *)sender {
    if (self.numField.text.length != 0) {
        [self.navigationController popViewControllerAnimated:YES];
        !self.inputSuccessBlock ? : self.inputSuccessBlock(self.numField.text);
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
