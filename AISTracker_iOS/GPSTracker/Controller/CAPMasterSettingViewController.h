//
//  CAPMasterSettingViewController.h
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPBaseViewController.h"
#import "CAPDevice.h"

@interface CAPMasterSettingViewController : CAPBaseViewController

@property(nonatomic,strong)CAPDevice *device;
@property(nonatomic,assign)CGFloat battery;

@end
