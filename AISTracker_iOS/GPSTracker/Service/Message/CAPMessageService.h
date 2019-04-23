//
//  CAPMessageService.h
//  GPSTracker
//
//  Created by WeifengYao on 7/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPBaseService.h"

@interface CAPMessageService : CAPBaseService
- (void)updatePushToken:(NSString *)token reply:(CAPServiceReply)reply;
- (void)deletePushTokenReply:(CAPServiceReply)reply;

@end
