//
//  MQTTInfo.m
//  GPSTracker
//
//  Created by WeifengYao on 30/10/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "MQTTInfo.h"

@implementation NeighborInfo
@end

@implementation StationInfo
@end

@implementation WifiInfo
@end

@implementation MQTTInfo
//+ (JSONKeyMapper *)keyMapper {
//    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
//                                                                  @"command": @"cmd"
//                                                                  }];
//}


- (id)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    NSLog(@"[%@ setup]", [self class]);
    self.latitude = -10000;
    self.longitude = -10000;
}

- (BOOL)isSuccess {
    return (self.statusCode == 200 || self.statusCode == 0);
}

- (BOOL)assureGPSInfo {
    return (self.infoType == MQTTInfoTypeResult && [@"GPS" isEqualToString:self.command]);
}

- (BOOL)assurePhotoInfo {
    return (self.infoType == MQTTInfoTypeResult && [@"PHOTO" isEqualToString:self.command]);
}

- (BOOL)assureFrequencyInfo {
    return (self.infoType == MQTTInfoTypeResult && [@"UPLOAD" isEqualToString:self.command]);
}

- (BOOL)assureVersionInfo {
    return (self.infoType == MQTTInfoTypeResult && [@"VERNO" isEqualToString:self.command]);
}

- (BOOL)assureSOSInfo {
    return (self.infoType == MQTTInfoTypeNotify && [self.status hasSuffix:@"10000"]);
}

- (BOOL)assureDeleteGuardianInfo {
    return (self.infoType == MQTTInfoTypeResult && [@"REMOVED" isEqualToString:self.command]);
}

- (BOOL)assureGuardianQuitInfo {
    return (self.infoType == MQTTInfoTypeResult && [@"UNBIND" isEqualToString:self.command]);
}

- (BOOL)assureStatusInfo {
    return (self.infoType == MQTTInfoTypeResult && [@"STATUS" isEqualToString:self.command]);
}

- (BOOL)assureBasicInfo {
    return (self.infoType == MQTTInfoTypeBasic);
}

- (BOOL)assureBatlevelValue {
    return (self.batlevel > 0);
}

- (BOOL)assureVerValue {
    return (self.ver && self.ver.length > 0);
}

- (BOOL)assureLatLngValue {
    return (self.latitude >= -90 && self.longitude >= -180);
}

@end
