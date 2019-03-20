//
//  AppDelegate.m
//  GPSTracker
//
//  Created by WeifengYao on 30/10/2018.
//  Copyright © 2018 AIS. All rights reserved.
//

#import "AppDelegate.h"
#import "AppConfig.h"
#import "MBProgressHUD.h"
#import "CAPColors.h"
#import "CAPCapabilities.h"
#import "CAPViews.h"
#import <Bugly/Bugly.h>
#import "CAPFiles.h"
#import "CAPPhones.h"
#import "CAPNotifications.h"
#import <AFNetworking/AFNetworking.h>
#import <UserNotifications/UserNotifications.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import <Firebase/Firebase.h>
#import "IQKeyboardManager.h"
#import <GooglePlaces/GooglePlaces.h>
#import "CAPSocialService.h"
#import <TrueIDFramework/TrueIDFramework-Swift.h>
#import "FYLoginViewController.h"
#import "CAPNavigationController.h"
#import "CAPMessageService.h"
@import GoogleMaps;

AppDelegate* gApp = nil;

NSString *const kGCMMessageIDKey = @"398365024525";

@interface AppDelegate () <UNUserNotificationCenterDelegate, WXApiDelegate,FIRMessagingDelegate,UNUserNotificationCenterDelegate> {
    MBProgressHUD *_textHud;
    MBProgressHUD *_progressHud;
}
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UIButton *cancelButton;
@property (copy, nonatomic) CAPHUDCancelReply cancelBlock;
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (nonatomic, readwrite, assign) NSInteger networkReachabilityStatus;
@property (copy, nonatomic) NSString *logFilePath;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    gCfg = [AppConfig new];
    
    //    if ([CAPUserDefaults objectForKey:@"accessToken"]) {
    //        NSLog(@"accessToken - == %@",[CAPUserDefaults objectForKey:@"accessToken"]);
    //        [self showMainPage];
    //    }else{
    //        [self showLoginPage];
    //    }
    
    //    [self showMainPage];
    //    [self.window makeKeyAndVisible];
    
    TrueIdPlatformAuth *trueAuth = [TrueIdPlatformAuth shareInstance];
    
    [trueAuth setSDKforWithSdkFor:TrueSDKForProduction];
    
    [trueAuth setClientIDWithClientId:@"653"];
    [trueAuth setReDirectUrlWithUrlStr:@"https://www.google.co.th"];
    NSArray *scopes = @[@"public_profile",@"email",@"mobile",@"references"];
    [trueAuth initWithScopes:scopes];
    //    if (UIDevice.deviceLanguageType == UIDeviceLanguageThai) {
    //        [trueAuth setLanguageWithLanguage:LANGUAGE_SDKTH];
    //    }else{
    [trueAuth setLanguageWithLanguage:LANGUAGE_SDKEN];
    //    }
    
    //set automation login.CGD1901211107460002
    trueAuth.isLoginAutoAfterForget = YES;
    trueAuth.isLoginAutoAfterRegister = YES;
    [self setupWindow];
    if(!gCfg.isDev) {
        [self redirectNSLog];
    }
    self.logFilePath = nil;
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
    
    NSLog(@"%@", launchOptions);
    //NSLog(@"files\n%@", [CAPFiles listFiles:@"Log"]);
    NSLog(@"Version: %@ Build: %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]);
    
    NSLog(@"PhoneModel: %@, PhoneName: %@, PhoneType: %@, SystemName: %@, SystemVersion: %@ UUID: %@", [CAPPhones phoneModel], [CAPPhones phoneName], [CAPPhones phoneType], [CAPPhones systemName], [CAPPhones systemVersion],[CAPPhones getUUIDString]);
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UITabBar appearance] setTranslucent:NO];
    gApp = self;
    
    BOOL hud = [self createHUD];
    DLog(@"create HUD result: %D", hud);
    
    [Bugly startWithAppId:(gCfg.isBuild ? @"7c5f7a10e5" : @"9ebc08e2a2")];
    [GMSServices provideAPIKey:@"AIzaSyD70_KIiNtToPgyXXCv3QriAdzC7xT-els"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyD70_KIiNtToPgyXXCv3QriAdzC7xT-els"];
    //    [GMSServices provideAPIKey:@"AIzaSyCM0E9o_s8Mf7Ch8lf1xknD0IGfoohIIkk"];
    //    [GMSPlacesClient provideAPIKey:@"AIzaSyCM0E9o_s8Mf7Ch8lf1xknD0IGfoohIIkk"];
    
    [self startNetworkMonitor];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    //    [IQKeyboardManager sharedManager].canAdjustAdditionalSafeAreaInsets = YES;
    //    [IQKeyboardManager sharedManager].enableDebugging = YES;
    //[[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    
    return YES;
}
- (void)setupWindow{
    
    //    FYLoginViewController *loginVc = [FYLoginViewController new];
    //    CAPNavigationController *nav = [[CAPNavigationController alloc] initWithRootViewController:loginVc];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *viewController = [storyboard instantiateInitialViewController];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
}
- (void)showLoginPage {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *viewController = [storyboard instantiateInitialViewController];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
}

