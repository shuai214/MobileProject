//
//  CAPCapabilities.m
//  GPSTracker
//
//  Created by Weifeng on 11/8/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPCapabilities.h"
#import <AVFoundation/AVFoundation.h>
#import <Contacts/Contacts.h>
#import <UserNotifications/UserNotifications.h>
#import "CAPAlerts.h"

@import Photos;

@implementation CAPCapabilities

+ (void)assureCameraAccess:(CAPAccessAuthorizedCallback)callback {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                NSLog(@"Authorized");
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback();
                });
            }else{
                NSLog(@"Denied or Restricted");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CAPAlerts alertWarning:NSLocalizedString(@"denied_camera_error", nil) message:NSLocalizedString(@"auth_camera_tips", nil)];
                });
            }
        }];
    } else if(status != AVAuthorizationStatusAuthorized) {
        [CAPAlerts alertWarning:NSLocalizedString(@"denied_camera_error", nil) message:NSLocalizedString(@"auth_camera_tips", nil)];
    } else {
        callback();
    }
}

+ (void)assurePhotoAccess:(CAPAccessAuthorizedCallback)callback {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus] ;
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                NSLog(@"Authorized");
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback();
                });
            } else {
                NSLog(@"Denied or Restricted");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CAPAlerts alertWarning:NSLocalizedString(@"denied_photo_error", nil) message:NSLocalizedString(@"auth_photo_tips", nil)];
                });
            }
        }];
    } else if (status != PHAuthorizationStatusAuthorized) {
        NSLog(@"Not granted");
        [CAPAlerts alertWarning:NSLocalizedString(@"denied_photo_error", nil) message:NSLocalizedString(@"auth_photo_tips", nil)];
    } else {
        callback();
    }
}

+ (void)assureAudioAccess:(CAPAccessAuthorizedCallback)callback {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
                NSLog(@"Authorized");
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback();
                });
            }else{
                NSLog(@"Denied or Restricted");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CAPAlerts alertWarning:NSLocalizedString(@"denied_microphone_error", nil) message:NSLocalizedString(@"auth_microphone_tips", nil)];
                });
            }
        }];
    } else if(status != AVAuthorizationStatusAuthorized) {
        NSLog(@"Denied or Restricted");
        [CAPAlerts alertWarning:NSLocalizedString(@"denied_microphone_error", nil) message:NSLocalizedString(@"auth_microphone_tips", nil)];
    } else {
        callback();
    }
}

+ (void)assureContactAccess:(CAPAccessAuthorizedCallback)callback {
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (error) return;
            if (granted) {
                NSLog(@"授权访问通讯录");
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback();
                });
            }else{
                NSLog(@"拒绝访问通讯录");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [CAPAlerts alertWarning:NSLocalizedString(@"denied_contact_error", nil) message:NSLocalizedString(@"auth_contact_tips", nil)];
                });
            }
        }];
    } else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] != CNAuthorizationStatusAuthorized) {
        NSLog(@"未授权访问通讯录");
        [CAPAlerts alertWarning:NSLocalizedString(@"denied_contact_error", nil) message:NSLocalizedString(@"auth_contact_tips", nil)];
    } else {
        callback();
    }
}

+ (void)assureLocationAccess:(CAPAccessAuthorizedCallback)callback {
//    BOOL isLocation = [CLLocationManager locationServicesEnabled];
//    if (!isLocation) {
//        NSLog(@"not turn on the location");}
//    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
//    if(status == kCLAuthorizationStatusNotDetermined) {
//        CLLocationManager *manager = [[CLLocationManager alloc] init];
//        [manager requestAlwaysAuthorization];
//        [manager requestWhenInUseAuthorization];
//    } else if(status != kCLAuthorizationStatusAuthorized) {
//        
//    } else {
//        callback();
//    }
}

+ (void)assurePushAccess:(CAPAccessAuthorizedCallback)callback {
    NSLog(@"[CAPCapabilities assurePushAccess:]");
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if(settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                                  completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                      if (granted) {
                                          NSLog(@"Authorized");
                                          if(callback) {
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  callback();
                                              });
                                          }
                                      }else{
                                          NSLog(@"Denied or Restricted");
                                          [CAPAlerts alertWarning:NSLocalizedString(@"denied_notification_error", nil) message:NSLocalizedString(@"auth_notification_tips", nil)];
                                      }
                                  }];
        } else if(settings.authorizationStatus != UNAuthorizationStatusAuthorized) {
            NSLog(@"Denied or Restricted");
            dispatch_async(dispatch_get_main_queue(), ^{
                [CAPAlerts alertWarning:NSLocalizedString(@"denied_notification_error", nil) message:NSLocalizedString(@"auth_notification_tips", nil)];
            });
        } else {
            NSLog(@"Authorized");
            if(callback) {
                callback();
            }
        }
    }];
}

+ (BOOL)hasCameraAccess {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return status == AVAuthorizationStatusAuthorized;
}

+ (BOOL)hasPhotoAccess {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus] ;
    return status == PHAuthorizationStatusAuthorized;
}

+ (BOOL)hasAudioAccess {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    return status == AVAuthorizationStatusAuthorized;
}

+ (BOOL)hasContactAccess {
    return [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized;
}

+ (BOOL)hasLocationAccess {
    return NO;
    
}
@end
