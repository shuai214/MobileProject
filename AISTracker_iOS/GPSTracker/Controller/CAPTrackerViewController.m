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
#import "CAPDeviceListResponse.h"
@import GoogleMaps;

@interface CAPTrackerViewController () <CAPDeviceListViewDelegate, CAPTrackerViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet CAPDeviceListView *deviceListView;

@property (weak, nonatomic) IBOutlet CAPTrackerView *trackerView;
@property (strong, nonatomic)CLLocationManager *loacationManager;

@end

@implementation CAPTrackerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setRightBarImageButton:@"bar_add" action:@selector(onAddButtonClicked:)];
//    self.mapView.camera = [GMSCameraPosition cameraWithLatitude:22.290664 longitude:114.195304 zoom:16];
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
    
    [self fetchDevice];
    CGRect rect = self.deviceListView.frame;
    rect.size.width = self.view.frame.size.width;
    self.deviceListView.frame = rect;
    self.deviceListView.devices = @[@"1", @"2", @"3"];
    self.deviceListView.delegate = self;
    
    self.trackerView.frame = self.view.frame;
    self.trackerView.delegate = self;
}

- (void)fetchDevice{
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    [deviceService fetchDevice:^(id response) {
        NSLog(@"%@",response);
        if ([response isKindOfClass:[CAPDeviceListResponse class]]) {
            CAPDeviceListResponse *deviceResponse = response;
            if(deviceResponse.isSucceed) {
                CAPDeviceLists *deviceList = deviceResponse.deviceLists;
                NSLog(@"%@",deviceList);
            }
        }
//        self.deviceListView.devices = device.result.list;
    }];
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
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Pair" bundle:nil];
    CAPPairViewController *third = [story instantiateViewControllerWithIdentifier:@"PairViewController"];
    [self.navigationController pushViewController:third animated:YES];
}

-(void)didSelectDeviceAtIndex:(NSUInteger)index {
    NSLog(@"didSelectDeviceAtIndex: %lu", (unsigned long)index);
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
