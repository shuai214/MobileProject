//
//  CAPFence.h
//  GPSTracker
//
//  Created by WeifengYao on 7/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPBaseJSON.h"

@interface CAPFence : CAPBaseJSON
@property (nonatomic, copy) NSString *fenceID;
@property (nonatomic, copy) NSString *deviceID;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@property (nonatomic, copy) NSString *site;
@property (nonatomic, copy) NSString *building;
@property (nonatomic, copy) NSString *address;

@property (nonatomic, assign) NSInteger range;
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSTimeInterval createdDate;
@property (nonatomic, assign) NSTimeInterval updatedDate;

@end
