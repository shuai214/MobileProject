//
//  CAPFileUpload.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/24.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAPDevice.h"
NS_ASSUME_NONNULL_BEGIN

@interface CAPFileUpload : NSObject
@property(nonatomic,strong)void (^failureBlock)(void);
@property(nonatomic,strong)void (^successBlockObject)(id object);
- (void)uploadRecording:(id)recordingFile withImageIndex:(NSInteger)index;
- (void)getDeviceLoacl:(NSString *)latlng;
- (void)getDeviceDetailLoacl:(NSDictionary *)parameter;
- (void)setSOSMobile:(CAPDevice *)device array:(NSArray *)array;
- (void)loadDeviceParameter:(id)parameter device:(CAPDevice *)device;
- (void)updateDeviceInfo:(NSDictionary *)dic deviceID:(NSString *)deviceId;
- (void)putProfile:(NSDictionary *)dic;
- (void)putDeviceProfile:(NSString *)url dic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
