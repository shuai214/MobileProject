//
//  AppConfig.h
//  GPSTracker
//
//  Created by user on 10/15/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppConfig : NSObject
@property (nonatomic, readonly, strong) UIColor *appBackgroundColor;
@property (nonatomic, readonly, assign) CGFloat tableSectionHeight;
@property (nonatomic, readonly, assign) CGFloat actionBarHeight;

@property (nonatomic, readonly, assign) CGFloat screenWidth;
@property (nonatomic, readonly, assign) CGFloat screenHeight;
@property (nonatomic, readonly, assign) CGFloat resolutionWidth;
@property (nonatomic, readonly, assign) CGFloat resolutionHeight;
@property (nonatomic, readonly, assign) NSUInteger thumbWidth;
@property (nonatomic, readonly, assign) NSUInteger thumbHeight;

@property (nonatomic, readonly, strong) UIImage *defaultPhotoImage;
@property (nonatomic, readonly, strong) UIImage *defaultVideoImage;

@property (nonatomic, readonly, copy) NSString *appStoreLink;
@property (nonatomic, readonly, copy) NSString *rootURLString;
@property (nonatomic, readonly, copy) NSString *avatarBaseUrl;
@property (nonatomic, readonly, copy) NSString *google_api_key;
@property (nonatomic, readonly, assign) BOOL isBuild;
@property (nonatomic, readonly, assign) BOOL isRelease;
@property (nonatomic, readonly, assign) BOOL isDebug;
@property (nonatomic, readonly, assign) BOOL isDev;
@property (nonatomic, readonly, assign) BOOL cacheOff;
@property (nonatomic, readonly, assign) BOOL iCloudBackupOn;
@property (nonatomic, readonly, assign) BOOL isBurnAfterBackup;
@property (nonatomic, readonly, assign) BOOL isBurnAfterRestore;
@property (nonatomic, assign) BOOL isCheckRepeatedAssets;
@property (nonatomic, readonly, assign) NSTimeInterval noteCollectionTime;

@property (nonatomic, readonly, strong) NSString *actionExtensionUserGroupName;

@property (nonatomic, assign, getter=getChargerTransportSecurity, setter=setChargerTransportSecurity:) BOOL chargerTransportSecurity;

- (void)setClientType:(NSInteger)clientType;
- (void)setBurnAfterBackup:(BOOL)isBurn;
- (void)setBurnAfterRestore:(BOOL)isBurn;
- (void)setICloudBackupOn:(BOOL)isOn;
- (void)setCacheOff:(BOOL)isOff;
- (void)setNoteCollectionTime:(NSTimeInterval)time;

@end

extern AppConfig* gCfg;
