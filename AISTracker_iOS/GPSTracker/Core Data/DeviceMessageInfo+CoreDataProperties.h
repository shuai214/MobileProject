//
//  DeviceMessageInfo+CoreDataProperties.h
//  GPSTracker
//
//  Created by 曹帅 on 2019/1/14.
//  Copyright © 2019年 Capelabs. All rights reserved.
//
//

#import "DeviceMessageInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DeviceMessageInfo (CoreDataProperties)

+ (NSFetchRequest<DeviceMessageInfo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *deviceId;
@property (nonatomic) float deviceMessageTime;
@property (nullable, nonatomic, copy) NSString *deviceMessage;

@end

NS_ASSUME_NONNULL_END
