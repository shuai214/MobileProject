//
//  CAPFormats.m
//  Neptu
//
//  Created by WeifengYao on 22/3/2018.
//  Copyright © 2018 capelabs. All rights reserved.
//

#import "CAPFormats.h"

@implementation CAPFormats

+ (NSString *)formatSize:(CGFloat)size {
    if(size == 0) {
        return @"0.00 GB";
    } else if(size <= (1024*1024*0.01)) {
        return @"0.01 MB";
    } else if(size < 1024*1024*1024) {
        return [NSString stringWithFormat:@"%.2f MB", size/(1024*1024)];
    } else {
        return [NSString stringWithFormat:@"%.2f GB", size/(1024*1024*1024)];
    }
}

+ (NSString *)formatGBSize:(CGFloat)size {
    if(size == 0) {
    return @"0.00 GB";
    } else if(size <= (0.01*1024*1024*1024)) {
        return @"0.01 GB";
    } else {
        return [NSString stringWithFormat:@"%.2f GB", size/(1024*1024*1024)];
    }
}

+ (NSString *)formatSizePercentage:(CGFloat)usageSize totalSize:(CGFloat)totalSize {
    if(usageSize == 0.0) {
        return @"0.0%";
    } else {
        CGFloat percentage = usageSize*100.0/totalSize;
        if(percentage < 0.1) {
            return @"0.1%";
        } else {
            return [NSString stringWithFormat:@"%.1f%%", percentage];
        }
    }
}

+ (NSString *)formatDuration:(NSUInteger)duration {
    if(duration == 0) return @"";
    
    NSUInteger s = duration % 60;
    NSUInteger m = (duration % 3600)/60;
    NSUInteger h = MIN(duration / 3600, 99);
    
    if(h > 0) {
        return [NSString stringWithFormat:@"%d:%02d:%02d", (int)h, (int)m, (int)s];
    } else {
        return [NSString stringWithFormat:@"%d:%02d", (int)m, (int)s];
    }
}

+ (NSString *)formatDate1:(NSTimeInterval)secs {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:secs]];
}
@end
