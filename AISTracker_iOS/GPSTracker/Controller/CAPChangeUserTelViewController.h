//
//  CAPChangeUserTelViewController.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/2/16.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPBaseViewController.h"
#import "CAPUser.h"
NS_ASSUME_NONNULL_BEGIN

@interface CAPChangeUserTelViewController : CAPBaseViewController
@property(nonatomic,strong)CAPUser *user;
@property (nonatomic , copy ) void (^updateSuccessBlock)(id cap);

@end

NS_ASSUME_NONNULL_END
