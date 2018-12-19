//
//  CAPKeyChain.h
//  Neptu
//
//  Created by WeifengYao on 31/10/2017.
//  Copyright © 2017 capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAPKeyChain : NSObject
//Save the data into key chain for the specified key
+ (void)save:(NSString *)key data:(id)data;

//Read the data from key chain for the specified key
+ (id)read:(NSString *)key;

//Remove the data from key chain for the specified key
+ (void)remove:(NSString *)key;
@end
