//
//  CAPSession.m
//  GPSTracker
//
//  Created by user on 10/7/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPSession.h"
#import "CAPValidators.h"
#import "CAPStrings.h"

//static NSString* const kAutoBackupOn = @"auto_backup_on";
//static NSString* const kAutoBackupPeriod = @"auto_backup_period";
static NSString* const kTouchIDOn = @"touch_id_on";
static NSString* const kChargerPin = @"charger_pin";
static NSString* const kUserEmail = @"user_email";
static NSString* const kUserLogon = @"user_logon";

static NSString* const kAccessVaultTime = @"access_vault_time";

static CAPSession *_instance = NULL;

@interface CAPSession ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) CAPUser *user;
@end

@implementation CAPSession

- (id)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
//#if ENABLE_TEST_DATA
//    [self loadTestData];
//#endif
    //[self readUserConfiguration];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
//    
//    _autoBackupOn = [_userDefaults boolForKey:kAutoBackupOn];
//    _autoBackupPeriod = [_userDefaults integerForKey:kAutoBackupPeriod];

//    _chargerPin = [_userDefaults objectForKey:kChargerPin];
//    // || _chargerPin == nil || _chargerPin.length==0
//    if(_chargerPin == NULL) {
//        _chargerPin = nil;
//    }
//    _email = [_userDefaults objectForKey:kUserEmail];
//    // || _email == nil || _email.length==0
//    if(_email == NULL) {
//        _email = nil;
//    }
//    _logon = [_userDefaults boolForKey:kUserLogon];
//    
    //_accessVaultTime = [_userDefaults doubleForKey:kAccessVaultTime];
}

+ (instancetype)currentSession {
    return _instance;
}

//+ (instancetype)newSession:(NSInteger)sessionType {
//    _instance = [[CAPSession alloc] init];
//    return _instance;
//}

+ (instancetype)newSession:(CAPUser *)user {
    NSLog(@"[%@ newSession:]", [self class]);
    _instance = [[CAPSession alloc] init];
    if(_instance) {
        _instance.user = user;
        //[_instance readUserSetting];
        if(user == nil) {
            _instance.touchIDOn = NO;
            //_instance.accessVaultTime = 0;
            
        }
    }
    return _instance;
}

//- (void)readUserSetting {
//    if(self.user) {
//        _userDefaults = [NSUserDefaults standardUserDefaults];
//    }
//}

//- (void)resetCharger {
//    [_userDefaults removeObjectForKey:kChargerPin];
//    _chargerPin = nil;
//}

//- (BOOL)getAutoBackupOn {
//    return self.user.setting.autoBackupOn;
////    return [CAPDeviceHandler defaultHandler].setting.autoBackupOn;
//}
//
//- (NSInteger)getAutoBackupInterval {
//    return self.user.setting.autoBackupInterval;
////    return [CAPDeviceHandler defaultHandler].setting.autoBackupInterval;
//}
//
//- (NSArray<NSString *> *)getAutoBackupOptions {
//    return self.user.setting.autoBackupOptions;
////    return [CAPDeviceHandler defaultHandler].setting.autoBackupOptions;
//}
//
//- (NSString *)getAutoBackupPhone {
//    return self.user.setting.autoBackupPhone;
//}

//- (BOOL)getTouchIDOn {
//    return self.user.setting.touchIDOn;
//}

- (BOOL)getHasBindedDevice {
    return (self.user.devices && self.user.devices.count > 0);
}

- (NSString *)getUsername {
    return (self.user.account ? self.user.account.username : nil);
}

- (NSString *)getMobile {
    return (self.user.info ? self.user.info.mobile : nil);
}

- (NSString *)getUserLabel {
    //return (self.user.info ? self.user.info.name : nil);
    return ([CAPStrings isNotEmpty:self.user.profile.firstName] ? self.user.profile.firstName : nil);
}

- (void)setDeviceEmail:(NSString *)email withDeviceID:(NSString *)deviceID {
    if([CAPValidators validEmail:email]) {
        [self.userDefaults setObject:email forKey:[NSString stringWithFormat:@"%@_%@", deviceID, kUserEmail]];
    } else {
        [self resetDeviceEmail:deviceID];
    }
}

- (void)resetDeviceEmail:(NSString *)deviceID {
    [self.userDefaults removeObjectForKey:[NSString stringWithFormat:@"%@_%@", deviceID, kUserEmail]];
}

