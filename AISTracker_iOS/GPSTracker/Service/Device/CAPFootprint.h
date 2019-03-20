//
//  CAPFootprint.h
//  GPSTracker
//
//  Created by WeifengYao on 7/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CAPDeviceLocalModel.h"
//@interface station : NSObject
//@property(nonatomic,copy)NSString *ac;
//@property(nonatomic,assign)CGFloat mcc;
//@property(nonatomic,assign)CGFloat mnc;
//@property(nonatomic,copy)NSString *no;
//@property(nonatomic,copy)NSString *ss;
//@end
//@interface wifis : NSObject
//@property(nonatomic,copy)NSString *channel;
//@property(nonatomic,assign)CGFloat dBm;
//@property(nonatomic,assign)CGFloat mac;
//@property(nonatomic,copy)NSString *ss;
//@end
//@interface ResultFootprintList : NSObject
//@property(nonatomic,copy)NSString *createdAt;
//@property(nonatomic,assign)CGFloat lat;
//@property(nonatomic,assign)CGFloat lng;
//@property(nonatomic,copy)NSString *type;
//@property(nonatomic,copy)NSString *address;
//@end

@interface CAPFootprint : NSObject
@property(nonatomic,assign)NSInteger code;
@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,strong)NSArray<CAPDeviceLocalModel *> *result;
@end
