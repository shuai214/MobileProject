//
//  CAPTrackerViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPTrackerViewController.h"
#import "CAPDeviceListView.h"
#import "CAPTrackerView.h"
#import "CAPPairViewController.h"
#import "CAPDeviceService.h"
#import "CAPDeviceLists.h"
#import "CAPUser.h"
#import "MQTTCenter.h"
#import "CAPDeviceCenter.h"
#import "CAPDeviceRecentLocation.h"
#import <GooglePlaces/GooglePlaces.h>
#import "CAPPhotographViewController.h"
#import "CAPMasterSettingViewController.h"
#import "CAPFenceListViewController.h"
#import "CAPFootprintViewController.h"
#import "UIView+Frame.h"
#import "CAPDeviceCommand.h"
#import "CAPDeviceLocal.h"
#import "CAPAlertView.h"
#import "CAPFileUpload.h"
#import "CAPFencePresenter.h"
#import "CAPDeviceLocalModel.h"
@import GoogleMaps;

#define VIEW_X 12
#define DEVICE_LIST_H 55
#define TRACKER_H 130
#define PACE_H 15
@interface CAPTrackerViewController () <CAPDeviceListViewDelegate, CAPTrackerViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) NSMutableArray *markerArray;
@property (strong, nonatomic) NSMutableArray *deviceLists;

@property (nonatomic,strong) CLLocationManager *locationManager;//地图定位对象
@property (strong, nonatomic)  CAPDeviceListView *deviceListView;
@property (strong, nonatomic)  CAPTrackerView *trackerView;
@property (strong, nonatomic)  MQTTInfo *mqttInfo;

@property (assign,nonatomic)CGRect rectTrackerView;
@property (assign,nonatomic)CGRect rectDeviceListView;
@property (strong,nonatomic)CAPDevice *currentDevice;
@property (strong,nonatomic)NSString *address;
@property (nonatomic ,strong)dispatch_source_t timer;//  注意:此处应该使用强引用 strong

@property (assign,nonatomic)NSInteger chooseIndex;
@property (assign,nonatomic)BOOL isUp;

@end

@implementation CAPTrackerViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [CAPUserDefaults setObject:@"YES" forKey:@"isFirst"];
    self.navigationItem.title = @"GPS Tracker";
    self.isUp = YES;
    self.chooseIndex = 0;
    [self setRightBarImageButton:@"bar_add" action:@selector(onAddButtonClicked:)];
//    self.mapView.camera = [GMSCameraPosition cameraWithLatitude:22.290664 longitude:114.195304 zoom:16];
//    self.navigationItem.rightBarButtonItems = @[[CAPViews newBarButtonWithImage:@"bar_add" target:self action:@selector(onAddButtonClicked:)]];
    
    self.deviceListView = [[CAPDeviceListView alloc] initWithFrame:CGRectMake(VIEW_X, Main_Screen_Height - TabBarHeight - PACE_H * 2 - TRACKER_H - DEVICE_LIST_H, Main_Screen_Width - 2 * VIEW_X, DEVICE_LIST_H)];
    self.deviceListView.backgroundColor = [UIColor clearColor];
    self.deviceListView.userInteractionEnabled = YES;
    self.deviceListView.delegate = self;
    self.rectDeviceListView = self.deviceListView.frame;
    [self.view addSubview:self.deviceListView];
    
    self.trackerView = [[CAPTrackerView alloc] initWithFrame:CGRectMake(VIEW_X, self.deviceListView.bottom + PACE_H, self.deviceListView.width, TRACKER_H)];
    self.rectTrackerView = self.trackerView.frame;
    self.trackerView.delegate = self;
    [self.view addSubview:self.trackerView];
    
    [UIView animateWithDuration:0.37 animations:^{
        [self.trackerView setY:self.rectTrackerView.origin.y + self.rectTrackerView.size.height + TabBarHeight];
        [self.deviceListView setY:Main_Screen_Height - TabBarHeight - self.rectDeviceListView.size.height - 10];
    }];
    
    self.mapView.delegate = self;
    self.mapView.indoorEnabled = NO;
    self.mapView.settings.rotateGestures = NO;
    self.mapView.settings.tiltGestures = NO;
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate  = self;
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager requestWhenInUseAuthorization];
    
    [self fetchDevice];
    [self mqttConnect];
    
    [CAPNotifications addObserver:self selector:@selector(fetchDevice) name:kNotificationDeviceCountChange object:nil];
    [CAPNotifications addObserver:self selector:@selector(deviceRefreshLocation:) name:kNotificationGPSCountChange object:nil];
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 30.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (self.currentDevice) {
            [self reloadDevice];
        }
    });
    dispatch_resume(timer);
    self.timer = timer;

}
#pragma 断掉重连时自动进行mqtt的重新连接
#pragma 扫描二维码之后填写信息的中文字符串
#pragma 围栏的中文title、
#pragma 设置里的title  更新频率的UI imei号码（确定下是不是接口换了）
#pragma “记录”要改成字符串
#pragma 经纬度的返回
- (void)reloadDevice{
    NSInteger integerTimes = 30;
    if (self.currentDevice.setting.reportFrequency) {
        integerTimes = self.currentDevice.setting.reportFrequency;
    }
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, integerTimes * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (self.currentDevice) {
            [self getDeviceLocation:self.currentDevice];
        }
    });
    dispatch_resume(timer);
    self.timer = timer;
}


