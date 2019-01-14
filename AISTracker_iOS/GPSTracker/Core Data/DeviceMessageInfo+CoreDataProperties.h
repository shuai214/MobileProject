//
//  DeviceMessageInfo+CoreDataProperties.h
//  
//
//  Created by capaipai@sina.com on 2019/1/14.
//
//

#import "DeviceMessageInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DeviceMessageInfo (CoreDataProperties)

+ (NSFetchRequest<DeviceMessageInfo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *deviceId;
@property (nullable, nonatomic, copy) NSString *deviceMessage;
@property (nonatomic) float deviceMessageTime;

@end

NS_ASSUME_NONNULL_END
