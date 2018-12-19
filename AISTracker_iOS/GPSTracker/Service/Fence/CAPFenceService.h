//
//  CAPFenceService.h
//  GPSTracker
//
//  Created by WeifengYao on 7/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPBaseService.h"
#import "CAPFence.h"

@interface CAPFenceService : CAPBaseService
- (void)fetchFence:(NSString *)deviceID reply:(CAPServiceReply)reply;
- (void)addFence:(CAPFence *)fence reply:(CAPServiceReply)reply;
- (void)editFence:(CAPFence *)fence reply:(CAPServiceReply)reply;
- (void)deleteFence:(NSString *)fenceID reply:(CAPServiceReply)reply;
@end