- (void)fetchDevice{
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    CAPWeakSelf(self);
    [deviceService fetchDevice:^(id response) {
        CAPHttpResponse *httpResponse = (CAPHttpResponse *)response;
        CAPDeviceLists *deviceLists = [CAPDeviceLists mj_objectWithKeyValues:httpResponse.data];
        NSLog(@"-=-=-=-=-=-= %@",httpResponse.data);
        self.deviceListView.devices = deviceLists.result.list;
        if (deviceLists.result.list.count == 0) {
            [UIView animateWithDuration:0.37 animations:^{
                [weakself.trackerView setY:weakself.rectTrackerView.origin.y + self.rectTrackerView.size.height + TabBarHeight];
                [weakself.deviceListView setY:Main_Screen_Height - TabBarHeight - weakself.rectDeviceListView.size.height - 10];
            }];
            [CAPUserDefaults setObject:@"add user info" forKey:@"userInfo"];
            [weakself performSegueWithIdentifier:@"pair.segue" sender:nil];
        }else{
            weakself.currentDevice = weakself.deviceListView.devices.firstObject;
        }
        if ([weakself.currentDevice.role isEqualToString:@"user"]) {
            [weakself.trackerView userOrowner:YES];
        }else{
            [weakself.trackerView userOrowner:NO];
        }
        [self getDeviceLocal:deviceLists.result.list];
    }];
}
- (void)getDeviceLocal:(NSArray *)array{
    self.markerArray = [NSMutableArray array];
    self.deviceLists = [NSMutableArray array];
    [self.mapView clear];
    for (NSInteger i = 0; i < array.count; i++) {
        CAPDevice *device = array[i];
        CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
        [deviceService fetchDevice:device.deviceID reply:^(CAPHttpResponse *response) {
            NSDictionary *resultDic = (NSDictionary *)response.data;
            NSDictionary *result = resultDic[@"result"];
            CAPDeviceLocalModel *localModel = [CAPDeviceLocalModel mj_objectWithKeyValues:result];
            if (localModel.lat == nil) {
                localModel.lat = [NSString stringWithFormat:@"%ld",i];
                localModel.lng = [NSString stringWithFormat:@"%ld",i];
            }else{
                
            }
            device.createdDate = localModel.createdAt;
            [self.deviceLists addObject:device];
            GMSMarker *dMarker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake([localModel.lat floatValue], [localModel.lng floatValue])];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 47.4)];
            [imgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"master_bubble%ld",i + 1]]];
            UIImageView *deviceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
            deviceImgView.layer.cornerRadius = deviceImgView.frame.size.width / 2;
            deviceImgView.layer.masksToBounds = YES;
            [deviceImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",device.setting.avatarBaseUrl,device.setting.avatarPath]] placeholderImage:GetImage(@"ic_default_avatar_new")];
            [imgView addSubview:deviceImgView];
            
            [dMarker setIconView:imgView];
            dMarker.map = self.mapView;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:dMarker forKey:device.deviceID];
            [self.markerArray addObject:dic];
        }];
    }
}

