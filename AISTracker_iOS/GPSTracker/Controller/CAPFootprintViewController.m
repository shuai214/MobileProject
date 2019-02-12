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
    self.title = @"轨迹";
    [self.view addSubview:self.dateSelectView];
    self.markets = [NSMutableArray array];
    self.locals = [NSMutableArray array];
    [self.dateSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(TopHeight);
        make.height.equalTo(@100);
    }];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a =[dat timeIntervalSince1970];
    NSString *endTimeString = [NSString stringWithFormat:@"%0.f", a];//转为字符
    NSString *startTimeString = [NSString stringWithFormat:@"%0.f", [self getZeroWithTimeInterverl:a]];//转为字符
    [self loadFootprint:startTimeString endtime:endTimeString];
    self.gmsMapView.delegate = self;
}

- (void)loadFootprint:(NSString *)starttime endtime:(NSString *)endtime{
    [gApp showHUD:CAPLocalizedString(@"loading")];
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    [deviceService fetchFootprint:self.device.deviceID starttime:starttime endtime:endtime reply:^(CAPHttpResponse *response) {
        [gApp hideHUD];
        self.footprint = [CAPFootprint mj_objectWithKeyValues:response.data];
        if (self.footprint.code == 200) {
            if (self.footprint.result.count == 0) {
                [gApp showNotifyInfo:CAPLocalizedString(@"tips_no_footprint") backGroundColor:[UIColor orangeColor]];
            }
            for (NSInteger i = 0; i < self.footprint.result.count; i++) {
                ResultFootprintList *footPrint = [self.footprint.result objectAtIndex:i];
                if (i == 0) {
                    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:footPrint.lat longitude:footPrint.lng zoom:15];
                    self.gmsMapView.camera = camera;
                }
                [self creatMarkerWithPosition:CLLocationCoordinate2DMake(footPrint.lat,footPrint.lng) title:[NSString stringWithFormat:@"%ld",(i + 1)]];
//                CAPFileUpload *fileUplod = [[CAPFileUpload alloc] init];
//                [fileUplod getDeviceLoacl:[NSString stringWithFormat:@"%lf,%lf",footPrint.lat,footPrint.lng]];
//                [fileUplod setSuccessBlockObject:^(id  _Nonnull object) {
//
//                }];
                
                [self.locals addObject:footPrint];
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
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    for (GMSMarker *oldMarker in self.markets) {
        oldMarker.icon = [self addText:[UIImage imageNamed:@"number_blue0"] text:oldMarker.title];
    }
    NSInteger index = [self.markets indexOfObject:marker];
//    marker.icon = [UIImage imageNamed:@"number_red0"];
    marker.icon = [self addText:[UIImage imageNamed:@"number_red0"] text:marker.title];

    ResultFootprintList *list = self.locals[index];
    GMSGeocoder *geoCoder = [GMSGeocoder geocoder];
    [gApp showHUD:@""];
    [geoCoder reverseGeocodeCoordinate:CLLocationCoordinate2DMake(list.lat, list.lng) completionHandler:^(GMSReverseGeocodeResponse * _Nullable response, NSError * _Nullable error) {
        [gApp hideHUD];
        GMSAddress *placemark = response.firstResult;
        [self showAddress:placemark footPrintList:list];
    }];
    return YES;
}

- (void)showAddress:(GMSAddress *)address footPrintList:(ResultFootprintList *)list{
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
    _showAddressLabel.text = [NSString stringWithFormat:@"%@%@%@",address.locality,address.subLocality,address.thoroughfare];
    if (list.createdAt) {
        NSString *time = [NSString dateFormateWithTimeInterval:[list.createdAt integerValue]];
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
@end
