//
//  NSString+formateTime.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2018/12/30.
//  Copyright © 2018年 Capelabs. All rights reserved.
//

#import "NSString+formateTime.h"

@implementation NSString (formateTime)
+ (NSString *)dateFormateWithTimeInterval:(NSTimeInterval)timeInterval{
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    = timeInterval;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}
@end
