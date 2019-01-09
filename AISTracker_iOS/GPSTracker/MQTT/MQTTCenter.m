//
//  MQTTCenter.m
//  GPSTracker
//
//  Created by WeifengYao on 30/10/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "MQTTCenter.h"
#import "MQTTClient.h"
#import "MQTTResult.h"

@implementation MQTTConfig
@end

@interface MQTTSubResult : CAPBaseJSON
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *operatorCode;
@end

@implementation MQTTSubResult
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"userID": @"UserID"
                                                                  }];
}
@end

@interface MQTTCenter () <MQTTSessionDelegate>
@property (nonatomic, strong) MQTTConfig *config;
@property (nonatomic, strong) MQTTSession *session;
@property (nonatomic, strong) NSMutableDictionary *infoDictionary;
@property (nonatomic, copy) NSString *operatorCode;
@end

@implementation MQTTCenter
+ (instancetype)center {
    static id instance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - PublicMethod

- (void)open:(MQTTConfig *)config {
    if(!self.session) {
        MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc] init];
        transport.host = config.host;
        transport.port = config.port;
        
        self.session = [[MQTTSession alloc] init];
        self.session.delegate = self;
        self.session.transport = transport;
        self.session.userName = config.username;
        self.session.password = config.password;
        self.session.clientId = config.clientID;
        self.session.keepAliveInterval = config.keepAliveInterval;
        self.session.willQoS = MQTTQosLevelAtLeastOnce;
        self.config = config;
        if(!self.infoDictionary) {
            self.infoDictionary = [[NSMutableDictionary alloc] initWithCapacity:2];
        }
        self.operatorCode = nil;
        [self.session connect];
    }
}

- (void)close {
    if(self.session) {
        [self.session close];
        self.session = nil;
        self.config = nil;
        self.operatorCode = nil;
        [self.infoDictionary removeAllObjects];
    }
}

- (MQTTInfo *)getInfo:(NSString *)deviceID {
    return [self.infoDictionary objectForKey:deviceID];
}

#pragma mark - PrivateMethod

- (void)setupSubscribe {
    NSString *topic = [self getSubscribeTopic];
    NSLog(@"setupSubscribe: %@", topic);
    [self.session subscribeToTopic:topic atLevel:MQTTQosLevelAtMostOnce subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
        if (error) {
            NSLog(@"ERROR: failed to setup subscription: %@", error);
        } else {
            NSLog(@"Setup subscription sucessfully");
        }
    }];
}

- (void)registerPublish {
    NSString *topic = [NSString stringWithFormat:@"PUB/%@/DEVICE/%@/%@/Register", self.config.platformID, [self deviceTypeDescription], self.config.userID];
    NSLog(@"registerPublish: %@", topic);
    [self.session publishData:nil onTopic:topic retain:NO qos:MQTTQosLevelAtMostOnce publishHandler:^(NSError *error) {
        if(error) {
            NSLog(@"ERROR: failed to register publish: %@", error);
        } else {
            NSLog(@"Register publish successfully");
        }
    }];
}

- (void)subscribeInfo {
    NSLog(@"[%@ subscribeInfo]", [self class]);
    NSDictionary *topics = @{
                             [self marshalInfoTopic:@"BasicInfo"]:@(MQTTQosLevelAtMostOnce),
                             [self marshalInfoTopic:@"HistoryInfo"]:@(MQTTQosLevelAtMostOnce),
                             [self marshalInfoTopic:@"NotifyInfo"]:@(MQTTQosLevelAtMostOnce),
                             [self marshalInfoTopic:@"ResultInfo"]:@(MQTTQosLevelAtMostOnce)
                             };
//    NSLog(@"subscribeInfo: %@", topics);
    [self.session subscribeToTopics: topics];
}

- (NSString *)getSubscribeTopic {
    return [NSString stringWithFormat:@"SUB/%@/DEVICE/%@/%@/Setup", self.config.platformID, [self deviceTypeDescription], self.config.userID];
}

- (NSString *)marshalInfoTopic:(NSString *)infoType {
    return [NSString stringWithFormat:@"SUB/%@/%@/%@/%@", self.operatorCode, [self deviceTypeDescription], self.config.userID, infoType];
}

- (MQTTInfoType)parseInfoType:(NSString *)topic {
    if([topic hasSuffix:@"Info"]) {
        if([topic isEqualToString:[self marshalInfoTopic:@"BasicInfo"]]) {
            return MQTTInfoTypeBasic;
        } else if([topic isEqualToString:[self marshalInfoTopic:@"ResultInfo"]]) {
            return MQTTInfoTypeResult;
        } else if([topic isEqualToString:[self marshalInfoTopic:@"NotifyInfo"]]) {
            return MQTTInfoTypeNotify;
        } else if([topic isEqualToString:[self marshalInfoTopic:@"HistoryInfo"]]) {
            return MQTTInfoTypeHistory;
        }
    }
    return MQTTInfoTypeUnknown;
}

- (NSString *)deviceTypeDescription {
    switch (self.config.deviceType) {
        case MQTTDeviceTypeApp:
            return @"APP";
        case MQTTDeviceTypeTracker:
            return @"TRACKER";
        case MQTTDeviceTypeWatch:
            return @"WATCH";
        default:
            return @"UnknownDeviceType";
    }
}

