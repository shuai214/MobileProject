//
//  CAPGooglePlace.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/25.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPGooglePlace.h"
@implementation Northeast

@end
@implementation Southwest

@end

@implementation Viewport
+ (NSDictionary*)mj_objectClassInArray
{
    return @{@"southwest": @"Southwest",@"northeast": @"Northeast"};
}
@end

@implementation Location

@end

@implementation Geometry
+ (NSDictionary*)mj_objectClassInArray
{
    return @{@"location": @"Location",@"viewport": @"Viewport"};
}
@end

@implementation CAPGooglePlace
+ (NSDictionary*)mj_objectClassInArray
{
    return @{@"geometry": @"Geometry"};
}
@end
