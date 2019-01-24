//
//  CAPDeviceBindList.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/23.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAPDevice.h"
NS_ASSUME_NONNULL_BEGIN

@interface SOS : NSObject
@property(nonatomic,strong)NSArray *body;
@end
@interface PROFILE : NSObject
@property(nonatomic,copy)NSString *avatarBaseUrl;
@property(nonatomic,copy)NSString *avatarPath;
@property(nonatomic,copy)NSString *firstName;
@property(nonatomic,copy)NSString *gender;
@property(nonatomic,copy)NSString *locale;
@end
@interface USERS : NSObject
@property(nonatomic,strong)CAPDevice *device;
@property(nonatomic,strong)PROFILE *profile;
@property(nonatomic,copy)NSString *uid;
@end

@interface CAPDeviceBindList : NSObject
@property(nonatomic,strong)NSArray <USERS *>*users;
@end

NS_ASSUME_NONNULL_END
