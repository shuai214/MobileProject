//
//  CAPNotifications.m
//  GPSTracker
//
//  Created by WeifengYao on 19/1/2017.
//  Copyright © 2017 capelabs. All rights reserved.
//

#import "CAPNotifications.h"
#import <UserNotifications/UserNotifications.h>
#import <UIKit/UIKit.h>

static NSMutableDictionary *observers;

@implementation CAPNotifications

+ (void)initialize {
    [super initialize];
    observers = [NSMutableDictionary dictionaryWithCapacity:16];
}

+ (void)addObserver:(id)observer selector:(SEL)aSelector name:(nullable NSNotificationName)aName object:(nullable id)anObject {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:aName object:anObject];
}

+ (void)removeObserver:(id)observer name:(nullable NSNotificationName)aName object:(nullable id)anObject {
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:aName object:anObject];
    
    [observers removeObjectForKey:observer];
}

+ (void)notify:(NSString * _Nonnull)notificationName {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
}

+ (void)notify:(NSString * _Nonnull)notificationName object:(nullable id)anObject {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:anObject];
}

+ (void)hostObserver:(id)observer name:(NSNotificationName _Nonnull)aName {
    observers[observer] = aName;
}

- (void)clearObserver {
    for(id observer in observers.allKeys) {
        [CAPNotifications removeObserver:observer name:observers[observer] object:nil];
    }
    [observers removeAllObjects];
}

+ (void)notififyMessage:(NSString *)message title:(NSString *)title userInfo:(NSDictionary *)userInfo {
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        if (localNotif == nil) {
            return;
        }
        
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        //localNotif.applicationIconBadgeNumber = keyValue;
        localNotif.alertTitle = title;
        localNotif.alertBody = message;
        //localNotif.alertAction = @"Deanna got something for you";
        localNotif.hasAction = NO;
        //注意 ：  这里是立刻弹出通知，其实这里也可以来定时发出通知，或者倒计时发出通知
        [[UIApplication sharedApplication]  presentLocalNotificationNow:localNotif];
        return;
    }
    
    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    
    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.body = message;
    //content.body = [NSString localizedUserNotificationStringForKey:@"Hello_message_body" arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                  triggerWithTimeInterval:2.0 repeats:NO];
    
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:[NSString stringWithFormat:@"%@", [NSDate date]] content:content trigger:trigger];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if(error) {
            NSLog(@"ERROR: notify message failed %@", error);
        }
    }];  
}

+ (void)notififyMessage2:(NSString *)message title:(NSString *)title userInfo:(NSDictionary *)userInfo {
    UILocalNotification *noti = [[UILocalNotification alloc] init];
   
    if (noti) {
        noti.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
        noti.timeZone = [NSTimeZone defaultTimeZone];
        //noti.repeatInterval = 0;
        noti.soundName = UILocalNotificationDefaultSoundName;
        noti.alertTitle = title;
        noti.alertBody = message;
        noti.alertAction = @"action";
        noti.applicationIconBadgeNumber++;

//        NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@"name" forKey:@"key"];
        noti.userInfo = userInfo;
        UIApplication *app = [UIApplication sharedApplication];
        // ios8后，需要添加这个注册，才能得到授权
        if ([app respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                     categories:nil];
            [app registerUserNotificationSettings:settings];
            //noti.repeatInterval = NSCalendarUnitDay;
        } else {
            //noti.repeatInterval = NSDayCalendarUnit;
        }
        
        [app scheduleLocalNotification:noti];
    } else {
        NSLog(@"ERROR: create local notification failed");
    }
}
@end
