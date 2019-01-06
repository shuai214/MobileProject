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
- (void)addDevice:(CAPDevice *)device reply:(CAPServiceReply)reply;
- (void)updateDevice:(CAPDevice *)device reply:(CAPServiceReply)reply;
- (void)deleteDevice:(CAPDevice *)device reply:(CAPServiceReply)reply;
- (void)updateSetting:(CAPDeviceSetting *)setting reply:(CAPServiceReply)reply;

- (void)shareDevice:(NSString *)deviceID reply:(CAPServiceReply)reply;

- (void)fetchLastFootprint:(NSString *)deviceID reply:(CAPServiceReply)reply;
- (void)fetchFootprint:(NSString *)deviceID range:(NSRange)range reply:(CAPServiceReply)reply;
- (void)getDeviceLogs:(NSString *)deviceID page:(NSInteger)page reply:(CAPServiceReply)reply;
- (void)deviceSendCommand:(NSString *)deviceID cmd:(NSString *)cmd param:(NSString *)param reply:(CAPServiceReply)reply;
@end
