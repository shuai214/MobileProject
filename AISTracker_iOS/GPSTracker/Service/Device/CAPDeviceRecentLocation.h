//
//  CAPDeviceRecentLocation.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2018/12/30.
//  Copyright © 2018年 Capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ResultModel;
NS_ASSUME_NONNULL_BEGIN
@interface CAPDeviceRecentLocation : NSObject
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) ResultModel *result;

@end
@interface ResultModel : NSObject
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *createdAt;

@end
NS_ASSUME_NONNULL_END
