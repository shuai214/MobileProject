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

@interface CAPAddFenceViewController ()<GMSMapViewDelegate,UISearchBarDelegate>
{
    GMSPlacesClient *_placesClient;
    UISearchBar * _searchBar;
}
@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) GMSMarker *marker;
@property (strong, nonatomic) GMSCircle *circ;
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
- (void)mapView:(GMSMapView *)mapView
didTapPOIWithPlaceID:(NSString *)placeID
           name:(NSString *)name
       location:(CLLocationCoordinate2D)location{
    
    NSLog(@"%@",placeID);
    
}
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
    
}
#pragma mark --- buttonAction
- (void)onAddButtonClicked:(id)sender {
    [BRStringPickerView showStringPickerWithTitle:@"选择围栏范围" dataSource:@[@"50",@"100",@"500", @"1000", @"1500"] defaultSelValue:@"1000" resultBlock:^(id selectValue) {

        if (self.gmsAddress) {
            
            [self.circ.map clear];
            // 通过location  或得到当前位置的经纬度
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.curLocation.latitude longitude:self.curLocation.longitude zoom:15];
            CLLocationCoordinate2D position2D = CLLocationCoordinate2DMake(self.curLocation.latitude,self.curLocation.longitude);
            self.mapView.camera = camera;
            //大头针
            self.marker = [GMSMarker markerWithPosition:position2D];
            self.marker.map = self.mapView;
            self.curLocation = position2D;
            
            for (NSInteger i = 0; i < 3; i++) {
                CGFloat radius = [selectValue integerValue] / 3 * (i+1);
                self.circ = [GMSCircle circleWithPosition:self.marker.position
                                                   radius:radius];
                self.circ.fillColor = [UIColor colorWithRed:193.0f/255.0f green:43.0f/255.0f blue:30.0f/255.0f alpha:0.4 - i * 0.1];
                // 圆边的颜色
                if (i == 2) {
                    self.circ.strokeColor = [UIColor greenColor];
                }else{
                    self.circ.strokeColor = [UIColor clearColor];
                }
                // 圆边的宽度
                self.circ.strokeWidth = 5;
                self.circ.map = self.mapView;
            }
            
            
            
            self.radiusFence = selectValue;
            [CAPAlertView initAddressAlertWithContent:self.gmsAddress.lines.firstObject ocloseBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            } okBlock:^(NSString * _Nonnull name) {
                CAPFence *fence = [[CAPFence alloc] init];
                fence.address = self.gmsAddress.lines.firstObject;
                fence.longitude = self.curLocation.longitude;
                fence.latitude = self.curLocation.latitude;
                fence.range = [self.radiusFence integerValue];
                fence.deviceID = self.device.deviceID;
                if (name.length != 0) {
                    fence.name = name;
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
            [CAPAlertView initAlertWithContent:@"请先选择围栏位置！" okBlock:^{
                
            } alertType:AlertTypeNoClose];
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