- (NSString *)infoTypeDescription:(MQTTInfoType)type {
    switch (type) {
        case MQTTInfoTypeBasic:
            return @"BasicInfo";
        case MQTTInfoTypeResult:
            return @"ResultInfo";
        case MQTTInfoTypeNotify:
            return @"NotifyInfo";
        case MQTTInfoTypeHistory:
            return @"HistoryInfo";
        default:
            return @"UnknownInfoType";
    }
}

- (void)handleMessage:(NSString *)topic data:(NSData *)data {
    NSLog(@"[%@ handleMessage: %@]", [self class], topic);
    MQTTInfoType type = [self parseInfoType:topic];
    if(type == MQTTInfoTypeUnknown) {
        if([topic isEqualToString:[self getSubscribeTopic]]) {
            NSError *error;
            MQTTSubResult *result = [[MQTTSubResult alloc] initWithData:data error:&error];
            if(!error && result && result.operatorCode && [result.userID isEqualToString:self.config.userID]) {
                self.operatorCode = result.operatorCode;
                [self subscribeInfo];
            } else {
                NSLog(@"ERROR: %@", error);
            }
        } else {
            NSLog(@"ERROR: unknow MQTT topic and message");
        }
    } else {
        NSError *error;
        MQTTInfo *info;
        if(type == MQTTInfoTypeResult) {
            MQTTResult *result = [[MQTTResult alloc] initWithData:data error:&error];
            if(!error && result) {
                info = result.result;
                info.command = result.command;
                info.statusCode = result.status;
                info.deviceID = result.deviceID;
            }
        } else {
            info = [[MQTTInfo alloc] initWithData:data error:&error];
        }
        if(!error && info) {
            info.infoType = type;
            [self handleInfo:info];
        }
    }
}

- (void)handleInfo:(MQTTInfo *)info {
    NSLog(@"[%@ handleInfo: %@]", [self class], [ self infoTypeDescription:info.infoType]);
    if ([info.command isEqualToString:@"STATUS"]) {
        NSString *status = nil;
        UIColor *color = nil;
        if (info.online ? 0 : 1) {
            status = @"离线";
            color = [UIColor grayColor];
        }else{
            status = @"上线";
            color = [UIColor greenColor];
        }
        [gApp showNotifyInfo:[NSString stringWithFormat:@"设备%@%@",info.deviceID,status] backGroundColor:color];
    }else if ([info.command isEqualToString:@"PHOTO"]){
        [CAPNotifications notify:kNotificationPhotoCountChange object:info];
    }else if ([info.command isEqualToString:@"GPS"]){
        [CAPNotifications notify:kNotificationGPSCountChange object:info];
    }else if ([info.command isEqualToString:@"UPLOAD"]){
        [CAPNotifications notify:kNotificationUPLOADCountChange object:info];
    }else if (!info.command){
        if ([info.status isEqualToString:@"00010000"]) {
            
        }
    }
    [self.infoDictionary setObject:info forKey:info.deviceID];
}

#pragma mark - MQTTSessionDelegate

- (void)handleEvent:(MQTTSession *)session
              event:(MQTTSessionEvent)eventCode
              error:(NSError *)error {
    NSLog(@"handleEvent");
    switch (eventCode) {
        case MQTTSessionEventConnected:
            NSLog(@"case MQTTSessionEventConnected");
            [self setupSubscribe];
            [self registerPublish];
            break;
        case MQTTSessionEventConnectionRefused:
            NSLog(@"MQTTSessionEventConnectionRefused");
            break;
        case MQTTSessionEventConnectionClosed:
            NSLog(@"MQTTSessionEventConnectionClosed");
            [self.session connect];
            break;
        case MQTTSessionEventConnectionError:
            NSLog(@"MQTTSessionEventConnectionError");
            break;
        case MQTTSessionEventProtocolError:
            NSLog(@"MQTTSessionEventProtocolError");
            break;
        case MQTTSessionEventConnectionClosedByBroker:
            NSLog(@"MQTTSessionEventConnectionClosedByBroker");
            break;
        default:
            NSLog(@"unknown MQTTSessionEvent");
            break;
    }
    if(error) {
        NSLog(@"ERROR: handleEvent error %@", error);
    }
}

- (void)newMessage:(MQTTSession *)session
              data:(NSData *)data
           onTopic:(NSString *)topic
               qos:(MQTTQosLevel)qos
          retained:(BOOL)retained
               mid:(unsigned int)mid {
    NSLog(@"+++++ MQTT Message +++++: %@", topic);
    NSLog(@"message data = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//        +++++++newMessageArrived: SUB/TRUEIOT/DEVICE/APP/52/Setup
//        message data = {"UserID":"52","operatorCode":"TRUEIOT/THA"}
//        +++++++newMessageArrived: SUB/TRUEIOT/THA/APP/52/ResultInfo
//        message data = {"cmd":"STATUS","deviceID":"356199060459401","status":200,"result":{"online":1}}
    [self handleMessage:topic data:data];
}

@end
