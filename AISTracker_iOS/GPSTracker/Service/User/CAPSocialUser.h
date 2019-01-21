//
//  CAPSocialUser.h
//  GPSTracker
//
//  Created by WeifengYao on 11/4/2017.
//  Copyright © 2017 capelabs. All rights reserved.
//

#import "CAPBaseJSON.h"
#import "CAPUser.h"

@interface CAPSocialUser : CAPBaseJSON
//@property (nonatomic, assign) NSInteger expiresIn;
//@property (nonatomic, assign) NSInteger socialType; //1-QQ, 2-Wechat
@property (nonatomic, assign) CAPUserType type;

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSString *openID;
@property (nonatomic, assign) NSTimeInterval expirationDate;
@property (nonatomic, copy) NSString *appID;
@property (nonatomic, copy) NSString *unionID;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *verifyCode;
@property (nonatomic, copy) NSString *email;

@end