//获取单个device的local
- (void)getDeviceLocal{
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    [deviceService fetchDevice:self.currentDevice.deviceID reply:^(CAPHttpResponse *response) {
        NSDictionary *resultDic = (NSDictionary *)response.data;
        NSDictionary *result = resultDic[@"result"];
        CAPDeviceLocalModel *localModel = [CAPDeviceLocalModel mj_objectWithKeyValues:result];
        if (localModel.lat == nil) {
            localModel.lat = @"0";
            localModel.lng = @"0";
        }else{
            
        }
        GMSMarker *dMarker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake([localModel.lat floatValue], [localModel.lng floatValue])];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 47.4)];
        [imgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"master_bubble%ld",self.chooseIndex]]];
        UIImageView *deviceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        deviceImgView.layer.cornerRadius = deviceImgView.frame.size.width / 2;
        deviceImgView.layer.masksToBounds = YES;
        [deviceImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",self.currentDevice.setting.avatarBaseUrl,self.currentDevice.setting.avatarPath]] placeholderImage:GetImage(@"ic_default_avatar_new")];
        [imgView addSubview:deviceImgView];
        
        [dMarker setIconView:imgView];
        dMarker.map = self.mapView;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:dMarker forKey:self.currentDevice.deviceID];
        [self.markerArray addObject:dic];
    }];
}

//向设备发送GPS信号。
- (void)getDeviceLocation:(CAPDevice *)device{
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    [deviceService deviceSendCommand:device.deviceID cmd:@"GPS" param:nil reply:^(CAPHttpResponse *response) {
        NSLog(@"%@",response);
        CAPDeviceCommand *command = [CAPDeviceCommand mj_objectWithKeyValues:response.data];
        self.mqttInfo = nil;
    }];
}
//通过MQTT获取设备的位置。
- (void)deviceRefreshLocation:(NSNotification *)notifi{
    MQTTInfo *info = notifi.object;
    self.mqttInfo = info;
    if (self.currentDevice) {
        if(![info.deviceID isEqualToString:self.currentDevice.deviceID]){
            return;
        }
    }
    [gApp hideHUD];
    self.currentDevice.connected = 1;
    CAPDevice *device = self.deviceListView.devices[self.chooseIndex];
    device.batlevel = info.batlevel;
    device.createdDate = info.time / 1000;
    for (NSInteger i = 0; i < self.markerArray.count; i++) {
        NSDictionary *dic = self.markerArray[i];
        if([info.deviceID isEqualToString:dic.allKeys.firstObject]){
            if ([info.command isEqualToString:@"GPS"]) {
                    if ([info.gps isEqualToString:@"V"]) {
                        NSDictionary *parames = [[NSDictionary alloc] init];
                        parames = [self paramesForWifi:info.wifis cellID:info.station];
                        CAPFileUpload *fileUpload = [[CAPFileUpload alloc] init];
                        [fileUpload loadDeviceParameter:parames device:self.currentDevice];
                        [fileUpload setSuccessBlockObject:^(id  _Nonnull object) {
                            NSLog(@"%@",object);
                            NSDictionary *objectDic = (NSDictionary *)object;
                            NSDictionary *location = objectDic[@"location"];
                            CGFloat lat = [location[@"lat"] floatValue];
                            CGFloat lng = [location[@"lng"] floatValue];
                            CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(lat,lng);//纬度，经度
                            [self refreshDeviceLocalized:coords time:[NSString dateFormateWithTimeInterval:info.time / 1000] deviceInfo:info.deviceID];
                            CAPDeviceLocal *local = [CAPDeviceLocal local];
                            [local setLocal:coords];
                            [self.trackerView.batteryView reloadBattery:info.batlevel];
                        }];
                        [fileUpload setFailureBlock:^{
                            GMSMarker *currentMarker = [dic objectForKey:device.deviceID];
                            [self refreshDeviceLocalized:currentMarker.position time:[NSString dateFormateWithTimeInterval:info.time / 1000] deviceInfo:info.deviceID];
                            CAPDeviceLocal *local = [CAPDeviceLocal local];
                            [local setLocal:currentMarker.position];
                            [self.trackerView.batteryView reloadBattery:info.batlevel];
                        }];
                    }
                }else{
                    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(info.latitude,info.longitude);//纬度，经度
                    [self refreshDeviceLocalized:coords time:[NSString dateFormateWithTimeInterval:info.time / 1000] deviceInfo:info.deviceID];
                    CAPDeviceLocal *local = [CAPDeviceLocal local];
                    [local setLocal:coords];
                    [self.trackerView.batteryView reloadBattery:info.batlevel];
                }
            }
        }
}














- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0;i<self.markerArray.count; i++) {
        NSDictionary *dic = self.markerArray[i];
        [array addObjectsFromArray:[dic allValues]];
    }
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:marker.position zoom:18];
    [mapView animateToCameraPosition:camera];
    NSInteger index = [array indexOfObject:marker];
    [self.deviceListView reloadButton:index];
    return YES;
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    /**
     *    拿到授权发起定位请求
     */
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_locationManager startUpdatingLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
   
    /**
     * 位置更新时调用
     */
    CLLocation *curLocation = [locations lastObject];
    // 通过location  或得到当前位置的经纬度
    GMSCameraPosition *camera = [[GMSCameraPosition alloc] initWithTarget:curLocation.coordinate zoom:16 bearing:0 viewingAngle:0];
    self.mapView.camera = camera;
    [self.locationManager stopUpdatingLocation];//定位成功后停止定位
}
//重新定位
- (void)refreshDeviceLocalized:(CLLocationCoordinate2D)coordinate time:(NSString *)time deviceInfo:(NSString *)deviceId{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude longitude:coordinate.longitude zoom:16];
    CLLocationCoordinate2D position2D = coordinate;
    self.mapView.camera = camera;
    NSDictionary *dic = self.markerArray[self.chooseIndex];
    GMSMarker *currentMarker = [dic objectForKey:deviceId];
    [currentMarker setPosition:position2D];
    currentMarker.map = self.mapView;
    //创建位置
    CLLocation *location=[[CLLocation alloc]initWithLatitude:position2D.latitude longitude:position2D.longitude];
    
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];

    //反地理编码
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //判断是否有错误或者placemarks是否为空
        if (error !=nil || placemarks.count==0) {
            NSLog(@"%@",error);
            self.currentDevice.address = CAPLocalizedString(@"unknown_address");
            [self.trackerView refreshDeviceLocation:self.currentDevice location:self.currentDevice.address time:time ? time:@""];
            [self.trackerView isLine:self.currentDevice.connected ? YES:NO];
            return ;
        }
        CLPlacemark *placemark = placemarks.firstObject;
        NSDictionary *addressDictionary = placemark.addressDictionary;
        NSArray *array = placemark.areasOfInterest;
        self.currentDevice.address = [NSString stringWithFormat:@"%@%@%@%@",addressDictionary[@"City"],addressDictionary[@"SubLocality"],addressDictionary[@"Street"],array.count == 1 ? array.firstObject:@""];
        [self.trackerView refreshDeviceLocation:self.currentDevice location:self.currentDevice.address time:time ? time:@""];
        [self.trackerView isLine:self.currentDevice.connected ? YES:NO];
    }];
    
    CAPFencePresenter *fencePresenter = [CAPFencePresenter sharedCheckFence];
    [fencePresenter getFenceList:self.currentDevice deviceLocal:coordinate];
}
- (void)refreshLocalizedString {
    
}

#pragma mark -- mqtt 链接
- (void)mqttConnect{
    MQTTCenter *mqttCenter = [MQTTCenter center];
    MQTTConfig *config = [[MQTTConfig alloc] init];
    config.host = @"mqtt.kvtel.com";
    config.port = 1883;
    config.username = @"demo_app";
    config.password = @"demo_890_123_654";
    config.userID = [CAPUserDefaults objectForKey:@"userID"];
    config.keepAliveInterval = 20;
    config.deviceType = MQTTDeviceTypeApp;
    config.platformID = @"KVTELIOT";
    config.clientID = [[CAPPhones getUUIDString] stringByAppendingString:[NSString calculateStringLength:[CAPUserDefaults objectForKey:@"userID"]]];
    [mqttCenter open:config];
}

