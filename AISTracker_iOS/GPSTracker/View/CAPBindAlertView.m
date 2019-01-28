//
//  CAPBindAlertView.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/24.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPBindAlertView.h"
@interface CAPBindAlertView ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
@implementation CAPBindAlertView

+ (instancetype)instance {
    return [[[NSBundle mainBundle] loadNibNamed:@"CAPBindAlertView"
                                          owner:nil options:nil]lastObject];
}
- (void)fillData:(NSString *)content{
    self.contentLabel.text = content;
}
- (IBAction)allowAction:(id)sender {
        if (self.okBindUserBlock) self.okBindUserBlock();
}
- (IBAction)refuseAction:(id)sender {
       if (self.closeUserBlock) self.closeUserBlock();
}

@end
