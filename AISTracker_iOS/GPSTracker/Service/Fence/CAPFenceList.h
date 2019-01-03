//
//  CAPFenceList.h
//  GPSTracker
//
//  Created by 曹帅 on 2019/1/3.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Result,List;
NS_ASSUME_NONNULL_BEGIN

@interface CAPFenceList : NSObject
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,strong)Result *result;
@end
@interface Result : NSObject
@property(nonatomic,strong)NSArray <List *>*list;
@property(nonatomic,strong)NSArray *shared;
@end
@interface List : NSObject
@property(nonatomic,copy)NSString *status;
@property(nonatomic,assign)NSInteger range;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)CGFloat lng;
@property(nonatomic,assign)CGFloat lat;
@property(nonatomic,copy)NSString *fid;
@property(nonatomic,assign)NSTimeInterval createdAt;
@property(nonatomic,copy)NSString *address;
@end
NS_ASSUME_NONNULL_END
