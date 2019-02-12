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
#import "CAPFileUpload.h"
#import "CAPGooglePlace.h"
#import "SDAutoLayout.h"
#import "CAPAddFenceTableViewCell.h"
@interface CAPAddFenceViewController ()<GMSMapViewDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UISearchBar * _searchBar;
}
@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) GMSMarker *marker;
@property (strong, nonatomic) GMSMarker *tapMarker;
@property (strong, nonatomic) GMSCircle *circ;
@property (strong, nonatomic) CAPChooseFenceView *backView;
@property (assign,nonatomic) CLLocationCoordinate2D curLocation;
@property (strong,nonatomic)UITableView *addressTableView;
@property (strong,nonatomic)NSMutableArray <CAPGooglePlace *>*poiArrays;
@property (strong,nonatomic)NSMutableArray <GMSMarker *>*markerArrays;
@property (strong, nonatomic) UIView *tableContentView;
@property (assign,nonatomic) NSInteger chooseIndex;
@end

@implementation CAPAddFenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = CAPLocalizedString(@"add fence");
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
}

#pragma  mark - Mapview Delegate
//- (void)mapView:(GMSMapView *)mapView
//didTapPOIWithPlaceID:(NSString *)placeID
//           name:(NSString *)name
//       location:(CLLocationCoordinate2D)location{
//    [self.marker.map clear];
//    self.marker.map = nil;
//    self.marker = [GMSMarker markerWithPosition:location];
//    self.marker.title = name;
//    self.marker.opacity = 0;
//    CGPoint pos = self.marker.infoWindowAnchor;
//    pos.y = 1;
//    self.marker.infoWindowAnchor = pos;
//    self.marker.map = mapView;
//    mapView.selectedMarker = self.marker;
//
//}
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    self.poiArrays = [NSMutableArray array];
    self.markerArrays = [NSMutableArray array];
    [self.marker.map clear];
    self.marker.map = nil;
    // 通过location  或得到当前位置的经纬度
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude longitude:coordinate.longitude zoom:15];
     self.mapView.camera = camera;
    //大头针
    self.tapMarker = [GMSMarker markerWithPosition:coordinate];
    self.tapMarker.map = self.mapView;
    self.tapMarker.icon = GetImage(@"map_drop_blue");
    
    [gApp showHUD:CAPLocalizedString(@"loading")];
    CAPFileUpload *fileUplod = [[CAPFileUpload alloc] init];
    [fileUplod getDeviceLoacl:[NSString stringWithFormat:@"%lf,%lf",coordinate.latitude,coordinate.longitude]];
    [fileUplod setSuccessBlockObject:^(id  _Nonnull object) {
        NSLog(@"%@",object);
        NSDictionary *dic = (NSDictionary *)object;
        if ([[dic objectForKey:@"status"] isEqualToString:@"OK"]) {
            NSArray *result = [dic objectForKey:@"results"];
            for (NSInteger i = 1;i < result.count ; i++) {
                NSDictionary *dicResult = result[i];
                CAPGooglePlace *googlePlace = [CAPGooglePlace mj_objectWithKeyValues:dicResult];
                googlePlace.index = i;
                CLLocationCoordinate2D position2D = CLLocationCoordinate2DMake(googlePlace.geometry.location.lat,googlePlace.geometry.location.lng);
                //大头针
                self.marker = [GMSMarker markerWithPosition:position2D];
                self.marker.map = self.mapView;
                self.curLocation = position2D;
                [self.poiArrays addObject:googlePlace];
                [self.markerArrays addObject:self.marker];
            }
            [gApp hideHUD];
            [self creatAddressTableView];
        }
        [gApp hideHUD];
    }];
}

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture{
    
}
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
//    [CATransaction begin];
//    [CATransaction setAnimationDuration:1.0f];
//    GMSCameraPosition *camera =
//    [GMSCameraPosition cameraWithTarget:marker.position
//                                         zoom:20];
//    [mapView animateToCameraPosition:camera];
//    [CATransaction commit];
    if (marker == self.tapMarker) {
        [self addFence:self.poiArrays.firstObject];
    }else{
        NSInteger index = [self.markerArrays indexOfObject:marker];
        [self addFence:[self.poiArrays objectAtIndex:index]];
        
    }
    return YES;
}
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    
    
}
#pragma mark ---- UISearchBar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}

- (void)refreshLocalizedString {
    
}

