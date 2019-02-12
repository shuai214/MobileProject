//
//  CAPDeviceLocal.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/2/11.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Station : NSObject
@property (nonatomic, copy) NSString *ta;
@property (nonatomic, copy) NSString *mcc;
@property (nonatomic, copy) NSString *mnc;
@property (nonatomic, copy) NSString *ac;
@property (nonatomic, copy) NSString *no;
@property (nonatomic, copy) NSString *ss;
@end
@interface Wifis : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mac;
@property (nonatomic, assign) NSInteger dBm;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, assign) NSInteger ss;
@end

@interface CAPDeviceLocalModel : NSObject
@property(nonatomic,strong)NSArray <Station *>*station;
@property(nonatomic,strong)NSArray <Wifis *>*wifis;
@property (nonatomic, assign) NSInteger createdAt;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *type;
@end

NS_ASSUME_NONNULL_END
