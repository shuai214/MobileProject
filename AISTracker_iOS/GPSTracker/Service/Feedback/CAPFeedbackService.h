//
//  CAPFeedbackService.h
//  GPSTracker
//
//  Created by WeifengYao on 7/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPBaseService.h"
#import "CAPFeedback.h"

@interface CAPFeedbackService : CAPBaseService
- (void)addFeedback:(CAPFeedback *)feedback reply:(CAPServiceReply)reply;
@end
