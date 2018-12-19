//
//  CAPGuards.h
//  Neptu
//
//  Created by WeifengYao on 22/3/2018.
//  Copyright © 2018 capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAPGuards : NSObject
+ (BOOL)assureEmail:(nullable NSString *)email;
+ (BOOL)assurePhoneNumber:(nullable NSString *)phoneNumber;
+ (BOOL)assureCaptcha:(nullable NSString *)captcha;
+ (BOOL)assureEnoughPhoneSpace:(NSUInteger)size;
@end
