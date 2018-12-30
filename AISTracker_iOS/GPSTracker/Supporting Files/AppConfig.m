//
//  AppConfig.m
//  GPSTracker
//
//  Created by user on 10/15/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "AppConfig.h"
#import "CAPSession.h"
#import "CAPColors.h"

static NSString* const kChargerTransportSecurity = @"is_charger_transport_security";

AppConfig* gCfg = nil;

@implementation AppConfig

- (id)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    NSLog(@"[%@ setup]", [self class]);
    _isDev = YES;
    
    NSUserDefaults  *user =[NSUserDefaults standardUserDefaults];

    _isBuild = YES;
    _isRelease = !_isBuild;
    
    NSString *burnAfterBackup = [user objectForKey:@"is_burn_after_backup"];
    _isBurnAfterBackup = burnAfterBackup && [burnAfterBackup isEqualToString:[CAPSession currentSession].userID];
    
    NSString *iCloudBackup = [user objectForKey:@"is_iCloud_backup_on"];
    _iCloudBackupOn = iCloudBackup && [iCloudBackup isEqualToString:[CAPSession currentSession].userID];
    
    _isBurnAfterRestore = [user boolForKey:@"is_burn_after_restore"];
    _cacheOff = [user boolForKey:@"is_cache_off"];
    _noteCollectionTime = [user doubleForKey:@"note_collection_time"];
    
    _tableSectionHeight = 30.0;//20.0;
    _actionBarHeight = 60;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _resolutionWidth = _screenWidth * [UIScreen mainScreen].scale;
    _resolutionHeight = _screenHeight * [UIScreen mainScreen].scale;
    _thumbWidth = 400;
    _thumbHeight = _thumbWidth;
    _appBackgroundColor = [CAPColors gray1];
    _defaultPhotoImage = [UIImage imageNamed:@"photo_default"];
    _defaultVideoImage = [UIImage imageNamed:@"video_default"];
    
    _actionExtensionUserGroupName = (_isBuild ? @"group.com.capelabs.neptu10" : @"group.com.capelabs.neptu10");
    
    _appStoreLink = @"https://itunes.apple.com/cn/app/data-steward/id1316811650?mt=8";
//    _rootURLString = (_isBuild ? @"https://GPSTracker.capelabs.net/GPSTracker/v1/" : @"https://GPSTracker.capelabs.cn/GPSTracker/v1/");
//    _rootURLString = @"https://api.kvtel.com/smartiot/v1/";
    _rootURLString = @"https://iot.capelabs.net/trueiot/v1/";
}

- (void)setBurnAfterBackup:(BOOL)isBurn {
    if(_isBurnAfterBackup != isBurn) {
        _isBurnAfterBackup = isBurn;
        NSUserDefaults  *user =[NSUserDefaults standardUserDefaults];
        [user setObject:[CAPSession currentSession].userID forKey:@"is_burn_after_backup"];
    }
}

- (void)setBurnAfterRestore:(BOOL)isBurn {
    if(_isBurnAfterRestore != isBurn) {
        _isBurnAfterRestore = isBurn;
        NSUserDefaults  *user =[NSUserDefaults standardUserDefaults];
        [user setBool:_isBurnAfterRestore forKey:@"is_burn_after_restore"];
    }
}

- (void)setICloudBackupOn:(BOOL)isOn {
    if(_iCloudBackupOn != isOn) {
        _iCloudBackupOn = isOn;
        NSUserDefaults  *user =[NSUserDefaults standardUserDefaults];
        [user setObject:[CAPSession currentSession].userID forKey:@"is_iCloud_backup_on"];
    }
}

- (void)setCacheOff:(BOOL)isOff {
    if(_cacheOff != isOff) {
        _cacheOff = isOff;
        NSUserDefaults  *user =[NSUserDefaults standardUserDefaults];
        [user setBool:_cacheOff forKey:@"is_cache_off"];
    }
}

- (void)setNoteCollectionTime:(NSTimeInterval)time {
    if(_noteCollectionTime != time) {
        _noteCollectionTime = time;
        NSUserDefaults  *user =[NSUserDefaults standardUserDefaults];
        [user setBool:_noteCollectionTime forKey:@"note_collection_time"];
    }
}

- (void)setChargerTransportSecurity:(BOOL)isOn {
    [[NSUserDefaults standardUserDefaults] setBool:isOn forKey:kChargerTransportSecurity];
}

- (BOOL)getChargerTransportSecurity {
    return YES;
    //return [[NSUserDefaults standardUserDefaults] boolForKey:kChargerTransportSecurity];
}

@end
