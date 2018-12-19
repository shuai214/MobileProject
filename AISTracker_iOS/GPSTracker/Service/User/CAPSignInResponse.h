//
//  CAPSignInResponse.h
//  GPSTracker
//
//  Created by user on 8/18/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPResponse.h"
#import "CAPDevice.h"
#import "CAPUser.h"

@interface CAPSignInResponse : CAPResponse
@property (nonatomic, strong) CAPUser *result;
//@property (nonatomic, strong) NSArray<CAPDevice> *devices;
//@property (nonatomic, strong) CAPUserInfo *info;
//@property (nonatomic, strong) CAPUserOAuth *oauth;
//@property (nonatomic, strong) CAPUserProfile *profile;
@end
