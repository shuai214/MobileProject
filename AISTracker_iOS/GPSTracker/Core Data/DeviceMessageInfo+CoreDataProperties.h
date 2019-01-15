//
//  DeviceMessageInfo+CoreDataProperties.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/15.
//  Copyright © 2019年 Capelabs. All rights reserved.
//
//

#import "DeviceMessageInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DeviceMessageInfo (CoreDataProperties)

+ (NSFetchRequest<DeviceMessageInfo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *deviceId;
@property (nullable, nonatomic, copy) NSString *deviceMessage;
@property (nullable, nonatomic, copy) NSString *deviceMessageTime;

@end

NS_ASSUME_NONNULL_END
