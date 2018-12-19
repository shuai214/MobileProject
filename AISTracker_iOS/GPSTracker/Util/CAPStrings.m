//
//  CAPStrings.m
//  GPSTracker
//
//  Created by user on 8/22/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPStrings.h"

@implementation CAPStrings
+(BOOL)isEmpty:(NSString *)str {
    return str==nil || str.length == 0 || [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0;
}

+(BOOL)isNotEmpty:(NSString *)str {
    return str != nil && str.length > 0 && [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0;
}
@end
