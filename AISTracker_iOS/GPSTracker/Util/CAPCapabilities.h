//
//  CAPCapabilities.h
//  GPSTracker
//
//  Created by Weifeng on 11/8/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CAPAccessAuthorizedCallback)();

@interface CAPCapabilities : NSObject
+ (void)assureCameraAccess:(CAPAccessAuthorizedCallback)callback;
+ (void)assurePhotoAccess:(CAPAccessAuthorizedCallback)callback;
+ (void)assureAudioAccess:(CAPAccessAuthorizedCallback)callback;
+ (void)assureContactAccess:(CAPAccessAuthorizedCallback)callback;
+ (void)assureLocationAccess:(CAPAccessAuthorizedCallback)callback;
+ (void)assurePushAccess:(CAPAccessAuthorizedCallback)callback;

+ (BOOL)hasCameraAccess;
+ (BOOL)hasPhotoAccess;
+ (BOOL)hasAudioAccess;
+ (BOOL)hasContactAccess;
+ (BOOL)hasLocationAccess;
@end
