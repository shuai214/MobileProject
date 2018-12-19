//
//  CAPTimes.h
//  GPSTracker
//
//  Created by WeifengYao on 19/1/2017.
//  Copyright © 2017 capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAPTimes : NSObject
+ (NSTimeInterval)startTimer;
+ (NSTimeInterval)elapsedTimeInterval;
+ (void)logElapsedTime:(NSString *)tag;

+ (NSTimeInterval)startWatch;
+ (NSTimeInterval)peekWatch;

+ (NSString *)timeAgo:(NSTimeInterval)interval;
+ (NSString *)weekAgo:(NSTimeInterval)interval;

+ (NSString *)formatDate:(NSTimeInterval)interval;
+ (NSString *)formatTime:(NSTimeInterval)interval;
+ (NSString *)formatDateTime:(NSTimeInterval)interval;
@end
