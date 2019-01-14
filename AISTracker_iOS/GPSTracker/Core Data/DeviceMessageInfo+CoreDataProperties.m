//
//  DeviceMessageInfo+CoreDataProperties.m
//  
//
//  Created by capaipai@sina.com on 2019/1/14.
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
