//
//  CAPReadUserProfileResponse.h
//  GPSTracker
//
//  Created by WeifengYao on 13/2/2017.
//  Copyright © 2017 capelabs. All rights reserved.
//

#import "CAPResponse.h"
#import "CAPUser.h"

@interface CAPFetchUserProfileResponse : CAPResponse
@property (nonatomic, strong) CAPUser *result;
@end
