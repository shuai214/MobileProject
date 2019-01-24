//
//  CAPEditNameViewController.h
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPBaseViewController.h"
#import "CAPUser.h"
#import "CAPDevice.h"
@interface CAPEditNameViewController : CAPBaseViewController
@property (strong, nonatomic) NSURL *avatarURL;
@property (strong, nonatomic) NSString *defaultName;
@property (assign, nonatomic) BOOL isUser;
@property (strong, nonatomic) CAPUser *capUser;
@property (strong, nonatomic) CAPDevice *capDevice;
@property (nonatomic , copy ) void (^updateSuccessBlock)(id cap);

@end
