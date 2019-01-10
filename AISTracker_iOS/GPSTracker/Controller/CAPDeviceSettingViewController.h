//
//  CAPDeviceSettingViewController.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/8.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPBaseViewController.h"
#import "CAPDevice.h"
NS_ASSUME_NONNULL_BEGIN

@interface CAPDeviceSettingViewController : CAPBaseViewController
@property(nonatomic,strong)CAPDevice *device;
@property (nonatomic, copy) void (^inputDeviceBlock)(CAPDevice *device);
@property (nonatomic,copy)NSString *deviceStr;
@end

NS_ASSUME_NONNULL_END
