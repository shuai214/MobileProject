//
//  NSData+CAP.h
//  GPSTracker
//
//  Created by WeifengYao on 12/12/2016.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSData (CAP)
+ (NSData *)dataFromHexString:(NSString *)hexString;

- (NSData *)md5;

- (NSString *)toString;
@end
