//
//  CAPSocialLoginResponse.h
//  GPSTracker
//
//  Created by WeifengYao on 11/4/2017.
//  Copyright © 2017 capelabs. All rights reserved.
//

#import "CAPResponse.h"
#import "CAPUser.h"

@interface CAPSocialLoginResponse : CAPResponse
@property (nonatomic, strong) CAPUser *result;
@end
