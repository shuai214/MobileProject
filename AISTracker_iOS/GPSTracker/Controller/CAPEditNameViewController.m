//
//  CAPEditNameViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPEditNameViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CAPEditNameViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation CAPEditNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.avatarImageView sd_setImageWithURL:self.avatarURL];
    self.nameTextField.placeholder = @"Please enter";
    if(self.defaultName) {
        self.nameTextField.text = self.defaultName;
    }
}

- (void)refreshLocalizedString {
    
}

- (IBAction)onOkButtonClicked:(id)sender {
}


@end
