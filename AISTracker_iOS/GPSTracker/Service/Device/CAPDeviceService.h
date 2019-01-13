//
//  CAPDeviceService.h
//  GPSTracker
//
//  Created by user on 9/20/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPBaseService.h"
#import "CAPDevice.h"



@interface CAPDeviceService : CAPBaseService
- (void)fetchDevice:(NSString *)deviceID reply:(CAPServiceReply)reply;

- (void)fetchDevice:(CAPServiceReply)reply;
//添加主设备
- (void)addDevice:(CAPDevice *)device reply:(CAPServiceReply)reply;

//绑定副设备
- (void)bindDevice:(NSString *)shareid param:(NSDictionary *)param reply:(CAPServiceReply)reply;

- (void)deviceConfirm:(NSString *)deviceID userid:(NSString *)userid result:(NSString *)result reply:(CAPServiceReply)reply;

- (void)getDevice:(CAPDevice *)device reply:(CAPServiceReply)reply;

- (void)updateDevice:(CAPDevice *)device reply:(CAPServiceReply)reply;

- (void)deleteDevice:(CAPDevice *)device reply:(CAPServiceReply)reply;

- (void)updateSetting:(CAPDevice *)setting reply:(CAPServiceReply)reply;

- (void)getDeviceBindinfo:(CAPDevice *)device reply:(CAPServiceReply)reply;

- (void)shareDevice:(NSString *)deviceID reply:(CAPServiceReply)reply;


- (void)fetchLastFootprint:(NSString *)deviceID reply:(CAPServiceReply)reply;
- (void)fetchFootprint:(NSString *)deviceID starttime:(NSString *)starttime endtime:(NSString *)endtime reply:(CAPServiceReply)reply;
- (void)getDeviceLogs:(NSString *)deviceID page:(NSInteger)page reply:(CAPServiceReply)reply;
- (void)deviceSendCommand:(NSString *)deviceID cmd:(NSString *)cmd param:(NSString *)param reply:(CAPServiceReply)reply;
@end
