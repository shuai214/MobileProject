//
//  CAPModifyAvatar.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/23.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPModifyAvatar.h"
@interface CAPModifyAvatar()
@property (weak, nonatomic) IBOutlet UILabel *takingPhotoLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;

@end
@implementation CAPModifyAvatar
+ (instancetype)instance {
    return [[[NSBundle mainBundle] loadNibNamed:@"CAPModifyAvatar"
                                          owner:nil options:nil]lastObject];
}

- (IBAction)takingPhotoAction:(id)sender {
    if (self.tabkingPhotoBlock) self.tabkingPhotoBlock();
}

- (IBAction)albumAction:(id)sender {
    if (self.albumBlock) self.albumBlock();
}

- (IBAction)closeAction:(id)sender {
    if (self.closeBlock) self.closeBlock();
}


@end
