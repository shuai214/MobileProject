//
//  CAPDeviceListResponse.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2018/12/25.
//  Copyright © 2018年 Capelabs. All rights reserved.
//

#import "CAPResponse.h"
#import "CAPDeviceLists.h"
NS_ASSUME_NONNULL_BEGIN

@interface CAPDeviceListResponse : CAPResponse
@property (nonatomic, strong) CAPDeviceLists *deviceLists;

@end

NS_ASSUME_NONNULL_END
