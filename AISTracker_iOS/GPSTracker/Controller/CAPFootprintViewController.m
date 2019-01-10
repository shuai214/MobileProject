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
@interface CAPFootprintViewController ()
@property (weak, nonatomic) IBOutlet GMSMapView *gmsMapView;
@property (nonatomic, strong) HMWeeklySelectDateView *dateSelectView;
@property (nonatomic, strong) CAPFootprint *footprint;
@property (nonatomic, strong) NSMutableArray<GMSMarker *>*markets;

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
    }
    return _dateSelectView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"轨迹";
    [self.view addSubview:self.dateSelectView];
    self.markets = [NSMutableArray array];
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
}

- (void)loadFootprint:(NSString *)starttime endtime:(NSString *)endtime{
    [gApp showHUD];
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    [deviceService fetchFootprint:self.device.deviceID starttime:starttime endtime:endtime reply:^(CAPHttpResponse *response) {
        [gApp hideHUD];
        self.footprint = [CAPFootprint mj_objectWithKeyValues:response.data];
        if (self.footprint.code == 200) {
            for (NSInteger i = 0; i < self.footprint.result.count; i++) {
                ResultFootprintList *footPrint = [self.footprint.result objectAtIndex:i];
                if (i == 0) {
                    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:footPrint.lat longitude:footPrint.lng zoom:15];
                    self.gmsMapView.camera = camera;
                }
                [self creatMarkerWithPosition:CLLocationCoordinate2DMake(footPrint.lat,footPrint.lng) title:[NSString stringWithFormat:@"%ld",i]];
            }
        }
    }];
}

- (void)creatMarkerWithPosition:(CLLocationCoordinate2D)position title:(NSString *)title{
    GMSMarker *sydneyMarker = [[GMSMarker alloc] init];
    sydneyMarker.title = title;
    sydneyMarker.icon = [UIImage imageNamed:@"glow-marker"];
    sydneyMarker.position = position;
    sydneyMarker.map = self.gmsMapView;
    [self.markets addObject:sydneyMarker];
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

@end
