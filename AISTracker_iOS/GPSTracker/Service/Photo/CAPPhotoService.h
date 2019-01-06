//
//  CAPPhotoService.h
//  GPSTracker
//
//  Created by WeifengYao on 7/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPBaseService.h"

@interface CAPPhotoService : CAPBaseService
- (void)takingPicturesWithDeviceID:(NSString *)deviceID  Reply:(CAPServiceReply)reply;
- (void)getPhotoListDeviceID:(NSString *)deviceID reply:(CAPServiceReply)reply;

@end
