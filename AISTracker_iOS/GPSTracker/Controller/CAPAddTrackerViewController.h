//
//  CAPAddTrackerViewController.h
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPBaseViewController.h"

@interface CAPAddTrackerViewController : CAPBaseViewController
@property (nonatomic, copy) void (^inputSuccessBlock)(NSString *successStr);

@end
