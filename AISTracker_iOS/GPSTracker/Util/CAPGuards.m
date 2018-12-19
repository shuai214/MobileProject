//
//  CAPGuards.m
//  Neptu
//
//  Created by WeifengYao on 22/3/2018.
//  Copyright © 2018 capelabs. All rights reserved.
//

#import "CAPGuards.h"
#import "CAPValidators.h"
#import "CAPAlerts.h"
#import "CAPToast.h"

@implementation CAPGuards
+ (BOOL)assureEmail:(NSString *)email {
    BOOL result = NO;
    if(email == nil || email.length == 0) {
        [CAPToast toastError:NSLocalizedString(@"empty_email_error", nil)];
    } else if(email.length > 127 || ![CAPValidators validEmail:email]) {
        [CAPToast toastError:NSLocalizedString(@"invalid_email_error", nil)];
    } else {
        result = YES;
    }
    return result;
}

+ (BOOL)assurePhoneNumber:(nullable NSString *)phoneNumber {
    BOOL result = NO;
    if(phoneNumber == nil || phoneNumber.length == 0) {
        [CAPToast toastError:NSLocalizedString(@"empty_mobile_number_error", nil)];
    } else if(phoneNumber.length > 20 || ![CAPValidators validPhoneNumber:phoneNumber]) {
        [CAPToast toastError:NSLocalizedString(@"invalid_mobile_number_error", nil)];
    } else {
        result = YES;
    }
    return result;
}

+ (BOOL)assureCaptcha:(nullable NSString *)captcha {
    BOOL result = NO;
    if(captcha == nil || captcha.length == 0) {
        [CAPToast toastError:NSLocalizedString(@"empty_captcha_error", nil)];
    } else if(![CAPValidators validCaptcha:captcha]) {
        [CAPToast toastError:NSLocalizedString(@"invalid_captcha_error", nil)];
    } else {
        result = YES;
    }
    return result;
}

+ (BOOL)assureEnoughSpace:(NSUInteger)usageSize freeSize:(NSUInteger)freeSize {
    BOOL result = (freeSize >= usageSize);
    if(!result) {
        [CAPToast toastError:NSLocalizedString(@"device_no_enough_space_error",nil)];
    }
    return result;
}

+ (BOOL)assureEnoughPhoneSpace:(NSUInteger)size {
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error:&error];
    NSUInteger freePhoneSize = NSUIntegerMax;
    if (dictionary) {
        NSNumber *freeNumber = [dictionary objectForKey:NSFileSystemFreeSize];
        freePhoneSize = [freeNumber unsignedLongLongValue];
    } else {
        NSLog(@"ERROR: Obtaining phone storage info failed %@", error);
    }
    
    BOOL result = (freePhoneSize > (size + 64 * 1024 * 1024));
    if(!result) {
        [CAPAlerts alertError:NSLocalizedString(@"phone_no_enough_space_error", nil)];
    }
    return result;
}

@end