#pragma mark ---- 获取设备列表
- (void)getDeviceList{
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    CAPWeakSelf(self);
    [deviceService fetchDevice:^(id response) {
        CAPHttpResponse *httpResponse = (CAPHttpResponse *)response;
        CAPDeviceLists *deviceLists = [CAPDeviceLists mj_objectWithKeyValues:httpResponse.data];
        NSLog(@"-=-=-=-=-=-= %@",httpResponse.data);
        self.deviceListView.devices = deviceLists.result.list;
        if (deviceLists.result.list.count == 0) {
            [UIView animateWithDuration:0.37 animations:^{
                [weakself.trackerView setY:weakself.rectTrackerView.origin.y + self.rectTrackerView.size.height + TabBarHeight];
                [weakself.deviceListView setY:Main_Screen_Height - TabBarHeight - weakself.rectDeviceListView.size.height - 10];
            }];
            [CAPUserDefaults setObject:@"add user info" forKey:@"userInfo"];
            [weakself performSegueWithIdentifier:@"pair.segue" sender:nil];
        }else{
            weakself.currentDevice = weakself.deviceListView.devices.firstObject;
        }
        [self creatMarker:self.deviceListView.devices];
        [self getDeviceFromService];
        if ([weakself.currentDevice.role isEqualToString:@"user"]) {
            [weakself.trackerView userOrowner:YES];
        }else{
            [weakself.trackerView userOrowner:NO];
        }
    }];
}
#pragma mark --创建Marker
- (void)creatMarker:(NSArray *)array{
    self.markerArray = [NSMutableArray array];
    [self.mapView clear];
    for (NSInteger i = 0; i < array.count; i++) {
        GMSMarker *dMarker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(0, 0)];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 47.4)];
        [imgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"master_bubble%ld",self.chooseIndex]]];
        UIImageView *deviceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        deviceImgView.layer.cornerRadius = deviceImgView.frame.size.width / 2;
        deviceImgView.layer.masksToBounds = YES;
        [deviceImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",self.currentDevice.setting.avatarBaseUrl,self.currentDevice.setting.avatarPath]] placeholderImage:GetImage(@"ic_default_avatar_new")];
        [imgView addSubview:deviceImgView];
        
        [dMarker setIconView:imgView];
        dMarker.map = self.mapView;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:dMarker forKey:self.currentDevice.deviceID];
        [self.markerArray addObject:dic];
    }
}

#pragma mark - CAPDeviceListViewDelegate -
-(void)didSelectDeviceAtIndex:(NSInteger)index {
    if (index == self.chooseIndex && self.isUp == YES) {
        [UIView animateWithDuration:0.37 animations:^{
            [self.trackerView setY:self.rectTrackerView.origin.y + self.rectTrackerView.size.height + TabBarHeight];
            [self.deviceListView setY:Main_Screen_Height - TabBarHeight - self.rectDeviceListView.size.height - 10];
        }];
        self.isUp = !self.isUp;
        self.chooseIndex = index;
        return;
    }
    self.isUp = YES;
    self.chooseIndex = index;
    CAPDevice *device = self.deviceListView.devices[index];
    [self.trackerView.batteryView reloadBattery:device.batlevel];
    [UIView animateWithDuration:0.37 animations:^{
        self.trackerView.frame = self.rectTrackerView;
        self.deviceListView.frame = self.rectDeviceListView;
    }];
    
    self.currentDevice = device;
    [self.trackerView refreshDeviceLocation:device location:self.currentDevice.address time:[NSString dateFormateWithTimeInterval:device.createdDate]];
    
    if ([device.role isEqualToString:@"user"]) {
        [self.trackerView userOrowner:YES];
    }else{
        [self.trackerView userOrowner:NO];
    }
    if (self.markerArray.count == 0) {
        return;
    }
    if (index >= self.markerArray.count) {
        return;
    }
    NSDictionary *dic = self.markerArray[index];
    GMSMarker *currentMarker = [dic objectForKey:device.deviceID];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentMarker.position.latitude longitude:currentMarker.position.longitude zoom:15];
    [self refreshDeviceLocalized:currentMarker.position time:[NSString dateFormateWithTimeInterval:device.createdDate] deviceInfo:device.deviceID];
    self.mapView.camera = camera;
    CAPDeviceLocal *local = [CAPDeviceLocal local];
    [local setLocal:currentMarker.position];
    [local setDeviceId:device.deviceID];
    [self getDeviceLocation:device];
}

