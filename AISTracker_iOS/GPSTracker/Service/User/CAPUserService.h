//
//  CAPUserService.h
//  GPSTracker
//
//  Created by user on 8/18/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPBaseService.h"
#import "CAPUser.h"
#import "CAPSocialUser.h"

@interface CAPUserService : CAPBaseService
//+ (instancetype)defaultService;
//- (void)socialLogin:(CAPSocialUser *)user reply:(CAPServiceReply)reply;
- (void)socialLogin:(NSDictionary *)user reply:(CAPServiceReply)reply;
- (void)fetchProfile:(CAPServiceReply)reply;
- (void)signOut:(CAPServiceResponse)reply;

- (void)checkRemoteSetting:(CAPServiceReply)reply;
@end
