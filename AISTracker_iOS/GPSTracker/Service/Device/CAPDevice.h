//
//  CAPDevice.h
//  GPSTracker
//
//  Created by user on 8/19/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPBaseJSON.h"
#import "CAPFootprint.h"
#import "CAPFileItem.h"
//@protocol NSString <NSObject>
//@end
//@protocol NSNumber <NSObject>
//@end
//@protocol CAPDeviceSettingEntry <NSObject>
//@end
//
//@interface CAPDeviceSettingEntry : CAPBaseJSON
//@property (nonatomic, copy) NSString *key;
//@property (nonatomic, copy) NSString *value;
//@end
//
//@interface CAPDeviceSetting : CAPBaseJSON
//@property (nonatomic, assign) BOOL autoBackupOn;
//@property (nonatomic, assign) NSInteger autoBackupInterval;
//@property (nonatomic, strong) NSArray <NSString> *autoBackupOptions;
//
//@property (nonatomic, strong) NSMutableArray <CAPDeviceSettingEntry> *modifiedDates;
//
//@property (nonatomic, assign) NSUInteger version;
//@end
//

static NSString* const kMasterRole = @"owner";

@protocol CAPDevice <NSObject>
@end
@protocol CAPDeviceSetting <NSObject>
@end
@interface CAPDeviceSetting : CAPBaseJSON
@property (nonatomic, strong) CAPFileItem *avatar;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *answerMode;
@property (nonatomic, assign) NSInteger reportFrequency;
@end

@interface CAPDevice : CAPBaseJSON
@property (nonatomic, copy) NSString *deviceID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSTimeInterval createdDate;
@property (nonatomic, assign) NSString *sos;
@property (nonatomic, assign) NSString *mobile;

@property (nonatomic, strong) CAPDeviceSetting *setting;
//@property (nonatomic, strong) CAPFootprint *footprint;
@property (nonatomic, assign, readonly) BOOL isMaster;
@end
