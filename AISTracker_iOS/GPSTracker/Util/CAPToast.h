//
//  CAPToast.h
//  Neptu
//
//  Created by WeifengYao on 22/3/2018.
//  Copyright © 2018 capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAPToast : NSObject
+ (void)toastSuccess:(NSString *_Nullable)message;
+ (void)toastWarning:(NSString *_Nullable)message;
+ (void)toastError:(NSString *_Nullable)message;
+ (void)toastDebug:(NSString *_Nullable)message;
@end
