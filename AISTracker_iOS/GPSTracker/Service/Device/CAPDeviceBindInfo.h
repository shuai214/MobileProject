//
//  CAPDeviceBindInfo.h
//  GPSTracker
//
//  Created by 曹帅 on 2019/1/8.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface BindInfo : NSObject
@property (nonatomic, copy) NSString *avatarBaseUrl;
@property (nonatomic, copy) NSString *avatarPath;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sos;
@end
//@interface ResultBindInfo : NSObject
//@property (nonatomic, copy) NSString *mobile;
//@property (nonatomic, copy) NSString *deviceID;
//@property (nonatomic, strong)BindInfo *bindinfo;
//@end
@interface CAPDeviceBindInfo : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong)NSArray<BindInfo *>*result;
@end

NS_ASSUME_NONNULL_END
