//
//  CAPAlertMessageView.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/3/22.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPAlertMessageView.h"
@interface CAPAlertMessageView()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
@implementation CAPAlertMessageView

+ (instancetype)instance {
    return [[[NSBundle mainBundle] loadNibNamed:@"CAPAlertMessageView"
                                          owner:nil options:nil]lastObject];
}
- (void)initContentView:(NSString *)content{
    self.contentLabel.text = content;
}
- (IBAction)closeButton:(id)sender {
    if (self.closeBlock) self.closeBlock();
}

@end