#pragma mark ---- 从服务器获取设备的位置
- (void)getDeviceFromService{
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    [deviceService fetchDevice:self.currentDevice.deviceID reply:^(CAPHttpResponse *response) {
        NSDictionary *dic = self.markerArray[self.chooseIndex];
        NSDictionary *resultDic = (NSDictionary *)response.data;
        NSDictionary *result = resultDic[@"result"];
        CAPDeviceLocalModel *localModel = [CAPDeviceLocalModel mj_objectWithKeyValues:result];
        if (localModel.lat == nil) {
            localModel.lat = @"0";
            localModel.lng = @"0";
        }else{
            if (localModel.wifis.count == 0 && localModel.station.count == 0) {
                [self refreshDeviceLocalized:CLLocationCoordinate2DMake([localModel.lat floatValue], [localModel.lng floatValue]) time:[NSString dateFormateWithTimeInterval:localModel.createdAt / 1000] deviceInfo:self.currentDevice.deviceID];
            }else{
                NSDictionary *parames = [[NSDictionary alloc] init];
                parames = [self paramesForWifi:localModel.wifis cellID:localModel.station];
                CAPFileUpload *fileUpload = [[CAPFileUpload alloc] init];
                [fileUpload loadDeviceParameter:parames device:self.currentDevice];
                [fileUpload setSuccessBlockObject:^(id  _Nonnull object) {
                    NSLog(@"%@",object);
                    NSDictionary *objectDic = (NSDictionary *)object;
                    NSDictionary *location = objectDic[@"location"];
                    CGFloat lat = [location[@"lat"] floatValue];
                    CGFloat lng = [location[@"lng"] floatValue];
                    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(lat,lng);//纬度，经度
                    [self refreshDeviceLocalized:coords time:[NSString dateFormateWithTimeInterval:localModel.createdAt / 1000] deviceInfo:self.currentDevice.deviceID];
                    CAPDeviceLocal *local = [CAPDeviceLocal local];
                    [local setLocal:coords];
    //                [self.trackerView.batteryView reloadBattery:info.batlevel];
                }];
                [fileUpload setFailureBlock:^{
                    GMSMarker *currentMarker = [dic objectForKey:self.currentDevice.deviceID];
                    [self refreshDeviceLocalized:currentMarker.position time:[NSString dateFormateWithTimeInterval:localModel.createdAt / 1000] deviceInfo:self.currentDevice.deviceID];
    //                CAPDeviceLocal *local = [CAPDeviceLocal local];
    //                [local setLocal:currentMarker.position];
    //                [self.trackerView.batteryView reloadBattery:info.batlevel];
                }];
                
            }
        }
        
    }];
}

