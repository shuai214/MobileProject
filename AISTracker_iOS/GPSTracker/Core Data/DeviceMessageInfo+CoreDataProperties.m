//
//  DeviceMessageInfo+CoreDataProperties.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/15.
//  Copyright © 2019年 Capelabs. All rights reserved.
//
//

#import "DeviceMessageInfo+CoreDataProperties.h"

@implementation DeviceMessageInfo (CoreDataProperties)

+ (NSFetchRequest<DeviceMessageInfo *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"DeviceMessageInfo"];
}

@dynamic deviceId;
@dynamic deviceMessage;
@dynamic deviceMessageTime;

@end
