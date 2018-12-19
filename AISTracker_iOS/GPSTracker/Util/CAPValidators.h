//
//  CAPValidators.h
//  GPSTracker
//
//  Created by WeifengYao on 3/2/2017.
//  Copyright © 2017 capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAPValidators : NSObject
+ (BOOL)validEmail:(NSString *)email;
+ (BOOL)validPhoneNumber:(NSString *)phoneNumber;
+ (BOOL)validCaptcha:(NSString *)captcha;
@end