- (void)showMainPage {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateInitialViewController];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"== applicationWillResignActive ==");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [CAPUserDefaults removeObjectForKey:@"isFirst"];
    NSLog(@"== applicationDidEnterBackground ==");
    __weak typeof(self)weakSelf = self;
    self.backgroundTaskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^(void){
        // do something...
        DLog(@"Doing something is in background");
        [[UIApplication sharedApplication] endBackgroundTask:weakSelf.backgroundTaskIdentifier];
        weakSelf.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"== applicationWillEnterForeground ==");
    if(self.logFilePath && gCfg.isRelease) {
        unsigned long long size = [CAPFiles sizeAtPath:self.logFilePath];
        if(size > 33554432) { //32M
            [self redirectNSLog];
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"== applicationDidBecomeActive ==");
    [TrueIdPlatformAuth activeApp];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    NSLog(@"== applicationWillTerminate ==");
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"GPSTracker"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}



#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.capelabs.neptu" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Ruyi" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Ruyi.sqlite"];
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption: @(YES),
                              NSInferMappingModelAutomaticallyOption: @(YES),
                              };
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Helper Methods

- (void)redirectNSLog {
    if(self.logFilePath) {
        fclose(stdout);
        fclose(stderr);
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd_HH_mm_ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *logFileName = [NSString stringWithFormat:@"Neptu_log_%@.txt", strDate];
    NSString *logDirectory = [CAPFiles createDirectory:@"Log"];
    NSArray *files = [CAPFiles listFilesAtDocumentDir:@"Log"];
    if(files.count > 4) {
        NSArray *sortedFiles = [files sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *s1 = obj1;
            NSString *s2 = obj2;
            return [s1 compare:s2];
        }];
        for(int i=0; i<sortedFiles.count-4; i++) {
            [CAPFiles deleteAtPath:[logDirectory stringByAppendingPathComponent:sortedFiles[i]]];
        }
    }
    
    self.logFilePath = [logDirectory stringByAppendingPathComponent:logFileName];
    
    freopen([self.logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([self.logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

- (void)showHUD {
    [self showHUD:NSLocalizedString(@"default_hud_tips", nil)];
}

- (void)showHUD:(NSString *)title {
    _textHud.label.text = title;
    [self.window addSubview:_textHud];
    [_textHud showAnimated:YES];
}

- (void)showHUDWithCancelTitle:(NSString *)cancelTitle onCancelled:(CAPHUDCancelReply)cancelBlock {
    [self showHUD:NSLocalizedString(@"default_hud_tips", nil) cancelTitle:cancelTitle onCancelled:cancelBlock];
}

- (void)showHUD:(NSString *)title cancelTitle:(NSString *)cancelTitle onCancelled:(CAPHUDCancelReply)cancelBlock {
    NSLog(@"showHUD: %@, %@", title, cancelTitle);
    _progressHud.label.text = title;
    _progressHud.progress = 0.0;
    [_progressHud.button setTitle:cancelTitle forState:UIControlStateNormal];
    [self.window addSubview:_progressHud];
    [_progressHud showAnimated:YES];
    self.cancelBlock = cancelBlock;
}

- (void)showHUDWithCancel {
    __weak typeof(self)weakSelf = self;
    [self showHUDWithCancelTitle:NSLocalizedString(@"cancel", nil) onCancelled:^{
        [weakSelf hideHUD];
    }];
}

- (void)updateProgress:(CGFloat)progress {
    _progressHud.progress = progress;
}

- (void)hideHUD {
    [_textHud hideAnimated:YES];
    [_progressHud hideAnimated:YES];
}
- (void)showNotifyInfo:(NSString *)info backGroundColor:(UIColor *)color{
    MBProgressHUD *hud = [MBProgressHUD showTitleToView:self.window postion:NHHUDPostionBottom title:info];
    hud.bezelBackgroundColor(color);
}
- (BOOL)createHUD {
    NSLog(@"[%@ createHUD]", [self class]);
    BOOL result = NO;
    {
        //_hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        _textHud = [[MBProgressHUD alloc] initWithView:self.window];
        _textHud.removeFromSuperViewOnHide = YES;
        _textHud.mode = MBProgressHUDModeIndeterminate;
        _textHud.contentColor = [CAPColors blue3];
        _textHud.label.text = NSLocalizedString(@"default_hud_tips", nil);
        _textHud.label.numberOfLines = 0;
        _textHud.label.lineBreakMode = NSLineBreakByWordWrapping;
        _textHud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        _textHud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.5f];
        //_textHud.margin = 60;
        _textHud.minSize = CGSizeMake(self.window.screen.bounds.size.width*0.78, 160);
        
        _progressHud = [[MBProgressHUD alloc] initWithView:self.window];
        _progressHud.removeFromSuperViewOnHide = YES;
        _progressHud.mode = MBProgressHUDModeDeterminate;
        _progressHud.contentColor = [CAPColors blue3];
        _progressHud.label.text = NSLocalizedString(@"default_hud_tips", nil);
        _progressHud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        _progressHud.backgroundView.color = [UIColor colorWithWhite:0.8f alpha:0.2f];
        _progressHud.button.backgroundColor = [CAPColors blue3];
        _progressHud.minSize = CGSizeMake(self.window.screen.bounds.size.width*0.78, 180);
        [_progressHud.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_progressHud.button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_progressHud.button addTarget:self action:@selector(onCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        result = YES;
        return result;
    }
    return result;
}

- (void)onCancelButtonClicked:(id)sender {
    NSLog(@"onCancelButtonClicked");
    if(self.cancelBlock) {
        self.cancelBlock();
        self.cancelBlock = nil;
    }
}

- (void)startNetworkMonitor {
    self.networkReachabilityStatus = 2;
    __weak typeof(self)weakSelf = self;
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    //_hasNetwork = manager.reachable;
    //self.networkReachabilityStatus = manager.networkReachabilityStatus;
    DLog(@"Current network reachability status: %ld", (long)self.networkReachabilityStatus);
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        DLog(@"Network reachability status: %ld", (long)status);
        //_hasNetwork = (status > 0);
        weakSelf.networkReachabilityStatus = status;
        /*
         AFNetworkReachabilityStatusUnknown          = -1,
         AFNetworkReachabilityStatusNotReachable     = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
    }];
}

- (BOOL)getNetworkReachable {
    return self.networkReachabilityStatus > 0;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
   
    return  [[TrueIdPlatformAuth shareInstance] handleOpenURLWithUrl:url sourceApplication:sourceApplication];
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    
    return [[TrueIdPlatformAuth shareInstance] handleOpenURLWithUrl:url options:options];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXAUTH handleOpenURL:url];
}

#pragma mark fireBase
- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage{
    
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken{
//    [[FIRInstanceID instanceID] instanceIDWithHandler:^(FIRInstanceIDResult * _Nullable result,
//                                                        NSError * _Nullable error) {
//        if (error != nil) {
//            NSLog(@"Error fetching remote instance ID: %@", error);
//        } else {
//            NSLog(@"Remote instance ID token: %@", result.token);
//            NSString* message =
//            [NSString stringWithFormat:@"Remote InstanceID token: %@", result.token];
//        }
//    }];
    NSLog(@"FCM registration token: %@", fcmToken);
    // Notify about received token.
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     @"FCMToken" object:nil userInfo:dataDict];
    CAPMessageService *messageService = [[CAPMessageService alloc] init];
    if (fcmToken != nil) {
        [messageService updatePushToken:fcmToken reply:^(id response) {
            NSLog(@"%@",response);
        }];
    }
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
}
#pragma mark - UNUserNotificationCenterDelegate

// Handle notification messages after display notification is tapped by the user.
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
/**
 line:
 Channel ID
 1611889003
 Channel secret
 821373e8154311eceb779df94d53075e
 */
@end
