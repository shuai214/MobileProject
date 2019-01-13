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
#import "CAPDeviceLocal.h"

@interface CAPAddFenceViewController ()<GMSMapViewDelegate,GMSAutocompleteViewControllerDelegate,UISearchBarDelegate>
{
    GMSPlacesClient *_placesClient;
    UISearchBar * _searchBar;
}
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
    CAPDeviceLocal *local = [CAPDeviceLocal local];
   
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:local.local.latitude longitude:local.local.longitude zoom:15];
    self.mapView.camera = camera;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(30, Main_Screen_Height - 200, Main_Screen_Width - 60, 40)];
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    
    
   
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
    _placesClient = [GMSPlacesClient sharedClient];//获取某个地点的具体信息
    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *likelihoodList, NSError *error) {
        if (error != nil) {
            DLog(@"Current Place error %@", [error localizedDescription]);
            return;
        }else{
            
        }
    }];
//    GMSCircle *circ = [GMSCircle circleWithPosition:self.marker.position
//                                             radius:200];
//    // 圈内填充的颜色
//    circ.fillColor = [UIColor colorWithRed:0.77 green:0.88 blue:0.94 alpha:0.8];
//    // 圆边的颜色
//    circ.strokeColor = [UIColor whiteColor];
//    // 圆边的宽度
//    circ.strokeWidth = 5;
//    circ.map = self.mapView;
//    [_placesClient lookUpPlaceID:placeID callback:^(GMSPlace *place, NSError *error) {
//        if (error != nil) {
//            NSLog(@"Place Details error %@", [error localizedDescription]);
//            return;
//        }
//
//        if (place != nil) {
//            NSLog(@"Place name %@", place.name);
//            NSLog(@"Place address %@", place.formattedAddress);
//            NSLog(@"Place placeID %@", place.placeID);
//            NSLog(@"Place attributions %@", place.attributions);
//        } else {
//            NSLog(@"No place details for %@", placeID);
//        }
//    }];
}

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture{
    
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    
    
}
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController{
    [_searchBar canBecomeFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [_searchBar canBecomeFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.marker.map clear];
    self.marker.map = nil;
    // 通过location  或得到当前位置的经纬度
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:place.coordinate.latitude longitude:place.coordinate.longitude zoom:15];
    CLLocationCoordinate2D position2D = CLLocationCoordinate2DMake(place.coordinate.latitude,place.coordinate.longitude);
    self.marker = [GMSMarker markerWithPosition:position2D];
    self.mapView.camera = camera;
    self.marker.map = self.mapView;
    
    _searchBar.text = place.name;
//    self.locationDetailLabel.text = place.formattedAddress;
    
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
                [gApp showHUD:@"正在加载，请稍后..."];
                CAPFenceService *fenceService =[[CAPFenceService alloc] init];
                [fenceService addFence:fence reply:^(CAPHttpResponse  *response) {
                    NSDictionary *data = response.data;
                    if ([[data objectForKey:@"code"] integerValue] == 200) {
                        [gApp hideHUD];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [gApp showHUD:[data objectForKey:@"message"] cancelTitle:@"确定" onCancelled:^{
                            [gApp hideHUD];
                        }];
                    }
                }];
            }];
        }else{
            [gApp showHUD:@"请先选择围栏位置" cancelTitle:@"好的" onCancelled:^{
                [gApp hideHUD];
            }];
        }
    }];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}

- (void)refreshLocalizedString {
    
}

@end
