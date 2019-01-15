//
//  CAPDeviceMessage.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/15.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceMessageInfo+CoreDataClass.h"
NS_ASSUME_NONNULL_BEGIN

@interface CAPDeviceMessage : NSObject
/**
 *  头像的frame
 */
@property (nonatomic, assign) CGRect iconF;
/**
 *  昵称的frame
 */
@property (nonatomic, assign) CGRect timeF;
/**
 *  正文的frame
 */
@property (nonatomic, assign) CGRect introF;
/**
 *  行高
 */
@property (nonatomic, assign) CGFloat cellHeight;
/**
 *  模型数据
 */
@property (nonatomic, strong) DeviceMessageInfo *messageInfo;
@end

NS_ASSUME_NONNULL_END
