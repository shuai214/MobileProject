//
//  CAPFencePresenter.h
//  GPSTracker
//
//  Created by WeifengYao on 3/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPBasePresenter.h"
#import <CoreLocation/CoreLocation.h>
#import "CAPDevice.h"
typedef NS_ENUM(NSUInteger, FenceType) {
    FenceTypeUnknow= 0,
    FenceTypeOutcome,
    FenceTypeIncome
};
@interface CAPFencePresenter : CAPBasePresenter
+ (instancetype)sharedCheckFence;
- (void)getFenceList:(CAPDevice *)device deviceLocal:(CLLocationCoordinate2D)coordinate;
@end
