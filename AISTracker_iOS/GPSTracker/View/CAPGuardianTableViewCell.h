//
//  CAPGuardianTableViewCell.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/8.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAPDevice.h"
NS_ASSUME_NONNULL_BEGIN

@interface CAPGuardianTableViewCell : UITableViewCell
- (void)setDeviceInfo:(CAPDevice *)device;
@end

NS_ASSUME_NONNULL_END