#pragma mark  CAPTrackerViewDelegate
-(void)onTrackerViewActionPerformed:(CAPTrackerViewAction)action {
    switch (action) {
        case CAPTrackerViewActionFence:
        {CAPFenceListViewController *fenceList = [[UIStoryboard storyboardWithName:@"Tracker" bundle:nil] instantiateViewControllerWithIdentifier:@"FenceListViewController"];
            fenceList.device = self.currentDevice;
            [self.navigationController pushViewController:fenceList animated:YES];
        }
            break;
        case CCAPTrackerViewActionFootprint:
        {CAPFootprintViewController *footprintList = [[UIStoryboard storyboardWithName:@"Tracker" bundle:nil] instantiateViewControllerWithIdentifier:@"FootprintViewController"];
            footprintList.device = self.currentDevice;
            [self.navigationController pushViewController:footprintList animated:YES];
        }
            break;
        case CAPTrackerViewActionPhotograph:
        {CAPPhotographViewController *photograph = [[UIStoryboard storyboardWithName:@"Tracker" bundle:nil] instantiateViewControllerWithIdentifier:@"PhotographViewController"];
            photograph.device = self.currentDevice;
            [self.navigationController pushViewController:photograph animated:YES];
        }
            break;
        case CAPTrackerViewActionNavigation:
            break;
        case CAPTrackerViewActionSetting:
        {CAPMasterSettingViewController *masterSetting = [[UIStoryboard storyboardWithName:@"MasterSetting" bundle:nil] instantiateViewControllerWithIdentifier:@"MasterSettingViewController"];
            masterSetting.device = self.currentDevice;
            masterSetting.battery = self.mqttInfo ? self.mqttInfo.batlevel : 0;;
            [self.navigationController pushViewController:masterSetting animated:YES];
        }
            break;
        case CAPTrackerViewActionCall:
        {
            NSArray *array = [self.currentDevice.mobile componentsSeparatedByString:@" "];
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",array.lastObject];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case CAPTrackerViewActionUnbinding:
        {
            [CAPAlertView initAlertWithContent:@"确定要解绑这台设备吗？" title:@"" closeBlock:^{
                
            } okBlock:^{
                [gApp showHUD:@"正在处理，请稍后..."];
                CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
                [deviceService deleteDevice:self.currentDevice reply:^(CAPHttpResponse *response) {
                    NSDictionary *data = response.data;
                    if ([[data objectForKey:@"code"] integerValue] == 200) {
                        [gApp hideHUD];
                        [CAPNotifications notify:kNotificationDeviceCountChange object:nil];
                    }else{
                        [gApp showHUD:[data objectForKey:@"message"] cancelTitle:@"确定" onCancelled:^{
                            
                        }];
                    }
                }];
            } alertType:AlertTypeCustom];
        }
            break;
        default:
            break;
    }
}
#pragma mark --- buttonAction
- (void)onAddButtonClicked:(id)sender {
    [CAPViews pushFromViewController:self storyboarName:@"Pair" withIdentifier:@"PairViewController"];
}

- (IBAction)getCurrentDeviceLocal:(id)sender {
    [gApp showHUD:CAPLocalizedString(@"loading")];
    [self getDeviceLocation:self.currentDevice];
}
#pragma mark  通过cellID和wifis 生成参数
- (NSDictionary *)paramesForWifi:(NSArray *)wifis cellID:(NSArray *)cellIDs{
    NSMutableDictionary *parames = [[NSMutableDictionary alloc] init];
    if(wifis.count != 0){
        NSMutableArray *parameArray = [NSMutableArray array];
        for (NSDictionary *wifiInfo in wifis){
            NSMutableDictionary *parame = [NSMutableDictionary dictionary];
            [parame setObject:[wifiInfo objectForKey:@"mac"] forKey:@"macAddress"];
            [parame setObject:[wifiInfo objectForKey:@"dBm"] forKey:@"signalStrength"];
            [parame setObject:[wifiInfo objectForKey:@"channel"] forKey:@"channel"];
            [parame setObject:@"0" forKey:@"age"];
            [parame setObject:@"0" forKey:@"signalToNoiseRatio"];
            [parameArray addObject:parame];
        }
        [parames setObject:parameArray forKey:@"wifiAccessPoints"];
    }else{
        [parames setObject:@"" forKey:@"wifiAccessPoints"];
    }
    if (cellIDs.count != 0) {
        NSMutableArray *parameArray = [NSMutableArray array];
        for (NSDictionary *stationInfo in cellIDs) {
            NSMutableDictionary *parame = [NSMutableDictionary dictionary];
            [parame setObject:[stationInfo objectForKey:@"ta"] forKey:@"timingAdvance"];
            [parame setObject:[stationInfo objectForKey:@"mcc"] forKey:@"mobileCountryCode"];
            [parame setObject:[stationInfo objectForKey:@"mnc"] forKey:@"mobileNetworkCode"];
            [parame setObject:[stationInfo objectForKey:@"ac"] forKey:@"locationAreaCode"];
            [parame setObject:[stationInfo objectForKey:@"no"] forKey:@"cellId"];
            [parame setObject:[stationInfo objectForKey:@"ss"] forKey:@"signalStrength"];
            [parameArray addObject:parame];
        }
        [parames setValue:parameArray forKey:@"cellTowers"];
    }else{
        [parames setObject:@"" forKey:@"cellTowers"];
    }
    return parames;
}
@end
