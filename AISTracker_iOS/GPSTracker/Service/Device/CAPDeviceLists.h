//
//  CAPDeviceLists.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2018/12/25.
//  Copyright © 2018年 Capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAPDevice.h"
@class ResultLists;
NS_ASSUME_NONNULL_BEGIN
@protocol CAPDeviceLists <NSObject>
@end

@interface CAPDeviceLists : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong)ResultLists *result;
@end

@protocol ResultLists <NSObject>
@end

@interface ResultLists : NSObject
@property (nonatomic, copy) NSString *page;
@property (nonatomic, copy) NSString *pages;
@property (nonatomic, copy) NSString *pagesize;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, strong)NSArray <CAPDevice >*list;
@end


NS_ASSUME_NONNULL_END
