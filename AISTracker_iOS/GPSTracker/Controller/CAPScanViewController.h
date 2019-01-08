//
//  CAPScanViewController.h
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPBaseViewController.h"

@interface CAPScanViewController : CAPBaseViewController

@property (nonatomic, copy) void (^ScanSuccessBlock)(NSString *successStr);
@property (nonatomic, copy) void (^bindSuccessBlock)(NSString *successStr);

@end
