//
//  CAPGooglePlace.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/25.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface Northeast :NSObject
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
@end
@interface Southwest :NSObject
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
@end
@interface Viewport :NSObject
@property (nonatomic, strong) Southwest *southwest;
@property (nonatomic, strong) Northeast *northeast;
@end
@interface Location :NSObject
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
@end

@interface Geometry :NSObject
@property (nonatomic, strong) Location *location;
@property (nonatomic, strong) Viewport *viewport;
@end

@interface CAPGooglePlace : NSObject
@property(nonatomic,copy)NSString *vicinity;
@property(nonatomic,copy)NSString *scope;
@property(nonatomic,copy)NSString *reference;
@property(nonatomic,copy)NSString *place_id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,assign)NSInteger index;

@property(nonatomic,strong)Geometry *geometry;
@end

NS_ASSUME_NONNULL_END
