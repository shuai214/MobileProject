//
//  CAPValidators.m
//  GPSTracker
//
//  Created by WeifengYao on 3/2/2017.
//  Copyright © 2017 capelabs. All rights reserved.
//

#import "CAPValidators.h"

@implementation CAPValidators
+ (BOOL)validEmail:(NSString *)email {
    static NSString* regEmail = @"^([a-zA-Z0-9_\\.\\-])+\\@(([a-zA-Z0-9\\-])+\\.)+([a-zA-Z0-9]{2,4})+$";
    NSPredicate* predicateEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEmail];
    
    return [predicateEmail evaluateWithObject:email];
}

+ (BOOL)validPhoneNumber:(NSString *)phoneNumber {
    NSString *regPhoneNumber = @"^\\s*\\+?\\s*(\\(\\s*\\d+\\s*\\)|\\d+)(\\s*-?\\s*(\\(\\s*\\d+\\s*\\)|\\s*\\d+\\s*))*\\s*$";
    NSPredicate* predicatePhoneNumber = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regPhoneNumber];
    
    return [predicatePhoneNumber evaluateWithObject:phoneNumber];
}

+ (BOOL)validCaptcha:(NSString *)captcha {
    NSString* regCaptcha = @"^\\d{6}$";
    NSPredicate* predicateCaptcha = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regCaptcha];
    
    return [predicateCaptcha evaluateWithObject:captcha];
}
@end
