//
//  CAPChangeUserTelViewController.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/2/16.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPChangeUserTelViewController.h"
#import "CAPDeviceNumber.h"
#import "CAPMMCountry.h"
#import "CAPUserService.h"
#import "CAPDeviceService.h"
#import "CAPDeviceLists.h"
#import "CAPFetchUserProfileResponse.h"
@interface CAPChangeUserTelViewController ()
@property(nonatomic,strong)NSMutableArray *countryArray;
@property(nonatomic,strong)NSMutableArray *telCodeArray;
@property(nonatomic,strong)CAPDeviceNumber *deviceNumberView;

@end

@implementation CAPChangeUserTelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = gCfg.appBackgroundColor;
    [self get:nil];
    [self initFirstView];
    [self setRightBarImageButton:@"save_sos" action:@selector(saveButtonClicked)];
    self.title = self.userStr ? CAPLocalizedString(@"user_phone_number_edit_text"):CAPLocalizedString(@"text_device_number");
}

- (void)initFirstView{
    UILabel *mustBeThreeNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, TopHeight + 10, Main_Screen_Width, 20)];
    mustBeThreeNumber.text = self.userStr ? CAPLocalizedString(@"user_phone_number_edit_text"):CAPLocalizedString(@"tracker_number_edit_text");
    mustBeThreeNumber.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:mustBeThreeNumber];
    CGFloat numViewHeight = 80;
    UIView *view = [self setNumberView:CGRectMake(0, mustBeThreeNumber.bottom + 10, Main_Screen_Width, numViewHeight)];
    [self.view addSubview:view];
  
}
- (UIView *)setNumberView:(CGRect)frame{
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, height / 4, height / 2, height / 2)];
    [imgView setImage:GetImage(@"sos_phone")];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imgView.width / 2, 0, imgView.width / 2, imgView.height / 2)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:10];
    label.text = [NSString stringWithFormat:@"%ld",((long)index + 1)];
//    [imgView addSubview:label];
    [bgView addSubview:imgView];
    
    self.deviceNumberView = [[CAPDeviceNumber alloc] initWithFrame:CGRectMake(imgView.right + 10, 0, width - imgView.right - 30, height) isEdit:YES];
    self.deviceNumberView.countryNameLabel.userInteractionEnabled = YES;

    NSArray *array = [self.user.info.mobile ? self.user.info.mobile :self.device.mobile componentsSeparatedByString:@" "];
    self.deviceNumberView.telAreaCodeLabel.text = array.firstObject;
    self.deviceNumberView.telField.text = array.lastObject;
    NSArray *telCode = self.telCodeArray;
    NSUInteger index = [telCode indexOfObject:self.deviceNumberView.telAreaCodeLabel.text];
    if (!(index > telCode.count)) {
        NSString *countryName = [self.countryArray objectAtIndex:(NSInteger)index];
        self.deviceNumberView.countryNameLabel.text = countryName;
    }

    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [self.deviceNumberView.countryNameLabel addGestureRecognizer:labelTapGestureRecognizer];
    [self.deviceNumberView.buttonSend addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.deviceNumberView.buttonSend.enabled = YES;
    [bgView addSubview:self.deviceNumberView];
    return bgView;
}
-(void)labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    [self get:self.deviceNumberView];
}

