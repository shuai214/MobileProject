//
//  CAPApplication.m
//  Ruyi
//
//  Created by WeifengYao on 3/2/2017.
//  Copyright © 2017 capelabs. All rights reserved.
//

#import "CAPApplication.h"
//#import "CAPNotifications.h"

//static const NSTimeInterval  kIdleTimeInterval = 30*60;  // 3 minutes

@interface CAPApplication ()
//@property (nonatomic, strong) NSTimer* idleTimer;
@end

@implementation CAPApplication

//- (void)sendEvent:(UIEvent *)event {
//    [super sendEvent:event];
//    if (!self.idleTimer) {
//        [self resetIdleTimer];
//    }
//    NSSet *allTouches = [event allTouches];
//    if ([allTouches count]>0) {
//        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
//        if (phase == UITouchPhaseBegan) {
//            [self resetIdleTimer];
//        }
//    }
//}
//
//
//- (void)resetIdleTimer {
//    if (self.idleTimer) {
//        [self.idleTimer invalidate];
//    }
//
//    self.idleTimer = [NSTimer scheduledTimerWithTimeInterval:kIdleTimeInterval
//                                                      target:self
//                                                    selector:@selector(onIdleTimerTimeout:)
//                                                    userInfo:nil
//                                                     repeats:NO];
//}
//
//- (void)onIdleTimerTimeout:(NSTimer*)timer {
//    NSLog(@"EVENT: %s", __FUNCTION__);
//    [CAPNotifications notify:kNotificationIdleTimeout object:nil];
//    [self resetIdleTimer];
//}
@end
