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
#import <GooglePlacePicker/GooglePlacePicker.h>
#import "CAPFence.h"
#import "CAPFenceService.h"
#import "CAPDeviceLocal.h"
#import "CAPChooseFenceView.h"
@interface CAPAddFenceViewController ()<GMSMapViewDelegate,UISearchBarDelegate,GMSPlacePickerViewControllerDelegate>
{
    GMSPlacesClient *_placesClient;
    UISearchBar * _searchBar;
    GMSPlacePickerViewController *_placePickerViewController;

}
@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) GMSMarker *marker;
@property (strong, nonatomic) GMSCircle *circ;
@property (strong, nonatomic) GMSAddress *gmsAddress;
@property (strong, nonatomic) GMSPlace *choosePlace;
@property (strong, nonatomic) CAPChooseFenceView *backView;
@property (assign,nonatomic) CLLocationCoordinate2D curLocation;
@property (copy,nonatomic)NSString *radiusFence;

@end

@implementation CAPAddFenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加围栏";
//    [self setRightBarImageButton:@"bar_add" action:@selector(onAddButtonClicked:)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.mapView = [[GMSMapView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    CAPDeviceLocal *local = [CAPDeviceLocal local];
   
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:local.local.latitude longitude:local.local.longitude zoom:15];
    self.mapView.camera = camera;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(30, Main_Screen_Height - 60, Main_Screen_Width - 60, 40)];
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:nil];
    
    _placePickerViewController = [[GMSPlacePickerViewController alloc] initWithConfig:config];
    _placePickerViewController.delegate = self;
    _placePickerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:_placePickerViewController animated:YES completion:nil];
}

#pragma  mark - Mapview Delegate
- (void)mapView:(GMSMapView *)mapView
didTapPOIWithPlaceID:(NSString *)placeID
           name:(NSString *)name
       location:(CLLocationCoordinate2D)location{
    [self.marker.map clear];
    self.marker.map = nil;
    self.marker = [GMSMarker markerWithPosition:location];
    self.marker.title = name;
    self.marker.opacity = 0;
    CGPoint pos = self.marker.infoWindowAnchor;
    pos.y = 1;
    self.marker.infoWindowAnchor = pos;
    self.marker.map = mapView;
    mapView.selectedMarker = self.marker;
    
}
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
//    [self.marker.map clear];
//    self.marker.map = nil;
//    // 通过location  或得到当前位置的经纬度
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude longitude:coordinate.longitude zoom:15];
//    CLLocationCoordinate2D position2D = CLLocationCoordinate2DMake(coordinate.latitude,coordinate.longitude);
//    self.mapView.camera = camera;
//    //大头针
//    self.marker = [GMSMarker markerWithPosition:position2D];
//    self.marker.map = self.mapView;
//    self.curLocation = position2D;
//    //反向地理编码
//    [[GMSGeocoder geocoder]reverseGeocodeCoordinate:position2D completionHandler:^(GMSReverseGeocodeResponse * response, NSError * error) {
//        if (response.results) {
//            self.gmsAddress = response.results[0];
//        }
//    }];
    _placePickerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:_placePickerViewController animated:YES completion:nil];
}

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture{
    
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    
    
}
#pragma mark -----GMSAutocompleteViewController delegate
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

#pragma mark ---- UISearchBar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}

