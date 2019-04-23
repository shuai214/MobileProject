//
//  AppDelegate.h
//  GPSTracker
//
//  Created by WeifengYao on 30/10/2018.
//  Copyright © 2018 AIS. All rights reserved.
//

#define DLog( ... ) NSLog(__VA_ARGS__);

//typedef void (^CAPHUDCancelReply)();

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@property (strong, nonatomic) UIViewController *viewController;
@property (nonatomic, readonly, assign, getter=getNetworkReachable) BOOL hasNetwork;
@property (nonatomic, readonly, assign) NSInteger networkReachabilityStatus;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;

@end

