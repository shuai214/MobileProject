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
#import "CAPDeviceService.h"
#import "CAPCoreData.h"
#import <CoreLocation/CoreLocation.h>
#import "CAPGetCurrentViewController.h"
@implementation MQTTConfig
@end

@interface MQTTSubResult : CAPBaseJSON
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *operatorCode;
@property (nonatomic, copy) NSString *userRole;

@end

@implementation MQTTSubResult
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"userID": @"UserID"
                                                                  }];
}
@end

@interface MQTTCenter () <MQTTSessionDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) MQTTConfig *config;
@property (nonatomic, strong) MQTTInfo *bindInfo;

@property (nonatomic, strong) MQTTSession *session;
@property (nonatomic, strong) NSMutableDictionary *infoDictionary;
@property (nonatomic, copy) NSString *operatorCode;
@property (nonatomic, strong) NSArray *maps;

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
    CAPCoreData *coreData = [CAPCoreData coreData];
    [coreData creatResource:@"GPSTracker"];
    if (![info.command isEqualToString:@"STATUS"]){
        info.online = 1;
    }
    if ([info.command isEqualToString:@"STATUS"]) {
        NSString *status = @"未知状态";
        UIColor *color = nil;
        if (info.online ? 0 : 1) {
            status = @"离线";
            color = [UIColor grayColor];
        }else{
            status = @"上线";
            color = [UIColor greenColor];
        }
        info.message = [NSString stringWithFormat:@"%@%@",info.deviceID,status];
        [gApp showNotifyInfo:[NSString stringWithFormat:@"设备%@%@",info.deviceID,status] backGroundColor:color];
        [coreData insertData:info];
        
    }else if ([info.command isEqualToString:@"UPGRADEREQ"]){
        [CAPNotifications notify:kNotificationUPGRADEREQName object:info];
        //        info.message = [NSString stringWithFormat:@"%@进行了拍照",info.deviceID];
        //        [coreData insertData:info];
    }else if ([info.command isEqualToString:@"VERNO"]){
        [CAPNotifications notify:kNotificationVernoName object:info];
        //        info.message = [NSString stringWithFormat:@"%@进行了拍照",info.deviceID];
        //        [coreData insertData:info];
    }else if ([info.command isEqualToString:@"PHOTO"]){
        [CAPNotifications notify:kNotificationPhotoCountChange object:info];
//        info.message = [NSString stringWithFormat:@"%@进行了拍照",info.deviceID];
//        [coreData insertData:info];
    }else if ([info.command isEqualToString:@"GPS"]){
        [CAPNotifications notify:kNotificationGPSCountChange object:info];
//        info.message = [NSString stringWithFormat:@"%@进行了定位",info.deviceID];
//        [coreData insertData:info];
    }else if ([info.command isEqualToString:@"UPLOAD"]){
        [CAPNotifications notify:kNotificationUPLOADCountChange object:info];
//        info.message = [NSString stringWithFormat:@"%@更新了设置",info.deviceID];
//        [coreData insertData:info];
    }else if ([info.command isEqualToString:@"UNBIND"]){
        [CAPNotifications notify:kNotificationDeviceCountChange object:info];
        if ([info.userRole isEqualToString:@"user"]) {
            [CAPAlertView initCloseAlertWithContent:[NSString stringWithFormat:@"%@%@%@%@",info.userProfile.firstName,CAPLocalizedString(@"message_type_guest_quit1"),info.deviceID,CAPLocalizedString(@"message_type_guest_quit2")] title:info.deviceID closeBlock:^{
            } alertType:AlertTypeButton];
        }else{
            [CAPAlertView initCloseAlertWithContent:[NSString stringWithFormat:@"%@",CAPLocalizedString(@"message_type_master_quit")] title:info.deviceID closeBlock:^{
                
            } alertType:AlertTypeButton];
        }
    }else if ([info.command isEqualToString:@"REMOVED"]){
        [CAPNotifications notify:kNotificationREMOVEDCountChange object:info];
    }else if ([info.command isEqualToString:@"BINDREQ"]){//BINDREP
        self.bindInfo = info;
        [CAPAlertView initBindAlertViewWithContent:[NSString stringWithFormat:@"%@想要绑定您的设备。",info.userProfile.firstName] ocloseBlock:^{
            [gApp showHUD:@"正在处理，请稍后..."];
            CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
            [deviceService deviceConfirm:self.bindInfo.deviceID userid:self.bindInfo.userID result:@"0" reply:^(CAPHttpResponse *response) {
                NSLog(@"%@",response);
                if ([[response.data objectForKey:@"code"] integerValue] == 200) {
                    [gApp hideHUD];
                }
            }];
        } okBlock:^{
            [gApp showHUD:CAPLocalizedString(@"loading")];
            CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
            [deviceService deviceConfirm:self.bindInfo.deviceID userid:self.bindInfo.userID result:@"1" reply:^(CAPHttpResponse *response) {
                NSLog(@"%@",response);
                if ([[response.data objectForKey:@"code"] integerValue] == 200) {
                    [gApp hideHUD];
                    [CAPAlertView initAlertWithContent:[response.data objectForKey:@"message"] okBlock:^{
                    } alertType:AlertTypeNoClose];
                }
            }];
        }];
//        [coreData insertData:info];
    }else if ([info.command isEqualToString:@"BINDREP"]){
        self.bindInfo = info;
//        info.message = [NSString stringWithFormat:@"您绑定了%@设备。",info.deviceID];
        [CAPNotifications notify:kNotificationBINDREPCountChange object:info];
    }else if (!info.command){
        if ([self getDecimalByBinary:info.status] == 16) {
            [CAPAlertView initSOSAlertViewWithContent:info ocloseBlock:^{
                
            } okBlock:^(MQTTInfo * _Nonnull info) {
                NSLog(@"%@",info);
                self.maps = [NSArray array];
                self.maps = [self getInstalledMapAppWithEndLocation:CLLocationCoordinate2DMake(info.latitude, info.longitude)];
                [self showMaps];
                info.message = [NSString stringWithFormat:@"%@",CAPLocalizedString(@"message_type_sos")];
                [coreData insertData:info];
            }];
        }else if ([self getDecimalByBinary:info.status] == 0) {
            
        }else if ([self getDecimalByBinary:info.status] == 1) {
            
        }else if ([self getDecimalByBinary:info.status] == 2) {
            
        }else if ([self getDecimalByBinary:info.status] == 3) {
            
        }else if ([self getDecimalByBinary:info.status] == 17) {
            
        }else if ([self getDecimalByBinary:info.status] == 18) {
            
        }else if ([self getDecimalByBinary:info.status] == 19) {
            
        }else if ([self getDecimalByBinary:info.status] == 20) {
            
        }else if ([self getDecimalByBinary:info.status] == 21) {
            
        }
    }
    [CAPNotifications notify:kNotificationDeviceOnlineChange object:info];
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

