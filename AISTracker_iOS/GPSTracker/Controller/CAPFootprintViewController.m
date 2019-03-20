//
//  CAPFootprintViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPFootprintViewController.h"
#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GoogleMaps.h>
#import "HMWeeklySelectDateView.h"
#import "CAPDeviceService.h"
#import "CAPTimes.h"
#import "CAPFootprint.h"
#import "CAPFileUpload.h"
#import "SDAutoLayout.h"
#import "CAPDeviceLocal.h"
#import "CAPFileUpload.h"
@interface CAPFootprintViewController ()<GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *gmsMapView;
@property (nonatomic, strong) HMWeeklySelectDateView *dateSelectView;
@property (nonatomic, strong) CAPFootprint *footprint;
@property (nonatomic, strong) NSMutableArray<GMSMarker *>*markets;
@property (nonatomic, strong) NSMutableArray *locals;
@property (nonatomic, strong) UIView *showAddressView;
@property (nonatomic, strong) UILabel *showAddressLabel;
@property (nonatomic, strong) UILabel *showAddressTimeLabel;
@property (nonatomic, strong) UIImageView *showAddressImageView;
@end

@implementation CAPFootprintViewController
- (HMWeeklySelectDateView *)dateSelectView {
    if (!_dateSelectView) {
        _dateSelectView = [[HMWeeklySelectDateView alloc] initWithStartDate:[NSDate date]];
        [_dateSelectView dateCellClick:^(NSDate *selectedDate) {
            NSString *string = [NSString stringWithFormat:@"%@ 23:50:59",[selectedDate formattedDateWithFormat:@"yyyy-MM-dd"]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSDate *lastDate = [formatter dateFromString:string];
            NSTimeInterval firstStamp = [lastDate timeIntervalSince1970];
            for (GMSMarker *marker in self.markets) {
                [marker.map clear];
            }
            [self loadFootprint:[NSString stringWithFormat:@"%0.f", [self getZeroWithTimeInterverl:firstStamp]] endtime:[NSString stringWithFormat:@"%0.f",firstStamp]];
        }];
        _dateSelectView.backgroundColor = [CAPColors red];
    }
    return _dateSelectView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = CAPLocalizedString(@"footprint");
    [self.view addSubview:self.dateSelectView];
    self.markets = [NSMutableArray array];
    self.locals = [NSMutableArray array];
    [self.dateSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(TopHeight);
        make.height.equalTo(@100);
    }];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a =[dat timeIntervalSince1970];
    NSString *endTimeString = [NSString stringWithFormat:@"%0.f", a];//转为字符
    NSString *startTimeString = [NSString stringWithFormat:@"%0.f", [self getZeroWithTimeInterverl:a]];//转为字符
    [self loadFootprint:startTimeString endtime:endTimeString];
    CAPDeviceLocal *local = [CAPDeviceLocal local];
    GMSCameraPosition *camera =
    [GMSCameraPosition cameraWithLatitude:local.local.latitude longitude:local.local.longitude zoom:4];
    self.gmsMapView.camera = camera;
    self.gmsMapView.delegate = self;
}

