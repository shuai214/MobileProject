//
//  CAPFenceDetailViewController.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/14.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPFenceDetailViewController.h"
#import <GooglePlaces/GooglePlaces.h>
#import <GoogleMaps/GoogleMaps.h>
#import "NSString+Size.h"
#import "CAPFenceService.h"
@interface CAPFenceDetailViewController ()
@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) GMSMarker *marker;
@property (strong, nonatomic) UILabel *label1;
@property (strong, nonatomic) UILabel *label2;

@end

@implementation CAPFenceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"围栏范围";
    self.mapView = [[GMSMapView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    CGFloat zoom = 12;
    switch (self.listItem.range) {
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
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.listItem.lat longitude:self.listItem.lng zoom:zoom];
    self.mapView.camera = camera;
//    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    //大头针
    self.marker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(self.listItem.lat,self.listItem.lng)];
    [self.marker setIcon:[UIImage imageNamed:@"map_drop_blue"]];
    self.marker.map = self.mapView;
    for (NSInteger i = 0; i < 3; i++) {
        CGFloat radius = self.listItem.range / 3 * (i+1);
        GMSCircle *circ = [GMSCircle circleWithPosition:self.marker.position
                                                 radius:radius];
        
         circ.fillColor = [UIColor colorWithRed:193.0f/255.0f green:43.0f/255.0f blue:30.0f/255.0f alpha:0.4 - i * 0.1];
        // 圆边的颜色
        if (i == 2) {
            circ.strokeColor = [UIColor greenColor];
        }else{
            circ.strokeColor = [UIColor clearColor];
        }
        // 圆边的宽度
        circ.strokeWidth = 5;
        circ.map = self.mapView;
    }
    [self layoutSubView:self.listItem.name range:self.listItem.range];
}

- (void)layoutSubView:(NSString *)fenceName range:(NSInteger)range{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height - 200, Main_Screen_Width, 200)];
    view.backgroundColor = [CAPColors black];
    [self.view addSubview:view];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40)];
    messageLabel.text = CAPLocalizedString(@"gps_fencing");
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor whiteColor];
    [view addSubview:messageLabel];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(10, messageLabel.bottom, Main_Screen_Width - 20, 0.5)];
    line1.backgroundColor = [UIColor whiteColor];
    [view addSubview:line1];
    
    UILabel *alertLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(15, line1.bottom + 5, 100, 35)];
    alertLabel1.text = CAPLocalizedString(@"label");
    alertLabel1.textAlignment = NSTextAlignmentLeft;
    alertLabel1.textColor = [UIColor whiteColor];
    [view addSubview:alertLabel1];
    
    self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(alertLabel1.right, alertLabel1.top, Main_Screen_Width - 15 - alertLabel1.right, alertLabel1.height)];
    self.label1 .textAlignment = NSTextAlignmentRight;
    self.label1 .text = fenceName;
    self.label1 .textColor = [UIColor whiteColor];
    self.label1 .userInteractionEnabled = YES;
    UITapGestureRecognizer *fenceNameTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fenceNameTouchUpInside:)];
    [self.label1  addGestureRecognizer:fenceNameTapGestureRecognizer];
    [view addSubview:self.label1 ];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(10, self.label1.bottom + 5, Main_Screen_Width - 20, 0.5)];
    line2.backgroundColor = [UIColor whiteColor];
    [view addSubview:line2];
    
    UILabel *alertLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(15, line2.bottom + 5, 100, 35)];
    alertLabel2.text = CAPLocalizedString(@"radius");
    alertLabel2.textAlignment = NSTextAlignmentLeft;
    alertLabel2.textColor = [UIColor whiteColor];
    [view addSubview:alertLabel2];
    
   self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(alertLabel2.right, alertLabel2.top, Main_Screen_Width - 15 - alertLabel2.right, alertLabel2.height)];
    self.label2.textAlignment = NSTextAlignmentRight;
    self.label2.textColor = [UIColor whiteColor];
    self.label2.text = [NSString stringWithFormat:@"%ld%@",range,CAPLocalizedString(@"m")];
    self.label2.userInteractionEnabled = YES;
    UITapGestureRecognizer *fenceRangeTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fenceRangeTouchUpInside:)];
    [self.label2 addGestureRecognizer:fenceRangeTapGestureRecognizer];
    [view addSubview:self.label2];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(10, self.label2.bottom + 5, Main_Screen_Width - 20, 0.5)];
    line3.backgroundColor = [UIColor whiteColor];
    [view addSubview:line3];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30, line3.bottom + 10, Main_Screen_Width - 60, 40)];
    button.backgroundColor = [CAPColors red];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:CAPLocalizedString(@"save") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5.0;
    [view addSubview:button];
}
- (void)fenceNameTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    [CAPAlertView initAddressEditWithContent:self.listItem.name ocloseBlock:^{
        
    } okBlock:^(NSString * _Nonnull name) {
        self.listItem.name = name;
        self.label1.text = name;
    }];
}
- (void)fenceRangeTouchUpInside:(UITapGestureRecognizer *)recognizer{
    [BRStringPickerView showStringPickerWithTitle:@"选择围栏范围" dataSource:@[@"50",@"100",@"500", @"1000", @"1500"] defaultSelValue:@"1000" resultBlock:^(id selectValue) {
        self.listItem.range = [selectValue integerValue];
        self.label2.text = [NSString stringWithFormat:@"%ld%@",[selectValue integerValue],CAPLocalizedString(@"m")];
    }];
}

- (void)editAction{
    CAPFenceService *editFenceService =[[CAPFenceService alloc] init];
    [editFenceService editFence:self.listItem reply:^(CAPHttpResponse *response) {
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
}

/**
 *  计算文本的宽高
 *
 *  @param str     需要计算的文本
 *  @param font    文本显示的字体
 *  @param maxSize 文本显示的范围
 *
 *  @return 文本占用的真实宽高
 */
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    if (str.length == 0) {
        return CGSizeMake(0, 0);
    }
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}
@end
