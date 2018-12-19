//
//  CAPSocialService.h
//  GPSTracker
//
//  Created by WeifengYao on 3/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAPSocialService : NSObject
- (void)wechatLogin;
- (void)facebookLogin;
- (void)lineLogin;
@end
