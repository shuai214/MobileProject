//
//  CAPDeviceLocal.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/13.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAPDeviceLocal : NSObject
+ (instancetype)local;
@property(nonatomic,assign)CLLocationCoordinate2D local;
@property(nonatomic,copy)NSString *deviceId;

//CLLocationCoordinate2D
@end

NS_ASSUME_NONNULL_END