- (NSArray*)getInstalledMapAppWithEndLocation:(CLLocationCoordinate2D)endLocation{
    NSMutableArray*maps = [NSMutableArray array];
//    //苹果地图
//    NSMutableDictionary*iosMapDic = [NSMutableDictionary dictionary];
//    iosMapDic[@"title"] =@"苹果地图";
//    [maps addObject:iosMapDic];
    //百度地图
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary*baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] =@"百度地图";
        NSString*urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=北京&mode=driving&coord_type=gcj02",endLocation.latitude,endLocation.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    //高德地图
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary*gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] =CAPLocalizedString(@"amap_map");
        NSString*urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"导航功能",@"nav123456",endLocation.latitude,endLocation.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }
    //谷歌地图
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSMutableDictionary*googleMapDic = [NSMutableDictionary dictionary];
        googleMapDic[@"title"] =CAPLocalizedString(@"google_map");
        NSString*urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",@"导航测试",@"nav123456",endLocation.latitude, endLocation.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        googleMapDic[@"url"] = urlString;
        [maps addObject:googleMapDic];
    }
    //腾讯地图
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary*qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] =@"腾讯地图";
        NSString*urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=终点&coord_type=1&policy=0",endLocation.latitude, endLocation.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        qqMapDic[@"url"] = urlString;
        [maps addObject:qqMapDic];
    }
    return maps;
}

- (void)showMaps{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSDictionary *dic in self.maps) {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:dic[@"title"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *urlString = dic[@"url"];
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:urlString]];
        }];
        [alertController addAction:otherAction];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CAPLocalizedString(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancelAction];
    
    [[CAPGetCurrentViewController findCurrentViewController] presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
        if(buttonIndex != -1) {
            
//            if(buttonIndex ==0) {
//
//                [self navAppleMap];
//
//                return;
//
//            }
            NSDictionary*dic =self.maps[buttonIndex];
            NSString *urlString = dic[@"url"];
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:urlString]];
        }
}
/**
 二进制转换为十进制
 
 @param binary 二进制数
 @return 十进制数
 */
- (NSInteger)getDecimalByBinary:(NSString *)binary {
    
    NSInteger decimal = 0;
    for (int i=0; i<binary.length; i++) {
        
        NSString *number = [binary substringWithRange:NSMakeRange(binary.length - i - 1, 1)];
        if ([number isEqualToString:@"1"]) {
            
            decimal += pow(2, i);
        }
    }
    return decimal;
}

@end
