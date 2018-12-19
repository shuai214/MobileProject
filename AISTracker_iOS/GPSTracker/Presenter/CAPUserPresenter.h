//
//  CAPUserPresenter.h
//  GPSTracker
//
//  Created by WeifengYao on 3/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPBasePresenter.h"
#import <UIKit/UIKit.h>
#import "CAPFileItem.h"

@interface CAPUserPresenter : CAPBasePresenter
@property (nonatomic, strong, readonly) NSArray<NSString *> *languages;

- (BOOL)assureNickname:(NSString *)nickname;

- (void)presentAvatar:(UIImageView *)view;
- (void)presentLanguage:(UIPickerView *)pickerView;

- (void)changeNickname:(NSString *)nickname;
- (void)changeAvatar:(CAPFileItem *)file;
- (void)changeLanguage:(NSUInteger)selectedRow;

- (void)logout;
@end
