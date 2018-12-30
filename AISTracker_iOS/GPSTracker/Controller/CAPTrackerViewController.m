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
@import GoogleMaps;

@interface CAPTrackerViewController () <CAPDeviceListViewDelegate, CAPTrackerViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet CAPDeviceListView *deviceListView;

@property (weak, nonatomic) IBOutlet CAPTrackerView *trackerView;
@property (strong, nonatomic)CLLocationManager *loacationManager;

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
    self.navigationItem.rightBarButtonItems = @[[CAPViews newBarButtonWithImage:@"bar_add" target:self action:@selector(onAddButtonClicked:)]];
    NSLog(@"%@",self.navigationController);
    
    CGRect rect = self.deviceListView.frame;
    rect.size.width = self.view.frame.size.width;
    self.deviceListView.frame = rect;
    self.deviceListView.userInteractionEnabled = YES;
    self.deviceListView.delegate = self;
    
    self.trackerView.frame = self.view.frame;
    self.trackerView.delegate = self;//0x10683b800
    
    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(22.290664, 114.195304);
//    marker.title = @"香港";
//    marker.snippet = @"Hong Kong";
//    marker.map = self.mapView;
    self.mapView.delegate = self;
    self.mapView.indoorEnabled = NO;
    self.mapView.settings.rotateGestures = NO;
    self.mapView.settings.tiltGestures = NO;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.myLocationEnabled = YES;
    
    
    
    _loacationManager = [[CLLocationManager alloc] init];
    _loacationManager.delegate  = self;
    [_loacationManager requestWhenInUseAuthorization];
    [self mqttConnect];
    [self fetchDevice];
    [CAPNotifications addObserver:self selector:@selector(fetchDevice) name:kNotificationDeviceCountChange object:nil];
}

- (void)fetchDevice{
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    [deviceService fetchDevice:^(id response) {
        CAPHttpResponse *httpResponse = (CAPHttpResponse *)response;
        CAPDeviceLists *deviceLists = [CAPDeviceLists mj_objectWithKeyValues:httpResponse.data];
        NSLog(@"%@",deviceLists);
        self.deviceListView.devices = deviceLists.result.list;
    }];
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


#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    /**
     *    拿到授权发起定位请求
     */
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_loacationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    /**
     * 位置更新时调用
     */
    CLLocation *currentLocation = locations.firstObject;
    self.mapView.camera = [[GMSCameraPosition alloc] initWithTarget:currentLocation.coordinate zoom:15 bearing:0 viewingAngle:0];
    [_loacationManager stopUpdatingLocation];
}

- (void)refreshLocalizedString {
    
}

- (void)onAddButtonClicked:(id)sender {
//    [self performSegueWithIdentifier:@"pair.segue" sender:nil];
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Pair" bundle:nil];
//    CAPPairViewController *third = [story instantiateViewControllerWithIdentifier:@"PairViewController"];
//    [self.navigationController pushViewController:third animated:YES];
    [CAPViews pushFromViewController:self storyboarName:@"Pair" withIdentifier:@"PairViewController"];
}
#pragma mark - CAPDeviceListViewDelegate - CAPTrackerViewDelegate

-(void)didSelectDeviceAtIndex:(NSUInteger)index {
    NSLog(@"didSelectDeviceAtIndex: %lu", (unsigned long)index);
    if (index != 0) {
      self.deviceListView.devices[index-1];
    }else{
        
    }
   
}

-(void)onTrackerViewActionPerformed:(CAPTrackerViewAction)action {
    switch (action) {
        case CAPTrackerViewActionFence:
            [self performSegueWithIdentifier:@"fence.list.segue" sender:nil];
            break;
        case CCAPTrackerViewActionFootprint:
            [self performSegueWithIdentifier:@"footprint.segue" sender:nil];
            break;
        case CAPTrackerViewActionPhotograph:
            [self performSegueWithIdentifier:@"photograph.segue" sender:nil];
            break;
        case CAPTrackerViewActionNavigation:
            break;
        case CAPTrackerViewActionSetting:
            [self performSegueWithIdentifier:@"master.setting.segue" sender:nil];
            break;
        default:
            break;
    }
}

@end
