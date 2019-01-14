//
//  DeviceMessageInfo+CoreDataProperties.m
//  GPSTracker
//
//  Created by 曹帅 on 2019/1/14.
//  Copyright © 2019年 Capelabs. All rights reserved.
//
//

#import "DeviceMessageInfo+CoreDataProperties.h"

@implementation DeviceMessageInfo (CoreDataProperties)

+ (NSFetchRequest<DeviceMessageInfo *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"DeviceMessageInfo"];
}

@dynamic deviceId;
@dynamic deviceMessageTime;
@dynamic deviceMessage;

@end