- (void)buttonAction:(UIButton *)button{
    [self get:self.deviceNumberView];
}
-(void)get:(CAPDeviceNumber *)deviceNumber{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"diallingcode" ofType:@"json"]];
    NSError *error = nil;
    NSArray *arrayCode = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if ( error ) {
        return;
    }
    NSLog(@"%@", arrayCode);
    //读取文件
    NSMutableDictionary *dicCode = [@{} mutableCopy];
    for ( NSDictionary *item in arrayCode ){
        CAPMMCountry *c = [CAPMMCountry new];
        c.code      = item[@"code"];
        c.dial_code = item[@"dial_code"];
        [dicCode setObject:c forKey:c.code];
    }
    //获取国家名
    NSLocale *locale = [NSLocale currentLocale];
    NSArray *countryArray = [NSLocale ISOCountryCodes];
    self.countryArray = [[NSMutableArray alloc] init];
    self.telCodeArray = [[NSMutableArray alloc] init];
    
    for (NSString *countryCode in countryArray) {
        if (dicCode[countryCode] ){
            CAPMMCountry *c = dicCode[countryCode];
            if ([c.code isEqualToString:@"CN"]) {
                c.name = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
                [self.countryArray insertObject:c.name atIndex:0];
                [self.telCodeArray insertObject:c.dial_code atIndex:0];
            }
            c.name = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
            //            if ( [c.name isEqualToString:@"台湾"] ){
            //                c.name = @"中国台湾";
            //            }
            [self.countryArray addObject:c.name];
            [self.telCodeArray addObject:c.dial_code];
        }
    }
    NSArray *array = self.countryArray;
    if (!deviceNumber) {
        return;
    }
    [BRStringPickerView showStringPickerWithTitle:CAPLocalizedString(@"no_country") dataSource:array defaultSelValue:@"" resultBlock:^(id selectValue) {
        NSUInteger index = [array indexOfObject:selectValue];
        NSString *telCode = [self.telCodeArray objectAtIndex:(NSInteger)index];
        deviceNumber.telAreaCodeLabel.text = [NSString stringWithFormat:@"%@",telCode];
        deviceNumber.countryNameLabel.text = selectValue;
    }];
}
- (void)saveButtonClicked{
    if (self.userStr) {
        self.user.info.mobile = [NSString stringWithFormat:@"%@ %@",self.deviceNumberView.telAreaCodeLabel.text,self.deviceNumberView.telField.text];
        NSLog(@"%@",self.user.info.mobile);
        [capgApp showHUD:CAPLocalizedString(@"loading")];
        CAPUserService *userService = [[CAPUserService alloc] init];
        CAPWeakSelf(self);
        [userService putProfile:self.user reply:^(CAPFetchUserProfileResponse *response) {
            if (response.code == 200) {
                [capgApp showNotifyInfo:CAPLocalizedString(@"update_success") backGroundColor:[CAPColors green1]];
                [CAPNotifications notify:kNotificationChangeNickName];
                [CAPAlertView initAlertWithContent:CAPLocalizedString(@"update_success") okBlock:^{
                    self->_updateSuccessBlock ?: self->_updateSuccessBlock( weakself.user);
                    [self fetchDevice:self.user.info.mobile];
                    [weakself.navigationController popViewControllerAnimated:YES];
                } alertType:AlertTypeNoClose];
            }
            [capgApp hideHUD];
        }];
    }else{
        self.device.mobile = [NSString stringWithFormat:@"%@ %@",self.deviceNumberView.telAreaCodeLabel.text,self.deviceNumberView.telField.text];
        NSLog(@"%@",self.user.info.mobile);
        [capgApp showHUD:CAPLocalizedString(@"loading")];
        CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
        CAPWeakSelf(self);
        [deviceService updateDevice:self.device reply:^(CAPHttpResponse *response) {
            NSLog(@"%@",response);
            [capgApp hideHUD];
            NSDictionary *data = response.data;
            if ([[data objectForKey:@"code"] integerValue] == 200) {
                [capgApp showNotifyInfo:CAPLocalizedString(@"update_success") backGroundColor:[CAPColors green1]];
                [CAPNotifications notify:kNotificationChangeNickName];
//                [CAPAlertView initAlertWithContent:CAPLocalizedString(@"update_success") okBlock:^{
                    weakself.updateDeviceSuccessBlock(weakself.device);
                    [weakself.navigationController popViewControllerAnimated:YES];
//                } alertType:AlertTypeNoClose];
            }
            [CAPNotifications notify:kNotificationDeviceCountChange object:nil];
        }];
    }
}
- (void)fetchDevice:(NSString *)sos{
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    [deviceService fetchDevice:^(id response) {
        CAPHttpResponse *httpResponse = (CAPHttpResponse *)response;
        CAPDeviceLists *deviceLists = [CAPDeviceLists mj_objectWithKeyValues:httpResponse.data];
        NSLog(@"%@",deviceLists);
        for (NSInteger i = 0; i < deviceLists.result.list.count; i++) {
            CAPDevice *device = deviceLists.result.list[i];
            if (![device.role isEqualToString:@"user"]) {
                device.sos = sos;
                [deviceService updateDevice:device reply:^(id response) {
                    
                }];
            }else{
                device.sos = sos;
                [deviceService updateDevice:device reply:^(id response) {
                    
                }];
            }
        }
       
    }];
}
@end
