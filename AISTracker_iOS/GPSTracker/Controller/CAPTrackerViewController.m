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
@import GoogleMaps;

#define VIEW_X 12
#define DEVICE_LIST_H 55
#define TRACKER_H 130
#define PACE_H 15
@interface CAPTrackerViewController () <CAPDeviceListViewDelegate, CAPTrackerViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) GMSMarker *marker;
@property (nonatomic,strong) CLLocationManager *locationManager;//地图定位对象
@property (nonatomic,strong) GMSPlacesClient * placesClient;//可以获取某个地方的信息

@property (strong, nonatomic)  CAPDeviceListView *deviceListView;

@property (strong, nonatomic)  CAPTrackerView *trackerView;
@property (strong, nonatomic)  MQTTInfo *mqttInfo;

@property (assign,nonatomic)CGRect rectTrackerView;
@property (assign,nonatomic)CGRect rectDeviceListView;
@property (strong,nonatomic)CAPDevice *currentDevice;
@property (strong,nonatomic)NSString *address;
@property (nonatomic ,strong)dispatch_source_t timer;//  注意:此处应该使用强引用 strong
@end

@implementation CAPTrackerViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"GPS Tracker";

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
            [self getDeviceLocation:self.currentDevice];
        }
    });
    dispatch_resume(timer);
    self.timer = timer;
}
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

- (void)fetchDevice{
    
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    CAPWeakSelf(self);
    [deviceService fetchDevice:^(id response) {
        CAPHttpResponse *httpResponse = (CAPHttpResponse *)response;
        CAPDeviceLists *deviceLists = [CAPDeviceLists mj_objectWithKeyValues:httpResponse.data];
        NSLog(@"%@",deviceLists);
        weakself.deviceListView.devices = deviceLists.result.list;
        if (deviceLists.result.list.count == 0) {
            [UIView animateWithDuration:0.37 animations:^{
                [weakself.trackerView setY:weakself.rectTrackerView.origin.y + self.rectTrackerView.size.height + TabBarHeight];
                [weakself.deviceListView setY:Main_Screen_Height - TabBarHeight - weakself.rectDeviceListView.size.height - 10];
            }];
            [CAPUserDefaults setObject:@"add user info" forKey:@"userInfo"];
            [weakself performSegueWithIdentifier:@"pair.segue" sender:nil];
        }else{
            weakself.currentDevice = weakself.deviceListView.devices.firstObject;
            [weakself getDeviceLocation:weakself.currentDevice];

        }
        if ([weakself.currentDevice.role isEqualToString:@"user"]) {
            [weakself.trackerView userOrowner:YES];
        }else{
            [weakself.trackerView userOrowner:NO];
        }
        [weakself.marker.map clear];
        weakself.marker.map = nil;
    }];
}
//向设备发送GPS信号。
- (void)getDeviceLocation:(CAPDevice *)device{
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    [deviceService deviceSendCommand:device.deviceID cmd:@"GPS" param:nil reply:^(CAPHttpResponse *response) {
        NSLog(@"%@",response);
        CAPDeviceCommand *command = [CAPDeviceCommand mj_objectWithKeyValues:response.data];
    }];
}
//通过MQTT获取设备的位置。
- (void)deviceRefreshLocation:(NSNotification *)notifi{
    MQTTInfo *info = notifi.object;
    self.mqttInfo = info;
    if ([info.command isEqualToString:@"GPS"]) {
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(info.latitude,info.longitude);//纬度，经度
        [self refreshDeviceLocalized:coords time:[NSString dateFormateWithTimeInterval:info.time / 1000]];
        CAPDeviceLocal *local = [CAPDeviceLocal local];
        [local setLocal:coords];
        [self.trackerView.batteryView reloadBattery:info.batlevel];
    }
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
    GMSCameraPosition *camera = [[GMSCameraPosition alloc] initWithTarget:curLocation.coordinate zoom:15 bearing:0 viewingAngle:0];
    self.mapView.camera = camera;
    [self.locationManager stopUpdatingLocation];//定位成功后停止定位
}
//重新定位
- (void)refreshDeviceLocalized:(CLLocationCoordinate2D)coordinate time:(NSString *)time{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude longitude:coordinate.longitude zoom:15];
    CLLocationCoordinate2D position2D = coordinate;
    self.mapView.camera = camera;
    [self.marker.map clear];
    self.marker.map = nil;
    
    //大头针
    self.marker = [GMSMarker markerWithPosition:position2D];
    [self.marker setIcon:[UIImage imageNamed:@"map_drop_blue"]];
    self.marker.map = self.mapView;
    GMSGeocoder *geoCoder = [GMSGeocoder geocoder];
    [geoCoder reverseGeocodeCoordinate:position2D completionHandler:^(GMSReverseGeocodeResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",response);
        GMSAddress *placemark = response.firstResult;
        self.currentDevice.address = placemark.lines.firstObject;
        [self.trackerView refreshDeviceLocation:self.currentDevice location:placemark.lines.firstObject time:time];
    }];

}
- (void)refreshLocalizedString {
    
}

- (void)onAddButtonClicked:(id)sender {
    [CAPViews pushFromViewController:self storyboarName:@"Pair" withIdentifier:@"PairViewController"];
}
#pragma mark - CAPDeviceListViewDelegate - CAPTrackerViewDelegate

-(void)didSelectDeviceAtIndex:(NSInteger)index {
    CAPDevice *device = self.deviceListView.devices[index];
    [self getDeviceLocation:device];
    [UIView animateWithDuration:0.37 animations:^{
        self.trackerView.frame = self.rectTrackerView;
        self.deviceListView.frame = self.rectDeviceListView;
    }];
    self.currentDevice = device;
    [self.trackerView refreshDeviceLocation:device location:self.currentDevice.address time:[NSString dateFormateWithTimeInterval:device.createdDate/1000]];

    if ([device.role isEqualToString:@"user"]) {
        [self.trackerView userOrowner:YES];
    }else{
        [self.trackerView userOrowner:NO];
    }
    [self getDeviceLocation:device];
}

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
            masterSetting.battery = self.mqttInfo.batlevel;
            [self.navigationController pushViewController:masterSetting animated:YES];
        }
            break;
        case CAPTrackerViewActionCall:
        {
            NSArray *array = [self.currentDevice.mobile componentsSeparatedByString:@" "];
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",array.lastObject];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
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
- (IBAction)getCurrentDeviceLocal:(id)sender {
    [self getDeviceLocation:self.currentDevice];
}

@end
