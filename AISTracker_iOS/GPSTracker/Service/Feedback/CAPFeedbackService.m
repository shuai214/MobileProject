//
//  CAPFeedbackService.m
//  GPSTracker
//
//  Created by WeifengYao on 7/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPFeedbackService.h"
#import "CAPResponse.h"

@implementation CAPFeedbackService
- (void)addFeedback:(CAPFeedback *)feedback reply:(CAPServiceReply)reply {
    NSDictionary *params = @{
                             @"content": feedback.content,
                             @"contact": feedback.contact
                             };
    CAPHttpRequest *request = [self buildRequest:@"Account/Feedback" method:@"POST" parameters:params];
    [self sendRequest:request reply:^(CAPHttpResponse *response) {
        reply([CAPResponse responseWithHttpResponse:response]);
    }];
}
@end