- (NSURL *)getAvatarURL {
    if([CAPStrings isNotEmpty:self.user.profile.avatarPath] || [CAPStrings isNotEmpty:self.user.profile.avatarBaseUrl]) {
        if([CAPStrings isEmpty:self.user.profile.avatarPath]) {
            return [NSURL URLWithString:self.user.profile.avatarBaseUrl];
        } else if([CAPStrings isEmpty:self.user.profile.avatarBaseUrl]) {
            return [NSURL URLWithString:self.user.profile.avatarPath];
        } else {
            NSURL *avatarURL = [NSURL URLWithString:self.user.profile.avatarBaseUrl];
            return [avatarURL URLByAppendingPathComponent:self.user.profile.avatarPath];
        }
    }
    return nil;
}

- (BOOL)getLogon {
    return (self.user != nil);
}

- (NSTimeInterval)getLastSignedInTime {
    return self.user.lastLoggedAt;
}

//- (NSTimeInterval)getAccessVaultTime {
//    return self.user.setting.accessVaultTime;
//}
//- (void)setAccessVaultTime:(NSTimeInterval)time {
//    if(_accessVaultTime != time) {
//        _accessVaultTime = time;
//        [_userDefaults setDouble:time forKey:kAccessVaultTime];
//    }
//}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject:@(_sessionType) forKey:@"_sessionType"];
//    [aCoder encodeObject:_username forKey:@"_username"];
//    [aCoder encodeObject:_password forKey:@"_password"];
//    [aCoder encodeObject:_lhAuthData forKey:@"_lhAuthData"];
//    [aCoder encodeObject:_sdnAuthData forKey:@"_sdnAuthData"];
//    [aCoder encodeObject:_pin forKey:@"_pin"];
//    [aCoder encodeObject:@(_persistentLogin) forKey:@"_persistentLogin"];
//    [aCoder encodeObject:@(_touchID) forKey:@"_touchID"];
//    [aCoder encodeObject:_lastLoginDate forKey:@"_lastLoginDate"];
//    
//    [aCoder encodeObject:_userProfileModel forKey:@"_userProfileModel"];
//    [aCoder encodeObject:_messageCenterModel forKey:@"_messageCenterModel"];
//    [aCoder encodeObject:_vehicleDataModel forKey:@"_vehicleDataModel"];
//    [aCoder encodeObject:_locatorModel forKey:@"_locatorModel"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
//    _sessionType = [[aDecoder decodeObjectForKey:@"_sessionType"] integerValue];
//    _username = [aDecoder decodeObjectForKey:@"_username"];
//    _password = [aDecoder decodeObjectForKey:@"_password"];
//    _lhAuthData = [aDecoder decodeObjectForKey:@"_lhAuthData"];
//    _sdnAuthData = [aDecoder decodeObjectForKey:@"_sdnAuthData"];
//    _pin = [aDecoder decodeObjectForKey:@"_pin"];
//    _persistentLogin = [[aDecoder decodeObjectForKey:@"_persistentLogin"] boolValue];
//    _touchID = [[aDecoder decodeObjectForKey:@"_touchID"] boolValue];
//    _lastLoginDate = [aDecoder decodeObjectForKey:@"_lastLoginDate"];
//   
//    _userProfileModel = [aDecoder decodeObjectForKey:@"_userProfileModel"];
//    _messageCenterModel = [aDecoder decodeObjectForKey:@"_messageCenterModel"];
//    _vehicleDataModel = [aDecoder decodeObjectForKey:@"_vehicleDataModel"];
//    _locatorModel = [aDecoder decodeObjectForKey:@"_locatorModel"];
//    
//    [self setup];
    
    return self;
}

#pragma mark - Persistent data
+ (NSString*)dataFileName:(NSString*)username{
    return [NSString stringWithFormat:@"userSessionModelData_%@.dat", @"username_id"];
}

- (NSString*)dataFileName:(NSString*)username{
    return [self.class dataFileName:username];
}

- (void)store {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* filePath = [documentsDirectory stringByAppendingPathComponent:[self dataFileName:@"username"]];
    
    NSMutableData* data = [NSMutableData data];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:@"root"];
    [archiver finishEncoding];
    
    BOOL ok = [data writeToFile:filePath atomically:NO];
    if (ok) {
        NSLog(@"[*]Write %@ Successed.", [filePath lastPathComponent]);
    }
    else {
        NSLog(@"[*]Write %@ Failed.", [filePath lastPathComponent]);
    }
}
@end
