//
//  CAPNotifications.h
//  GPSTracker
//
//  Created by WeifengYao on 19/1/2017.
//  Copyright © 2017 capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* _Nullable const kNotificationLogin = @"cap.notification.login";
static NSString* _Nullable const kNotificationLogout = @"cap.notification.logout";
static NSString* _Nullable const kNotificationAccountExpired = @"cap.notification.account.expired";
static NSString* _Nullable const kNotificationWechatLogin = @"cap.notification.wechat.login";

static NSString* _Nullable const kNotificationUserProfileChange = @"cap.notification.user.profile.change";
static NSString* _Nullable const kNotificationLanguageChange = @"cap.notification.language.change";

static NSString* _Nullable const kNotificationDeviceCountChange = @"cap.notification.device.count.change";
static NSString* _Nullable const kNotificationDeviceInfoChange = @"cap.notification.device.info.change";
static NSString* _Nullable const kNotificationDeviceSettingChange = @"cap.notification.device.setting.change";

static NSString* _Nullable const kNotificationPhotoCountChange = @"cap.notification.photo.count.change";

static NSString* _Nullable const kNotificationMessageCountChange = @"cap.notification.message.count.change";

//static NSString* _Nullable const kNotificationSOS = @"cap.notification.sos";
//static NSString* _Nullable const kNotificationGPSChange = @"cap.notification.gps.change";

@interface CAPNotifications : NSObject

+ (void)addObserver:(id _Nonnull)observer selector:(SEL _Nullable )aSelector name:(nullable NSNotificationName)aName object:(nullable id)anObject;
+ (void)removeObserver:(id _Nonnull)observer name:(nullable NSNotificationName)aName object:(nullable id)anObject;
+ (void)notify:(NSNotificationName _Nonnull)notificationName;
+ (void)notify:(NSNotificationName _Nonnull)notificationName object:(nullable id)anObject;

+ (void)hostObserver:(id _Nonnull)observer name:(NSNotificationName  _Nonnull)aName;
- (void)clearObserver;

+ (void)notififyMessage:(NSString *_Nullable)message title:(NSString *_Nullable)title userInfo:(NSDictionary *_Nullable)userInfo;
@end