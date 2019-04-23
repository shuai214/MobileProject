//
//  CAPMainConfig.m
//  GPSTrackerSDK
//
//  Created by capaipai@sina.com on 2019/3/27.
//  Copyright © 2019年 capaipai. All rights reserved.
//

#import "CAPMainConfig.h"
#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GoogleMaps.h>
#import <TrueIDFramework/TrueIDFramework-Swift.h>
#import "CAPMessageService.h"
#import <Firebase/Firebase.h>
#import <UserNotifications/UserNotifications.h>

NSString *const kGCMMessageIDKey = @"398365024525";

@interface CAPMainConfig ()<FIRMessagingDelegate,UNUserNotificationCenterDelegate>

@end

@implementation CAPMainConfig
+ (instancetype)mainConfig {
    static id instance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
#pragma mark --googleMapConfig
- (void)googleMapConfig{
    [GMSServices provideAPIKey:@"AIzaSyD70_KIiNtToPgyXXCv3QriAdzC7xT-els"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyD70_KIiNtToPgyXXCv3QriAdzC7xT-els"];
}
- (void)trueLoginConfig{
    TrueIdPlatformAuth *trueAuth = [TrueIdPlatformAuth shareInstance];
    
    [trueAuth setSDKforWithSdkFor:TrueSDKForProduction];
    
    [trueAuth setClientIDWithClientId:@"653"];
    [trueAuth setReDirectUrlWithUrlStr:@"https://www.google.co.th"];
    NSArray *scopes = @[@"public_profile",@"email",@"mobile",@"references"];
    [trueAuth initWithScopes:scopes];
    [trueAuth setIsSelfLogin: YES];
    //    [auth setIsLoginAutoAfterRegister:YES];
    //    [auth setIsLoginAutoAfterForget:YES];
    [trueAuth setActiveAppDelegate:self];
   
    [trueAuth setLanguageWithLanguage:LANGUAGE_SDKEN];
    
}
- (void)openFireBase{
    UIApplication *application = [UIApplication sharedApplication];
    //开启谷歌推送
    [FIRApp configure];
    [FIRMessaging messaging].delegate = self;
    if ([UNUserNotificationCenter class] != nil) {
        // iOS 10 or later
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
        UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter]
         requestAuthorizationWithOptions:authOptions
         completionHandler:^(BOOL granted, NSError * _Nullable error) {
             // ...
         }];
    } else {
        // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    [application registerForRemoteNotifications];
    DLog(@"== didFinishLaunchingWithOptions ==");
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}
#pragma mark fireBase
- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage{
    
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken{
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     @"FCMToken" object:nil userInfo:dataDict];
    CAPMessageService *messageService = [[CAPMessageService alloc] init];
    if (fcmToken != nil) {
        [messageService updatePushToken:fcmToken reply:^(id response) {
            NSLog(@"%@",response);
        }];
    }
}
#pragma mark - UNUserNotificationCenterDelegate
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    completionHandler();
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"[AppDelegate didReceiveLocalNotification:]");
}

//在展示通知前进行处理，即有机会在展示通知前再修改通知内容。
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    //1. 处理通知
    NSLog(@"Handle local notification");
    //2. 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
    completionHandler(UNNotificationPresentationOptionAlert);
}

void UncaughtExceptionHandler(NSException *exception) {
    NSLog(@"------  UncaughtExceptionHandler  ------");
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *content = [NSString stringWithFormat:@"========异常错误报告========\nName: %@\nReason: %@\nCallStackSymbols:\n%@",name, reason, [callStack componentsJoinedByString:@"\n"]];
    NSLog(@"ERROR: \n%@", content);
}
@end