- (void)addFence:(CAPGooglePlace *)place{
    CAPWeakSelf(self);
    [BRStringPickerView showStringPickerWithTitle:CAPLocalizedString(@"information_of_the_fence") dataSource:@[@"50",@"100",@"500",@"1000",@"1500"] defaultSelValue:@"1000" resultBlock:^(id selectValue) {
        [weakself drawCenter:[selectValue integerValue]];
        [CAPAlertView initAddressAlertWithContent:[NSString stringWithFormat:@"%@\n%@",place.name,place.vicinity] ocloseBlock:^{
            [weakself.navigationController popViewControllerAnimated:YES];
        } okBlock:^(NSString * _Nonnull name) {
//            [self.marker.map clear];
//            self.marker.map = nil;
            CAPFence *fence = [[CAPFence alloc] init];
            fence.address = place.vicinity;
            fence.longitude = place.geometry.location.lng;
            fence.latitude = place.geometry.location.lat;
            fence.range = [selectValue integerValue];
            fence.deviceID = weakself.device.deviceID;
            fence.content = place.name;
            if (name.length != 0) {
                fence.name = name;
            }else{
                fence.name = CAPLocalizedString(@"gps_fencing");
            }
            [gApp showHUD:CAPLocalizedString(@"loading")];
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
                                fence.name = CAPLocalizedString(@"gps_fencing");
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
                        [BRStringPickerView showStringPickerWithTitle:CAPLocalizedString(@"information_of_the_fence") dataSource:@[@"50",@"100",@"500", @"1000", @"1500"] defaultSelValue:@"1000" resultBlock:^(id selectValue) {
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
                    [weakself cancelButtonAction];
                    [weakself.view bringSubviewToFront:weakself.tableContentView];

                }else{
                    [gApp showHUD:[data objectForKey:@"message"] cancelTitle:CAPLocalizedString(@"ok") onCancelled:^{
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
            zoom = 18.0f;
            break;
        case 100:
            zoom = 17.0f;
            break;
        case 500:
            zoom = 15.0f;
            break;
        case 1000:
            zoom = 13.8f;
            break;
        case 1500:
            zoom = 13.2f;
            break;
        default:
            zoom = 19.0f;
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

- (void)creatAddressTableView{
    
    if (self.addressTableView != nil) {
        [self.addressTableView reloadData];
        self.tableContentView.frame = CGRectMake(10, Main_Screen_Height - 300, Main_Screen_Width - 20, 290);
    }else{
        self.tableContentView = [[UIView alloc] initWithFrame:CGRectMake(10, Main_Screen_Height - 300, Main_Screen_Width - 20, 290)];
        self.tableContentView.layer.cornerRadius = 10;
        self.tableContentView.layer.masksToBounds = YES;
        self.tableContentView.layer.borderWidth = 1;
        self.tableContentView.layer.borderColor = [[CAPColors black] CGColor];
        [self.view addSubview:self.tableContentView];
    
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableContentView.width, 70)];
        // 由于tableviewHeaderView的特殊性，在使他高度自适应之前你最好先给它设置一个宽度
        header.backgroundColor = [UIColor whiteColor];
        [self.tableContentView addSubview:header];
        
        UIButton *okButton = [[UIButton alloc] init];
        [okButton setTitle:CAPLocalizedString(@"ok") forState:UIControlStateNormal];
        [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [okButton setBackgroundColor:[CAPColors red]];
        [okButton addTarget:self action:@selector(okButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:okButton];
        
        UIButton *cancelButton = [[UIButton alloc] init];
        [cancelButton setTitle:CAPLocalizedString(@"cancel") forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton setBackgroundColor:[CAPColors red]];
        [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:cancelButton];
        
        UIView *line = [UIView new];
        line.backgroundColor = [CAPColors gray1];
        [header addSubview:line];
        
        cancelButton.sd_layout
        .topSpaceToView(header, 15)
        .centerXEqualToView(header)
        .widthIs(80)
        .heightIs(40)
        .leftSpaceToView(header, 30);
        
        okButton.sd_layout
        .topSpaceToView(header, 15)
        .centerXEqualToView(header)
        .widthIs(80)
        .heightIs(40)
        .rightSpaceToView(header, 30);
        
        line.sd_layout
        .bottomEqualToView(header)
        .widthIs(header.width)
        .heightIs(0.5);
        cancelButton.sd_cornerRadiusFromWidthRatio = @(0.1);
        okButton.sd_cornerRadiusFromWidthRatio = @(0.1);

        self.addressTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, header.bottom, self.tableContentView.width, self.tableContentView.height - header.height)];
        self.addressTableView.delegate = self;
        self.addressTableView.dataSource = self;
        [self.addressTableView setSeparatorColor : [CAPColors gray1]];
        
        [self.tableContentView addSubview:self.addressTableView];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.poiArrays.count > 5 ? 5 : self.poiArrays.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"FenceDetail";
    CAPAddFenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CAPAddFenceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if (self.poiArrays.count == 0) {
        return cell;
    }
    cell.googlePlace = self.poiArrays[indexPath.row];
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CAPGooglePlace *googlePlace = self.poiArrays[indexPath.row];
    return [self.addressTableView cellHeightForIndexPath:indexPath model:googlePlace keyPath:@"googlePlace" cellClass:[CAPAddFenceTableViewCell class] contentViewWidth:Main_Screen_Width - 20];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.marker = self.markerArrays[indexPath.row];
    self.chooseIndex = indexPath.row;
    GMSCameraPosition *camera =
    [[GMSCameraPosition alloc] initWithTarget:self.marker.position
                                         zoom:20
                                      bearing:50
                                 viewingAngle:60];
    [self.mapView animateToCameraPosition:camera];
}

- (void)okButtonAction{
    [self addFence:[self.poiArrays objectAtIndex:self.chooseIndex]];
}
- (void)cancelButtonAction{
    [UIView animateWithDuration:0.37 animations:^{
        self.tableContentView.frame = CGRectMake(10, Main_Screen_Height + 3000, Main_Screen_Width - 20, 290);
    }];
}
@end
