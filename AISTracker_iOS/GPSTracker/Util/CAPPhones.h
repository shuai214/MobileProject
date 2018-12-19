//
//  CAPPhones.h
//  GPSTracker
//
//  Created by WeifengYao on 27/2/2017.
//  Copyright © 2017 capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAPPhones : NSObject
+ (NSString *)phoneModel;  // e.g. @"iPhone", @"iPod touch"
+ (NSString *)phoneName; // e.g. "My iPhone"
+ (NSString *)phoneType; // e.g. "iPad4,4"   =>   "iPad Mini 2G"
+ (NSString *)parsePhoneType:(NSString *)type;
+ (NSString *)systemName; // e.g. @"iOS"
+ (NSString *)systemVersion; // e.g. @"4.0"

+ (BOOL)isiPhoneX;
+ (BOOL)isChineseLanguage;

+ (unsigned long long)totalPhoneSize;
+ (unsigned long long)freePhoneSize;

+ (void)call:(NSString *)phoneNumber;
+ (void)mailto:(NSString *)email;

+ (NSString *)getUUIDString;

@end
