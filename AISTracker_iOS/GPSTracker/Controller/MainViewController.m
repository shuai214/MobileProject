//
//  ViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 30/10/2018.
//  Copyright © 2018 AIS. All rights reserved.
//

#import "MainViewController.h"
#import "MQTTClient.h"

@interface MainViewController () <MQTTSessionDelegate>
@property (nonatomic, strong) MQTTSession *session;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onTestButtonClick:(id)sender {
    MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc] init];
    transport.host = @"www.capelabs.net";
    transport.port = 1883;
    
    self.session = [[MQTTSession alloc] init];
    self.session.delegate = self;
    self.session.transport = transport;
    self.session.userName = @"demo_app";
    self.session.password = @"demo_890_123_654";
    self.session.clientId = @"X3211fd93441ed535NVWR4E00120000000052";
    self.session.keepAliveInterval = 20;
    [self.session connectWithConnectHandler:^(NSError *error) {
        if(error) {
            NSLog(@"connect error: %@", error);
        } else {
            NSLog(@"connect success");
        }
    }];
}

- (void)setupSubscribe {
    NSString *topic = @"SUB/TRUEIOT/DEVICE/APP/52/Setup";
    [self.session subscribeToTopic:topic atLevel:MQTTQosLevelAtMostOnce subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
        if (error) {
            NSLog(@"Subscription failed %@", error.localizedDescription);
        } else {
            NSLog(@"Setup subscription sucessfull! Granted Qos: %@", gQoss);
            [self registerPublish];
        }
    }];
}

- (void)registerPublish {
    [self.session publishData:nil onTopic:@"PUB/TRUEIOT/DEVICE/APP/52/Register" retain:NO qos:MQTTQosLevelAtMostOnce publishHandler:^(NSError *error) {
        if(error) {
            NSLog(@"publish error: %@", error);
        } else {
            NSLog(@"Register publish successful");
        }
    }];
}

- (void)subscribeInfo {
    [self.session subscribeToTopics: @{
        @"SUB/TRUEIOT/THA/APP/52/BasicInfo":@(MQTTQosLevelAtMostOnce),
        @"SUB/TRUEIOT/THA/APP/52/HistoryInfo":@(MQTTQosLevelAtMostOnce),
        @"SUB/TRUEIOT/THA/APP/52/NotifyInfo":@(MQTTQosLevelAtMostOnce),
        @"SUB/TRUEIOT/THA/APP/52/ResultInfo":@(MQTTQosLevelAtMostOnce)
    }];
}

- (void)handleEvent:(MQTTSession *)session
              event:(MQTTSessionEvent)eventCode
              error:(NSError *)error {
    NSLog(@"+++handleEvent+++");
    switch (eventCode) {
        case MQTTSessionEventConnected:
            NSLog(@"case MQTTSessionEventConnected");
            [self setupSubscribe];
            break;
        case MQTTSessionEventConnectionRefused:
            NSLog(@"MQTTSessionEventConnectionRefused");
            break;
        case MQTTSessionEventConnectionClosed:
            NSLog(@"MQTTSessionEventConnectionClosed");
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
            NSLog(@"unknown event code");
            break;
    }
}

- (void)newMessage:(MQTTSession *)session
              data:(NSData *)data
           onTopic:(NSString *)topic
               qos:(MQTTQosLevel)qos
          retained:(BOOL)retained
               mid:(unsigned int)mid {
    NSLog(@"+++++++newMessageArrived: %@", topic);
    NSLog(@"message data = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//    +++++++newMessageArrived: SUB/TRUEIOT/DEVICE/APP/52/Setup
//    message data = {"UserID":"52","operatorCode":"TRUEIOT/THA"}
    
//    +++++++newMessageArrived: SUB/TRUEIOT/THA/APP/52/ResultInfo
//    message data = {"cmd":"STATUS","deviceID":"356199060459401","status":200,"result":{"online":1}}
    if([topic isEqualToString:@"SUB/TRUEIOT/DEVICE/APP/52/Setup"]) {
        [self subscribeInfo];
    }
}

//- (void)session:(MQTTSession*)session newMessage:(NSData*)data onTopic:(NSString*)topic {
//    NSLog(@"+++++++newMessageArrived: %@", topic);
//}

@end
