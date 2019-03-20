//
//  CAPUploadFrequencyViewController.h
//  GPSTracker
//
//  Created by 曹帅 on 2019/1/9.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPBaseViewController.h"
#import "CAPDevice.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAPUploadFrequencyViewController : CAPBaseViewController
@property(nonatomic,strong)CAPDevice *device;
@property (nonatomic , copy ) void (^updateSuccessBlock)(NSString *time);
@end

NS_ASSUME_NONNULL_END