- (void)refreshLocalizedString {
    
}
#pragma mark ---- GMSPlacePickerViewController delegate
- (void)placePicker:(GMSPlacePickerViewController *)viewController didPickPlace:(GMSPlace *)place {
    NSLog(@"%f ----- %f",place.coordinate.latitude,place.coordinate.longitude);
    self.curLocation = place.coordinate;
    
    if (place.formattedAddress == nil) {
        GMSGeocoder *geoCoder = [GMSGeocoder geocoder];
        [geoCoder reverseGeocodeCoordinate:place.coordinate completionHandler:^(GMSReverseGeocodeResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"%@",response);
            self.gmsAddress = response.firstResult;
        }];
    }else{
        self.choosePlace = place;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [self drawCenter:1000];
    CAPWeakSelf(self);
    [BRStringPickerView showStringPickerWithTitle:@"选择围栏范围" dataSource:@[@"50",@"100",@"500",@"1000",@"1500"] defaultSelValue:@"1000" resultBlock:^(id selectValue) {
        [weakself drawCenter:[selectValue integerValue]];
        [CAPAlertView initAddressAlertWithContent:place.formattedAddress ? [NSString stringWithFormat:@"%@\n%@",weakself.choosePlace.name,weakself.choosePlace.formattedAddress] : weakself.gmsAddress.lines.firstObject ocloseBlock:^{
            [weakself.navigationController popViewControllerAnimated:YES];
        } okBlock:^(NSString * _Nonnull name) {
            CAPFence *fence = [[CAPFence alloc] init];
            fence.address = weakself.choosePlace.formattedAddress ? weakself.choosePlace.formattedAddress : weakself.gmsAddress.lines.firstObject;
            fence.longitude = weakself.curLocation.longitude;
            fence.latitude = weakself.curLocation.latitude;
            fence.range = [selectValue integerValue];
            fence.deviceID = weakself.device.deviceID;
            fence.content = weakself.choosePlace.name ? weakself.choosePlace.name : weakself.gmsAddress.thoroughfare;
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
                    CAPFence *resultFence = [[CAPFence alloc] initWithDictionary:data[@"result"] error:nil];
                    weakself.backView = [[CAPChooseFenceView alloc] initWithFrame:CGRectMake(15, self->_searchBar.top - 130, Main_Screen_Width - 30, 120)];
                    CAPFenceService *editFenceService =[[CAPFenceService alloc] init];
                    [weakself.backView setEditFenceNameBlock:^(CAPChooseFenceView *view){
                        [CAPAlertView initAddressAlertWithContent:[NSString stringWithFormat:@"%@\n%@",resultFence.content,resultFence.address] ocloseBlock:^{
                            [weakself.navigationController popViewControllerAnimated:YES];
                        } okBlock:^(NSString * _Nonnull name){
                            if (name.length != 0) {
                                resultFence.name = name;
                            }else{
                                resultFence.name = @"围栏";
                            }
                            [gApp showHUD:CAPLocalizedString(@"loading")];
                            [editFenceService editAddFence:resultFence reply:^(id response) {
                                if ([[data objectForKey:@"code"] integerValue] == 200) {
                                    [gApp hideHUD];
                                    [gApp showNotifyInfo:[data objectForKey:@"message"] backGroundColor:[CAPColors green1]];
                                    [weakself.backView setDatafenceInfo:resultFence];
                                }
                            }];
                        }];
                    }];
                    [weakself.backView setEditRangeBlock:^(CAPChooseFenceView *view){
                        [weakself.circ.map clear];
                        [BRStringPickerView showStringPickerWithTitle:@"选择围栏范围" dataSource:@[@"50",@"100",@"500", @"1000", @"1500"] defaultSelValue:@"1000" resultBlock:^(id selectValue) {
                            [weakself drawCenter:[selectValue integerValue]];
                            resultFence.range = [selectValue integerValue];
                            [gApp showHUD:CAPLocalizedString(@"loading")];
                            [editFenceService editAddFence:resultFence reply:^(id response) {
                                if ([[data objectForKey:@"code"] integerValue] == 200) {
                                    [gApp hideHUD];
                                    [gApp showNotifyInfo:[data objectForKey:@"message"] backGroundColor:[CAPColors green1]];
                                    [weakself.backView setDatafenceInfo:resultFence];
                                }
                            }];
                        }];
                    }];
                    [weakself.backView setCloseButtonBlock:^(CAPChooseFenceView *view){
                        CAPFenceService *fenceDeleteService =[[CAPFenceService alloc] init];
                        [gApp showHUD:CAPLocalizedString(@"loading")];
                        [fenceDeleteService deleteFence:resultFence.fenceID reply:^(id response) {
                            if ([[data objectForKey:@"code"] integerValue] == 200) {
                                [gApp hideHUD];
                                [weakself.circ.map clear];
                                [view removeFromSuperview];
                            }
                        }];
                    }];
                    [weakself.backView setDatafenceInfo:fence];
                    [weakself.view addSubview:weakself.backView];
                }else{
                    [gApp showHUD:[data objectForKey:@"message"] cancelTitle:@"确定" onCancelled:^{
                        [gApp hideHUD];
                    }];
                }
            }];
        }];
    }];
}

- (void)placePickerDidCancel:(GMSPlacePickerViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)drawCenter:(NSInteger)chooseRadius{
    [self.circ.map clear];
    CGFloat zoom = 12;
    switch (chooseRadius) {
        case 50:
            zoom = 20;
            break;
        case 100:
            zoom = 18;
            break;
        case 500:
            zoom = 16;
            break;
        case 1000:
            zoom = 15;
            break;
        case 1500:
            zoom = 14;
            break;
        default:
            break;
    }
    // 通过location  或得到当前位置的经纬度
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.curLocation.latitude longitude:self.curLocation.longitude zoom:zoom];
    CLLocationCoordinate2D position2D = CLLocationCoordinate2DMake(self.curLocation.latitude,self.curLocation.longitude);
    self.mapView.camera = camera;
    //大头针
    self.marker = [GMSMarker markerWithPosition:position2D];
    self.marker.map = self.mapView;
    self.curLocation = position2D;
    
    for (NSInteger i = 0; i < 3; i++) {
        CGFloat radius = chooseRadius / 3 * (i+1);
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
}

@end
