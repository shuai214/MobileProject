//
//  CAPUserCenter.h
//  GPSTracker
//
//  Created by WeifengYao on 3/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPUserService.h"

@interface CAPUserCenter : NSObject
@property (nonatomic, copy, readonly) NSString *userID;
@property (nonatomic, copy, readonly) NSString *nickname;
@property (nonatomic, strong, readonly) NSURL *avatarURL;
@property (nonatomic, copy, readonly) NSString *accessToken;

@property (nonatomic, assign, readonly) BOOL logon;
@property (nonatomic, assign, readonly) NSUInteger deviceCount;
@property (nonatomic, copy, readonly) NSString *language;

+ (instancetype)center;

//- (void)fetchProfile:(CAPServiceReply)reply;
- (void)updateNickname:(CAPServiceReply)reply;
- (void)updateAvatar:(CAPServiceReply)reply;
- (void)updateLanguage:(CAPServiceReply)reply;
- (void)logout:(CAPServiceResponse)reply;

@end
