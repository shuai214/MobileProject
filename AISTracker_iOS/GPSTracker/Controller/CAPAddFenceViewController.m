//
//  CAPAddFenceViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPAddFenceViewController.h"
#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GoogleMaps.h>
#import "CAPFence.h"
#import "CAPFenceService.h"
@interface CAPAddFenceViewController ()<GMSMapViewDelegate>
@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) GMSMarker *marker;
@property (strong, nonatomic) GMSAddress *gmsAddress;
@property (assign,nonatomic) CLLocationCoordinate2D curLocation;
@property (copy,nonatomic)NSString *radiusFence;
@end

@implementation CAPAddFenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加围栏";
    [self setRightBarImageButton:@"bar_add" action:@selector(onAddButtonClicked:)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.mapView = [[GMSMapView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

#pragma  mark - Mapview Delegate
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    [self.marker.map clear];
    self.marker.map = nil;
    // 通过location  或得到当前位置的经纬度
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude longitude:coordinate.longitude zoom:15];
    CLLocationCoordinate2D position2D = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude);
    self.mapView.camera = camera;
    //大头针
    self.marker = [GMSMarker markerWithPosition:position2D];
    self.marker.map = self.mapView;
    self.curLocation = position2D;
    //反向地理编码
    [[GMSGeocoder geocoder]reverseGeocodeCoordinate:position2D completionHandler:^(GMSReverseGeocodeResponse * response, NSError * error) {
        if (response.results) {
            self.gmsAddress = response.results[0];
        }
    }];
}

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture{
    
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    
    
}
#pragma mark --- buttonAction
- (void)onAddButtonClicked:(id)sender {
    [BRStringPickerView showStringPickerWithTitle:@"选择围栏范围" dataSource:@[@"500", @"1000", @"1500",@"2000"] defaultSelValue:@"500" resultBlock:^(id selectValue) {
        
        if (self.gmsAddress) {
            NSLog(@"%@",self.gmsAddress);
            self.radiusFence = selectValue;
            [CAPAlerts alertEdit:self title:self.gmsAddress.lines.firstObject subTitle:self.radiusFence defaultText:nil placeholder:@"Enter the nickname" actionBlock:^(NSString * _Nullable text) {
                NSLog(@"%@",text);
                CAPFence *fence = [[CAPFence alloc] init];
                fence.address = self.gmsAddress.lines.firstObject;
                fence.longitude = self.curLocation.longitude;
                fence.latitude = self.curLocation.latitude;
                fence.range = [self.radiusFence integerValue];
                fence.deviceID = self.device.deviceID;
                if (text) {
                    fence.name = text;
                }else{
                    fence.name = @"围栏";
                }
                CAPFenceService *fenceService =[[CAPFenceService alloc] init];
                [fenceService addFence:fence reply:^(CAPHttpResponse  *response) {
                    NSLog(@"%@",response);
                }];
            }];
        }else{
            [gApp showHUD:@"请先选择围栏位置" cancelTitle:@"好的" onCancelled:^{
                [gApp hideHUD];
            }];
        }
    }];
}
- (void)refreshLocalizedString {
    
}

@end
