//
//  CAPDeviceCenter.m
//  GPSTracker
//
//  Created by WeifengYao on 3/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPDeviceCenter.h"
#import "CAPDeviceService.h"

@interface CAPDeviceCenter ()
@property (nonatomic, strong, readwrite) CAPDevice *device;
@property (nonatomic, strong) NSMutableDictionary *devices;
@property (nonatomic, strong) CAPDeviceService *deviceService;
@end

@implementation CAPDeviceCenter
+ (instancetype)center {
    static id instance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    NSLog(@"[%@ setup]", [self class]);
    self.devices = [NSMutableDictionary dictionaryWithCapacity:2];
    self.deviceService = [[CAPDeviceService alloc] init];
}

- (void)changeDevice:(CAPDevice *)device {
    if([self findDevice:device.deviceID]) {
        self.device = device;
    } else {
        NSLog(@"ERROR: change device with no such device ID %@", device.deviceID);
    }
}

- (CAPDevice *)findDevice:(NSString *)deviceID {
    return [self.devices objectForKey:deviceID];
}

- (NSArray *)allDevices {
    return self.devices.allValues;
}

- (NSArray *)allSortedDevices {
    NSArray *devices = self.devices.allValues;
    [devices sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        CAPDevice *d1 = obj1;
        CAPDevice *d2 = obj2;
        if(d1.isMaster && !d2.isMaster) return NSOrderedAscending;
        if(!d1.isMaster && d2.isMaster) return NSOrderedDescending;
        if(d1.createdDate < d2.createdDate) {
            return NSOrderedAscending;
        } else if(d1.createdDate > d2.createdDate) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    return devices;
}

- (NSUInteger)count {
    return self.devices.allKeys.count;
}

- (void)fetchDevice {
    [self.deviceService fetchDevice:^(id response) {
        
    }];
}

@end
