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
#import "UIView+Frame.h"
#import "CAPDeviceCommand.h"
@import GoogleMaps;

@interface CAPTrackerViewController () <CAPDeviceListViewDelegate, CAPTrackerViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) GMSMarker *marker;
@property (nonatomic,strong) CLLocationManager *locationManager;//地图定位对象
@property (nonatomic,strong) GMSPlacesClient * placesClient;//可以获取某个地方的信息

@property (weak, nonatomic) IBOutlet CAPDeviceListView *deviceListView;

@property (weak, nonatomic) IBOutlet CAPTrackerView *trackerView;

@property (assign,nonatomic)CGRect rectTrackerView;
@property (assign,nonatomic)CGRect rectDeviceListView;
@property (strong,nonatomic)CAPDevice *currentDevice;

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
    
//    CGRect rect = self.deviceListView.frame;
//    rect.size.width = self.view.frame.size.width;
//    self.deviceListView.frame = rect;
    self.deviceListView.userInteractionEnabled = YES;
    self.deviceListView.delegate = self;
    self.rectDeviceListView = self.deviceListView.frame;
    self.deviceListView.backgroundColor = [UIColor clearColor];
    
    self.rectTrackerView = self.trackerView.frame;
    self.trackerView.frame = self.view.frame;
    self.trackerView.delegate = self;//0x10683b800
    
    NSLog(@"%@ -- %@ - %@ - %@" ,self.trackerView,self.deviceListView,NSStringFromCGRect(self.rectTrackerView),NSStringFromCGRect(self.rectDeviceListView));
    
    self.mapView.delegate = self;
    self.mapView.indoorEnabled = NO;
    self.mapView.settings.rotateGestures = NO;
    self.mapView.settings.tiltGestures = NO;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.myLocationEnabled = YES;
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate  = self;
    [_locationManager requestWhenInUseAuthorization];
    
    [self fetchDevice];

    [CAPNotifications addObserver:self selector:@selector(fetchDevice) name:kNotificationDeviceCountChange object:nil];
    [CAPNotifications addObserver:self selector:@selector(deviceRefreshLocation:) name:kNotificationGPSCountChange object:nil];
}


- (void)fetchDevice{
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    [deviceService fetchDevice:^(id response) {
        CAPHttpResponse *httpResponse = (CAPHttpResponse *)response;
        CAPDeviceLists *deviceLists = [CAPDeviceLists mj_objectWithKeyValues:httpResponse.data];
        NSLog(@"%@",deviceLists);
        self.deviceListView.devices = deviceLists.result.list;
        self.currentDevice = self.deviceListView.devices.firstObject;
        [self getDeviceLocation:self.deviceListView.devices.firstObject];
        
    }];
}
- (void)getDeviceLocation:(CAPDevice *)device{
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    [deviceService deviceSendCommand:device.deviceID cmd:@"GPS" param:nil reply:^(CAPHttpResponse *response) {
        NSLog(@"%@",response);
        CAPDeviceCommand *command = [CAPDeviceCommand mj_objectWithKeyValues:response.data];
        if (command) {
//            [gApp showHUD:command.message];
        }
    }];
}

- (void)deviceRefreshLocation:(NSNotification *)notifi{
    MQTTInfo *info = notifi.object;
    if ([info.command isEqualToString:@"GPS"]) {
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(info.latitude,info.longitude);//纬度，经度
        [self refreshDeviceLocalized:coords];
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
//- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
//    [self refreshDeviceLocalized:coordinate];
//}
//- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate{
//    [self refreshDeviceLocalized:coordinate];
//}

//- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
//
//    //反向地理编码
//    [[GMSGeocoder geocoder]reverseGeocodeCoordinate:position.target completionHandler:^(GMSReverseGeocodeResponse * response, NSError * error) {
//        if (response.results) {
//            GMSAddress *address = response.results[0];
//            NSLog(@"%@",address.thoroughfare);
//
//        }
//    }];
//}
//重新定位
- (void)refreshDeviceLocalized:(CLLocationCoordinate2D)coordinate{
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
        [self.trackerView refreshDeviceLocation:self.currentDevice location:[NSString stringWithFormat:@"%@%@%@",placemark.locality,placemark.subLocality,placemark.thoroughfare]];
    }];
}
- (void)refreshLocalizedString {
    
}

- (void)onAddButtonClicked:(id)sender {
    [CAPViews pushFromViewController:self storyboarName:@"Pair" withIdentifier:@"PairViewController"];
}
#pragma mark - CAPDeviceListViewDelegate - CAPTrackerViewDelegate

-(void)didSelectDeviceAtIndex:(NSInteger)index {
    NSLog(@"didSelectDeviceAtIndex: %lu", (unsigned long)index);
//    if (index != 0) {
//        [UIView animateWithDuration:0.37 animations:^{
//            self.trackerView.frame = self.rectTrackerView;
//            self.deviceListView.frame = self.rectDeviceListView;
//        }];
        CAPDevice *device = self.deviceListView.devices[index];
        self.currentDevice = device;
        [self getDeviceLocation:device];
//    }else{
//        [UIView animateWithDuration:0.37 animations:^{
//            [self.trackerView setY:self.rectTrackerView.origin.y + self.rectTrackerView.size.height + TabBarHeight];
//            [self.deviceListView setY:Main_Screen_Height - TabBarHeight - self.rectDeviceListView.size.height - 10];
//        }];
//    }
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
            [self performSegueWithIdentifier:@"footprint.segue" sender:nil];
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
            [self.navigationController pushViewController:masterSetting animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
