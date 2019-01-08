//
//  CAPDevicePresenter.h
//  GPSTracker
//
//  Created by WeifengYao on 3/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPBasePresenter.h"
#import "CAPDevice.h"
#import <UIKit/UIKit.h>
#import "CAPBatteryView.h"

@interface CAPDevicePresenter : CAPBasePresenter

- (BOOL)assureDeviceID:(NSString *)deviceID;
- (BOOL)assureDeviceName:(NSString *)name;
- (BOOL)assureOnline:(CAPDevice *)device;

- (void)presentID:(UILabel *)label;
//- (void)presentID:(CAPDevice *)device label:(UILabel *)label;

- (void)presentAvatar:(UIImageView *)view;
//- (void)presentAvatar:(CAPDevice *)device imageView:(UIImageView *)view;

- (void)presentBattery:(CAPBatteryView *)view;
- (void)presentFrequency:(UILabel *)label;
- (void)presentVersion:(UILabel *)label;
- (void)presentDistance:(double)distance label:(UILabel *)label;
- (void)presentAddress:(NSString *)address label:(UILabel *)label;
- (void)presentLastUpdate:(NSTimeInterval *)time label:(UILabel *)label;

- (NSString *)getName;

@end
