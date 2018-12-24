//
//  CAPSocialService.h
//  GPSTracker
//
//  Created by WeifengYao on 3/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAPSocialUser.h"
#define  WXAUTH [CAPSocialService sharedInstance]

@interface CAPSocialService : NSObject

+ (CAPSocialService *)sharedInstance;
- (BOOL)handleOpenURL:(NSURL *)url;
- (void)wechatLogin;
- (void)facebookLogin;
- (void)lineLogin;
@property (nonatomic, copy) void (^loginSuccessBlock)(CAPSocialUser *socialUser);

@end