- (void)loadFootprint:(NSString *)starttime endtime:(NSString *)endtime{
    [gApp showHUD:CAPLocalizedString(@"loading")];
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    [deviceService fetchFootprint:self.device.deviceID starttime:starttime endtime:endtime reply:^(CAPHttpResponse *response) {
        self.footprint = [CAPFootprint mj_objectWithKeyValues:response.data];
        //0 v --- 1 A
        if (self.footprint.code == 200) {
            if (self.footprint.result.count == 0) {
                [gApp showNotifyInfo:CAPLocalizedString(@"tips_no_footprint") backGroundColor:[UIColor orangeColor]];
                [gApp hideHUD];
                return;
            }
            for (NSInteger i = 0; i < self.footprint.result.count; i++) {
                CAPDeviceLocalModel *footprint = [self.footprint.result objectAtIndex:i];
                if ([footprint.type isEqualToString:@"1"]) {
                    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake([footprint.lat floatValue],[footprint.lng floatValue]);//纬度，经度
                    [self creatMarkerWithPosition:coords title:[NSString stringWithFormat:@"%ld",(i + 1)]];
                    [self.locals addObject:footprint];
                }else{
                    if (footprint.wifis.count != 0 && footprint.station.count != 0) {
                        NSDictionary *parames = [[NSDictionary alloc] init];
                        parames = [self paramesForWifi:footprint.wifis cellID:footprint.station];
                        CAPFileUpload *fileUpload = [[CAPFileUpload alloc] init];
                        [fileUpload loadDeviceParameter:parames device:self.device];
                        [fileUpload setSuccessBlockObject:^(id  _Nonnull object) {
                            NSLog(@"%@",object);
                            NSDictionary *objectDic = (NSDictionary *)object;
                            NSDictionary *location = objectDic[@"location"];
                            CGFloat lat = [location[@"lat"] floatValue];
                            CGFloat lng = [location[@"lng"] floatValue];
                            footprint.lat = location[@"lat"];
                            footprint.lng = location[@"lng"];
                            CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(lat,lng);//纬度，经度
                            [self creatMarkerWithPosition:coords title:[NSString stringWithFormat:@"%ld",(i + 1)]];
                            [self.locals addObject:footprint];
                        }];
                        [fileUpload setFailureBlock:^{
                            [self creatMarkerWithPosition:CLLocationCoordinate2DMake([footprint.lat floatValue],[footprint.lng floatValue]) title:[NSString stringWithFormat:@"%ld",(i + 1)]];
                            [self.locals addObject:footprint];
                        }];
                    }else{
                        [self creatMarkerWithPosition:CLLocationCoordinate2DMake([footprint.lat floatValue],[footprint.lng floatValue]) title:[NSString stringWithFormat:@"%ld",(i + 1)]];
                        [self.locals addObject:footprint];
                    }
                }
                if (self.locals.count == self.footprint.result.count) {
                    [gApp hideHUD];
                }
            }
        }
    }];
    
}

- (void)creatMarkerWithPosition:(CLLocationCoordinate2D)position title:(NSString *)title{
    GMSMarker *sydneyMarker = [[GMSMarker alloc] init];
    sydneyMarker.title = title;
    sydneyMarker.icon = [self addText:[UIImage imageNamed:@"number_blue0"] text:title];
    sydneyMarker.position = position;
    sydneyMarker.map = self.gmsMapView;
    [self.markets addObject:sydneyMarker];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.markets.firstObject.position.latitude longitude:self.markets.firstObject.position.longitude zoom:11];
    self.gmsMapView.camera = camera;
    
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    for (GMSMarker *oldMarker in self.markets) {
        oldMarker.icon = [self addText:[UIImage imageNamed:@"number_blue0"] text:oldMarker.title];
    }
    NSInteger index = [self.markets indexOfObject:marker];
    marker.icon = [self addText:[UIImage imageNamed:@"number_red0"] text:marker.title];

    CAPDeviceLocalModel *list = self.locals[index];
//    GMSGeocoder *geoCoder = [GMSGeocoder geocoder];
    [gApp showHUD:@""];
//    [geoCoder reverseGeocodeCoordinate:CLLocationCoordinate2DMake(list.lat, list.lng) completionHandler:^(GMSReverseGeocodeResponse * _Nullable response, NSError * _Nullable error) {
//        GMSAddress *placemark = response.firstResult;
//        [self showAddress:placemark footPrintList:list];
//    }];
    //创建位置
    CLLocation *location=[[CLLocation alloc]initWithLatitude:[list.lat floatValue] longitude:[list.lng floatValue]];
    
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    
    //反地理编码
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //判断是否有错误或者placemarks是否为空
        if (error !=nil || placemarks.count==0) {
            NSLog(@"%@",error);
            return ;
        }
        [gApp hideHUD];
        CLPlacemark *placemark = placemarks.firstObject;
        NSDictionary *addressDictionary = placemark.addressDictionary;
        NSArray *array = placemark.areasOfInterest;
        NSString *address = [NSString stringWithFormat:@"%@%@%@%@",addressDictionary[@"City"] ? addressDictionary[@"City"] : @"",addressDictionary[@"SubLocality"] ? addressDictionary[@"SubLocality"] : @"",addressDictionary[@"Street"] ? addressDictionary[@"Street"] : @"",array.firstObject ? array.firstObject : @""];
        [self showAddress:address footPrintList:list];
    }];
    
    return YES;
}

