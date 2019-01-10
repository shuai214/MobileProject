//
//  MQTTInfo.h
//  GPSTracker
//
//  Created by WeifengYao on 30/10/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPBaseJSON.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MQTTInfoType) {
    MQTTInfoTypeUnknown,
    MQTTInfoTypeBasic,
    MQTTInfoTypeResult,
    MQTTInfoTypeNotify,
    MQTTInfoTypeHistory
};

@protocol NeighborInfo <NSObject>
@end

@protocol WifiInfo <NSObject>
@end

@interface NeighborInfo : CAPBaseJSON
@property (nonatomic, copy) NSString *AC;
    //@property (nonatomic, copy) NSString *NSString *NO;
    @property (nonatomic, copy) NSString *SS;
@end

@interface StationInfo : CAPBaseJSON
    @property (nonatomic, copy) NSString *TA;
    @property (nonatomic, copy) NSString *MCC;
    @property (nonatomic, copy) NSString *MNC;
    @property (nonatomic, copy) NSString *AC;
    //@property (nonatomic, copy) NSString *NO;
    @property (nonatomic, copy) NSString *SS;
@end

@interface WifiInfo : CAPBaseJSON
    @property (nonatomic, copy) NSString *name;
    @property (nonatomic, copy) NSString *mac;
    @property (nonatomic, assign) NSInteger ss;
@end
@interface UserProfile : CAPBaseJSON
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *avatarPath;
@property (nonatomic, copy) NSString *avatarBaseUrl;
@property (nonatomic, copy) NSString *locale;

@end
@interface MQTTInfo : CAPBaseJSON
//private static final int MASK_SOS = 0x10;

@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, assign) CGFloat gps;
@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat altitude;
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) CGFloat direction;
@property (nonatomic, assign) CGFloat gpsnum;
@property (nonatomic, assign) CGFloat gpsmss;
@property (nonatomic, assign) CGFloat batlevel;
@property (nonatomic, assign) NSInteger steps;
@property (nonatomic, assign) NSInteger rolls;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) StationInfo *station;
@property (nonatomic, strong) UserProfile *userProfile;

@property (nonatomic, strong) NSArray<NeighborInfo *>  *neighbors;
@property (nonatomic, strong) NSArray<WifiInfo *> *wifis;

@property (nonatomic, copy) NSString *ver;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *IMEI;
@property (nonatomic, assign) NSInteger upload;
@property (nonatomic, copy) NSString *server;
@property (nonatomic, assign) NSInteger port;
@property (nonatomic, strong) NSArray *SOS;
@property (nonatomic, assign) NSInteger VOLUME;
@property (nonatomic, assign) NSInteger PEDO;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *zone;
@property (nonatomic, assign) NSInteger led;
@property (nonatomic, copy) NSString *pwd;

@property (nonatomic, copy) NSString *filename;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *data;

@property (nonatomic, copy) NSString *sms;
@property (nonatomic, assign) NSInteger val;

@property (nonatomic, copy) NSString *command;
@property (nonatomic, assign) NSInteger statusCode;

@property (nonatomic, assign) MQTTInfoType infoType;

@property (nonatomic, assign) NSInteger online;

@property (nonatomic, copy) NSString *deviceID;

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userRole;
//@property (nonatomic, strong) User.Profile *userProfile;
@property (nonatomic, assign) NSTimeInterval updatedTime;
@property (nonatomic, assign) NSTimeInterval refreshGPSTime;

- (BOOL)isSuccess;

- (BOOL)assureGPSInfo;
- (BOOL)assurePhotoInfo;
- (BOOL)assureFrequencyInfo;
- (BOOL)assureVersionInfo;
- (BOOL)assureSOSInfo;
- (BOOL)assureDeleteGuardianInfo;
- (BOOL)assureGuardianQuitInfo;
- (BOOL)assureStatusInfo;
- (BOOL)assureBasicInfo;

- (BOOL)assureBatlevelValue;
- (BOOL)assureVerValue;
- (BOOL)assureLatLngValue;
@end


