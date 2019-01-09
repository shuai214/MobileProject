//
//  CAPDeviceCommand.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/5.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>
//{
//    "status": "Ok",
//    "message": "命令已经发送，请等待处理通知。",
//    "code": 200,
//    "result": {
//        "uuid": "868013023790342",
//        "name": "868013023790342",
//        "status": 1
//    },
//    "request": {
//        "cmd": "PHOTO",
//        "param": 1
//    }
//}
NS_ASSUME_NONNULL_BEGIN


@interface ResultCommand : NSObject
@property(nonatomic,copy)NSString *uuid;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *status;

@end
@interface RequestCommand : NSObject
@property(nonatomic,copy)NSString *cmd;
@property(nonatomic,copy)NSString *param;
@end
@interface CAPDeviceCommand : NSObject
@property(nonatomic,assign)NSInteger code;
@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,strong)ResultCommand *result;
@property(nonatomic,strong)RequestCommand *request;
@end
NS_ASSUME_NONNULL_END
