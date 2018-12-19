//
//  NSData+CAP.m
//  GPSTracker
//
//  Created by WeifengYao on 12/12/2016.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "NSData+CAP.h"

@implementation NSDictionary (JSON)
- (NSString *)toJSON {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if(error) {
        NSLog(@"ERROR: convert dictionary to JSON %@", error);
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
