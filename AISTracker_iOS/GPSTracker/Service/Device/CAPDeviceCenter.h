//
//  CAPDeviceCenter.h
//  GPSTracker
//
//  Created by WeifengYao on 3/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPDevice.h"

@interface CAPDeviceCenter : NSObject
@property (nonatomic, strong, readonly) CAPDevice *device;

+ (instancetype)center;


@end
