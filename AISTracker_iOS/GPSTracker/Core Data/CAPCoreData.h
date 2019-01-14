//
//  CAPCoreData.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/14.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQTTInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface CAPCoreData : NSObject
+ (instancetype)coreData;
- (void)creatResource:(NSString *)resourceName;
- (void)insertData:(MQTTInfo *)mqttInfo;
- (void)deleteData:(NSString *)deviceMessageTime;
- (void)deleteAllData;
- (NSArray *)readData:(NSString *)resourceName;
@end

NS_ASSUME_NONNULL_END
