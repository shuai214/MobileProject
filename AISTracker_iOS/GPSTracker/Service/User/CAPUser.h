//
//  CAPUser.h
//  GPSTracker
//
//  Created by user on 10/13/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPBaseJSON.h"
#import "CAPDevice.h"

typedef NS_ENUM(NSUInteger, CAPUserType) {
    CAPUserTypeUnknown = 0,
    CAPUserTypeQQ,
    CAPUserTypeWechat,
    CAPUserTypeMobile,
    CAPUserTypeFacebook,
    CAPUserTypeLine,
    CAPUserTypeTrue
};

@interface CAPUserAccount : CAPBaseJSON
@property (nonatomic, assign) NSTimeInterval createdAt;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *userID;
@end

@interface CAPUserInfo : CAPBaseJSON
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@end

@interface CAPUserOAuth : CAPBaseJSON
@property (nonatomic, assign) NSInteger expiresIn;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSString *scope;
@property (nonatomic, copy) NSString *tokenType;
@end

@interface CAPUserProfile : CAPBaseJSON
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *avatarPath;
@property (nonatomic, copy) NSString *avatarBaseUrl;
@end

@interface CAPUserSetting : CAPBaseJSON
@property (nonatomic, copy) NSString *language;
@end

@interface CAPUser : CAPBaseJSON

@property (nonatomic, strong) CAPUserAccount *account;
@property (nonatomic, strong) NSMutableArray<CAPDevice> *devices;
@property (nonatomic, strong) CAPUserInfo *info;
@property (nonatomic, strong) CAPUserProfile *profile;
@property (nonatomic, strong) CAPUserOAuth *oauth;
@property (nonatomic, strong) CAPUserSetting *setting;

@property (nonatomic, assign) NSTimeInterval lastLoggedAt;
@property (nonatomic, assign) CAPUserType type;
@end
