//
//  CAPDevicePresenter.m
//  GPSTracker
//
//  Created by WeifengYao on 3/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPDevicePresenter.h"
#import "CAPDeviceCenter.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MQTTCenter.h"

@implementation CAPDevicePresenter

- (BOOL)assureDeviceID:(NSString *)deviceID {
    return deviceID && deviceID.length > 1;
}

- (BOOL)assureDeviceName:(NSString *)name {
    if(name && name.length > 1) {
        //TODO
        return YES;
    }
    return NO;
}

- (BOOL)assureOnline:(CAPDevice *)device {
    //TODO
    return YES;
}

- (void)presentID:(UILabel *)label {
    [self presentID:[self getDevice] label:label];
}

- (void)presentID:(CAPDevice *)device label:(UILabel *)label {
    label.text = [NSString stringWithFormat:@"%@: %@", @"Device ID", device.deviceID];
}

//- (void)presentName:(UILabel *)label {
//    [self presentName:[self getDevice] label:label];
//}
//
//- (void)presentName:(CAPDevice *)device label:(UILabel *)label {
//    label.text = [self getName:device];
//}
//
//- (void)presentName:(UITextField *)textField {
//    [self presentName:[self getDevice] textField:textField];
//}
//
//- (void)presentName:(CAPDevice *)device textField:(UITextField *)textField {
//    textField.text = [self getName:device];
//}

- (void)presentAvatar:(UIImageView *)view {
    [self presentAvatar:[self getDevice] imageView:view];
}

- (void)presentAvatar:(CAPDevice *)device imageView:(UIImageView *)view {
    NSURL *avatarURL = [self getAvatarURL:device];
    if(avatarURL) {
        [view sd_setImageWithURL:avatarURL];
    }
}

- (void)presentBattery:(CAPBatteryView *)view {
    MQTTInfo *info = [self getDeviceInfo];
    [view reloadBattery:(info ? info.batlevel : 0)];
}

- (void)presentFrequency:(UILabel *)label {
    
}

- (void)presentVersion:(UILabel *)label {
    MQTTInfo *info = [self getDeviceInfo];
    label.text = (info ? info.ver : @"unknown");
}

- (void)presentDistance:(double)distance label:(UILabel *)label {
    if(distance >= 1000) {
        label.text = [NSString stringWithFormat:@"%.1f%@", distance/1000, @"km"];
    } else {
        label.text = [NSString stringWithFormat:@"%.1f%@", distance, @"m"];
    }
}

- (void)presentAddress:(NSString *)address label:(UILabel *)label {
    label.text = (address ? address : @"unknown");
}

- (void)presentLastUpdate:(NSTimeInterval *)time label:(UILabel *)label {
    if(time > 0) {
        //TODO
        label.text = [NSString stringWithFormat:@""];
    } else {
        label.text = [NSString stringWithFormat:@"%@: %@", @"Updated", @"unknown"];
    }
}

- (CAPDevice *)getDevice {
    return [CAPDeviceCenter center].device;
}

- (NSString *)getName {
    return [self getName:[self getDevice]];
}

- (NSString *)getName:(CAPDevice *)device {
    return (device.name ? device.name : device.deviceID);
}

- (NSURL *)getAvatarURL:(CAPDevice *)device {
//    if(device.setting.avatar.url) {
//        return [NSURL URLWithString:device.setting.avatar.url];
//    }
    return nil;
}

- (MQTTInfo *)getDeviceInfo {
    return [[MQTTCenter center] getInfo:[self getDevice].deviceID];
}

@end