- (void)showAddress:(NSString *)address footPrintList:(CAPDeviceLocalModel *)list{
    if (!_showAddressView) {
        _showAddressView = [[UIView alloc] initWithFrame:CGRectMake(10, Main_Screen_Height - 80, Main_Screen_Width - 20, 60)];
        _showAddressView.backgroundColor = [UIColor whiteColor];
        _showAddressView.layer.cornerRadius = 5;
        _showAddressView.layer.masksToBounds = YES;
        [self.view addSubview:_showAddressView];
        
        _showAddressTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, _showAddressView.height)];
        _showAddressTimeLabel.textColor = [UIColor lightGrayColor];
        _showAddressTimeLabel.textAlignment = NSTextAlignmentCenter;
        [_showAddressView addSubview:_showAddressTimeLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake( 70 - 0.75, 0, 0.5, _showAddressView.height)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_showAddressView addSubview:line];
        
        _showAddressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, (60 - 20) / 2, 20, 20)];
        [_showAddressImageView setImage:GetImage(@"number_red0")];
        [_showAddressView addSubview:_showAddressImageView];
        
        _showAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, _showAddressView.width - 120, _showAddressView.height)];
        _showAddressLabel.textColor = [UIColor lightGrayColor];
        _showAddressLabel.textAlignment = NSTextAlignmentCenter;
        [_showAddressView addSubview:_showAddressLabel];
    }
    _showAddressLabel.text = address;
    if (list.createdAt) {
        NSString *time = [NSString dateFormateWithTimeInterval:list.createdAt];
        NSArray *array = [time componentsSeparatedByString:@" "];
        NSString *hours = array.lastObject;
        _showAddressTimeLabel.text = [NSString stringWithFormat:@"%@",[hours substringWithRange:NSMakeRange(0,5)]];
    }
}


- (void)rightClick {
    [self.dateSelectView configDate:[NSDate date]];
    [self setTitle:[[NSDate date] formattedDateWithFormat:@"yyyy-MM-dd"]];
}


- (void)refreshLocalizedString {
    
}
- (double)getZeroWithTimeInterverl:(NSTimeInterval) timeInterval
{
    NSDate *originalDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFomater = [[NSDateFormatter alloc]init];
    dateFomater.dateFormat = @"yyyy年MM月dd日";
    NSString *original = [dateFomater stringFromDate:originalDate];
    NSDate *ZeroDate = [dateFomater dateFromString:original];
    return [ZeroDate timeIntervalSince1970];
}

-(UIImage *)addText:(UIImage *)image text:(NSString *)string{
    UIImage *sourceImage = image;
    CGSize imageSize; //画的背景 大小
    imageSize = [sourceImage size];
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    [sourceImage drawAtPoint:CGPointMake(0, 0)];
    //获得 图形上下文
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextDrawPath(context, kCGPathStroke);
    CGFloat nameFont = 16.f;
    //画 自己想要画的内容
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:nameFont]};
    CGRect sizeToFit = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, nameFont) options:NSStringDrawingUsesDeviceMetrics attributes:attributes context:nil];
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [string drawAtPoint:CGPointMake((imageSize.width - sizeToFit.size.width) / 2,imageSize.height/4) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:nameFont]}];
    //返回绘制的新图形
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark  通过cellID和wifis 生成参数
- (NSDictionary *)paramesForWifi:(NSArray *)wifis cellID:(NSArray *)cellIDs{
    NSMutableDictionary *parames = [[NSMutableDictionary alloc] init];
    if(wifis.count != 0){
        NSMutableArray *parameArray = [NSMutableArray array];
        for (Wifis *wifiInfo in wifis){
            NSMutableDictionary *parame = [NSMutableDictionary dictionary];
            [parame setObject:wifiInfo.mac forKey:@"macAddress"];
            [parame setObject:[NSString stringWithFormat:@"%ld",wifiInfo.dBm] forKey:@"signalStrength"];
            [parame setObject:wifiInfo.channel forKey:@"channel"];
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
        for (Station *stationInfo in cellIDs) {
            NSMutableDictionary *parame = [NSMutableDictionary dictionary];
            [parame setObject:stationInfo.ta ? stationInfo.ta : @"0" forKey:@"timingAdvance"];
            [parame setObject:stationInfo.mcc ? stationInfo.mcc : @"" forKey:@"mobileCountryCode"];
            [parame setObject:stationInfo.mnc ? stationInfo.mnc : @"" forKey:@"mobileNetworkCode"];
            [parame setObject:stationInfo.ac ? stationInfo.ac : @"" forKey:@"locationAreaCode"];
            [parame setObject:stationInfo.no ? stationInfo.no : @"" forKey:@"cellId"];
            [parame setObject:stationInfo.ss ? stationInfo.ss : @"" forKey:@"signalStrength"];
            [parameArray addObject:parame];
        }
        [parames setValue:parameArray forKey:@"cellTowers"];
    }else{
        [parames setObject:@"" forKey:@"cellTowers"];
    }
    return parames;
}
@end
