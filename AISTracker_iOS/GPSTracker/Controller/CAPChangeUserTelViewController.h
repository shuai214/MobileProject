//
//  CAPChangeUserTelViewController.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/2/16.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPBaseViewController.h"
#import "CAPUser.h"
#import "CAPDevice.h"
NS_ASSUME_NONNULL_BEGIN

@interface CAPChangeUserTelViewController : CAPBaseViewController
@property(nonatomic,strong)CAPUser *user;
@property(nonatomic,strong)CAPDevice *device;
@property(nonatomic,copy)NSString *userStr;
@property (nonatomic , copy ) void (^updateSuccessBlock)(id cap);
@property (nonatomic , copy ) void (^updateDeviceSuccessBlock)(CAPDevice *device);

@end

NS_ASSUME_NONNULL_END
