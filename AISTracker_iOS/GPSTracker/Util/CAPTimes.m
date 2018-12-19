//
//  CAPTimes.m
//  GPSTracker
//
//  Created by WeifengYao on 19/1/2017.
//  Copyright © 2017 capelabs. All rights reserved.
//

#import "CAPTimes.h"

static NSTimeInterval _elapsedInterval;
static NSTimeInterval _watchInterval;

@implementation CAPTimes
+ (NSTimeInterval)startTimer {
    _elapsedInterval = [[NSDate date] timeIntervalSince1970];
    return _elapsedInterval;
}

+ (NSTimeInterval)elapsedTimeInterval {
    NSTimeInterval interval = _elapsedInterval;
    _elapsedInterval = [[NSDate date] timeIntervalSince1970];
    return _elapsedInterval - interval;
}

+ (void)logElapsedTime:(NSString *)tag {
    NSTimeInterval interval = _elapsedInterval;
    _elapsedInterval = [[NSDate date] timeIntervalSince1970];
    NSLog(@"%@: %.5f", tag,  _elapsedInterval - interval);
}

+ (NSTimeInterval)startWatch {
    _watchInterval = [[NSDate date] timeIntervalSince1970];
    return _watchInterval;
}

+ (NSTimeInterval)peekWatch {
    NSTimeInterval interval = _watchInterval;
    _watchInterval = [[NSDate date] timeIntervalSince1970];
    return _watchInterval - interval;
}

+ (NSString *)timeAgo:(NSTimeInterval)interval {
    if(interval <= 1.0) {
        return NSLocalizedString(@"unknown", nil);
    }
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    double deltaSeconds = now - interval;
    double deltaMinutes = deltaSeconds / 60.0f;
    
    int minutes;
    
    if(deltaSeconds < 5) {
        return NSLocalizedString(@"just_now", nil);
    } else if(deltaSeconds < 60) {
        return [NSString stringWithFormat:NSLocalizedString(@"seconds_ago", nil), deltaSeconds];
    } else if(deltaSeconds < 120) {
        return NSLocalizedString(@"a_minute_ago", nil);
    } else if (deltaMinutes < 60) {
        return [NSString stringWithFormat:NSLocalizedString(@"minutes_ago", nil), deltaMinutes];
    } else if (deltaMinutes < 120) {
        return NSLocalizedString(@"an_hour_ago", nil);
    } else if (deltaMinutes < (24 * 60)) {
        minutes = (int)floor(deltaMinutes/60);
        return [NSString stringWithFormat:NSLocalizedString(@"hours_ago", nil), minutes];
    } else if (deltaMinutes < (24 * 60 * 2)) {
        return NSLocalizedString(@"yesterday", nil);
    } else if (deltaMinutes < (24 * 60 * 7)) {
        minutes = (int)floor(deltaMinutes/(60 * 24));
        return [NSString stringWithFormat:NSLocalizedString(@"days_ago", nil), minutes];
    } else if (deltaMinutes < (24 * 60 * 14)) {
        return NSLocalizedString(@"last_week", nil);
    } else if (deltaMinutes < (24 * 60 * 31)) {
        minutes = (int)floor(deltaMinutes/(60 * 24 * 7));
        return [NSString stringWithFormat:NSLocalizedString(@"weeks_ago", nil), minutes];
    } else if (deltaMinutes < (24 * 60 * 61)) {
        return NSLocalizedString(@"last_month", nil);
    } else if (deltaMinutes < (24 * 60 * 365.25)) {
        minutes = (int)floor(deltaMinutes/(60 * 24 * 30));
        return [NSString stringWithFormat:NSLocalizedString(@"months_ago", nil), minutes];
    } else if (deltaMinutes < (24 * 60 * 731)) {
        return NSLocalizedString(@"last_year", nil);
    }
    
    minutes = (int)floor(deltaMinutes/(60 * 24 * 365));
    return [NSString stringWithFormat:NSLocalizedString(@"years_ago", nil), minutes];
}

+ (NSString *)weekAgo:(NSTimeInterval)interval {
    if(interval <= 0) {
        return NSLocalizedString(@"unknown", nil);
    }
    
    NSUInteger secondsPerDay = 60*60*24;
    NSUInteger intervalDays = ((NSUInteger)interval) / secondsPerDay;
    NSUInteger nowDays = ((NSUInteger)[[NSDate date] timeIntervalSince1970]) % secondsPerDay;
    NSUInteger days = nowDays - intervalDays;
    if(days == 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval]];
    } else if (days == 1) {
        return NSLocalizedString(@"yesterday", nil);
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEEE"];
        return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval]];
    }
}

+ (NSString *)formatDate:(NSTimeInterval)interval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *dateFormat= [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    return [dateFormat stringFromDate:date];
}

+ (NSString *)formatTime:(NSTimeInterval)interval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm"];
    return [dateFormat stringFromDate:date];
}

+ (NSString *)formatDateTime:(NSTimeInterval)interval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *dateFormat= [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormat stringFromDate:date];
}


+ (void)test {
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceNow];
    NSTimeInterval interval2 = [[NSDate date] timeIntervalSince1970];
    NSLog(@"%f %f", interval, interval2);
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval2];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"HH:mm"];
    NSLog(@"%@    %@", [formatter1 stringFromDate:date], [formatter2 stringFromDate:date]);
}
@end
