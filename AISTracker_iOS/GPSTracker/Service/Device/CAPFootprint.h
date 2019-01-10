//
//  CAPFootprint.h
//  GPSTracker
//
//  Created by WeifengYao on 7/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultFootprintList : NSObject
@property(nonatomic,copy)NSString *createdAt;
@property(nonatomic,assign)CGFloat lat;
@property(nonatomic,assign)CGFloat lng;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *address;
@end

@interface CAPFootprint : NSObject
@property(nonatomic,assign)NSInteger code;
@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,strong)NSArray<ResultFootprintList *> *result;
@end
