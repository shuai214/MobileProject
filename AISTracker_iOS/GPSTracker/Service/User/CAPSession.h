//
//  CAPSession.h
//  GPSTracker
//
//  Created by user on 10/7/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAPUser.h"

@interface CAPSession : NSObject<NSCoding>
@property (nonatomic, readonly, assign, getter=getHasBindedDevice) BOOL hasBindedDevice;

@property (nonatomic, readonly, copy, getter=getUsername) NSString  *username;
@property (nonatomic, readonly, copy, getter=getUserID) NSString  *userID;
@property (nonatomic, readonly, copy, getter=getMobile) NSString *mobile;
@property (nonatomic, readonly, copy, getter=getUserLabel) NSString *userLabel;
@property (nonatomic, readonly, copy, getter=getEmail) NSString  *email;
@property (nonatomic, readonly, copy, getter=getAvatarURL) NSURL  *avatarURL;

@property (nonatomic, readonly, assign, getter=getLogon) BOOL logon;

@property (nonatomic, readonly, assign, getter=getLastSignedInTime) NSTimeInterval lastSignedInTime;

+ (instancetype)currentSession;
+ (instancetype)newSession:(CAPUser *)user;

- (void)setDeviceEmail:(NSString *)email withDeviceID:(NSString *)deviceID;
- (void)resetDeviceEmail:(NSString *)deviceID;

- (void)setTouchIDOn:(BOOL)isOn;
- (BOOL)getTouchIDOn;
- (void)resetTouchIDOn;
@end
