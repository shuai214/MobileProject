//
//  CAPDeviceSettingViewController.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/8.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPDeviceSettingViewController.h"
#import "CAPDeviceNumber.h"
#import "CAPMMCountry.h"
#import "CAPDeviceService.h"
#import "CAPValidators.h"
#import "CAPToast.h"
#import "CAPUserSettingViewController.h"
@interface CAPDeviceSettingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *deviceImage;
@property (weak, nonatomic) IBOutlet UITextField *deviceName;
@property (weak, nonatomic) IBOutlet CAPDeviceNumber *deviceNumber;

@end

@implementation CAPDeviceSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.device.role isEqualToString:@"owner"] && self.device.isOwner.length == 0) {
        self.title = @"填写设备信息";
    }else if (self.device.isOwner != nil){
        self.title = @"填写用户信息";
    }else{
        self.title = @"填写设备信息";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.deviceNumber.countryNameLabel.userInteractionEnabled = YES;
    self.deviceNumber.isEdit = YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [self.deviceNumber.countryNameLabel addGestureRecognizer:labelTapGestureRecognizer];
    [ self.deviceNumber.buttonSend addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStyleDone) target:self action:@selector(back)];
    
}
-(void)back{
    
}
-(void)get {
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
    NSMutableArray*countriesArray = [[NSMutableArray alloc] init];
    NSMutableArray*countryCodeArray = [[NSMutableArray alloc] init];

    for (NSString *countryCode in countryArray) {
        if (dicCode[countryCode] ){
            CAPMMCountry *c = dicCode[countryCode];
            if ([c.code isEqualToString:@"CN"]) {
                c.name = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
                [countriesArray insertObject:c.name atIndex:0];
                [countryCodeArray insertObject:c.dial_code atIndex:0];
            }
            c.name = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
            if ( [c.name isEqualToString:@"台湾"] ){
                c.name = @"中国台湾";
            }
            [countriesArray addObject:c.name];
            [countryCodeArray addObject:c.dial_code];
        }
    }
    NSArray *array = countriesArray;
    [BRStringPickerView showStringPickerWithTitle:@"选择国家" dataSource:array defaultSelValue:@"" resultBlock:^(id selectValue) {
        NSUInteger index = [array indexOfObject:selectValue];
        NSString *telCode = [countryCodeArray objectAtIndex:(NSInteger)index];
        self.deviceNumber.telAreaCodeLabel.text = [NSString stringWithFormat:@"%@",telCode];
        self.deviceNumber.countryNameLabel.text = selectValue;
    }];
}
- (IBAction)nextAction:(UIButton *)sender {
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    if (self.deviceName.text.length != 0) {
        self.device.name = self.deviceName.text;
    }else{
        [CAPToast toastError:@"请输入设备名称"];
        return;
    }
    if ([CAPValidators validPhoneNumber:self.deviceNumber.telField.text]) {
        self.device.mobile = [NSString stringWithFormat:@"%@ %@",self.deviceNumber.telAreaCodeLabel.text,self.deviceNumber.telField.text];
    }else{
        [CAPToast toastError:@"输入的号码不正确"];
        return;
    }
    if (self.device) {
        [gApp showHUD:@"正在处理，请稍后..."];
        [deviceService updateDevice:self.device reply:^(CAPHttpResponse *response) {
            NSDictionary *data = response.data;
            if ([[data objectForKey:@"code"] integerValue] == 200) {
                NSString *userSettingStr = [CAPUserDefaults objectForKey:@"userSetting"];
                if (userSettingStr) {
                    [self performSegueWithIdentifier:@"Main" sender:nil];
                    return ;
                }
                [gApp hideHUD];
                [CAPNotifications notify:kNotificationDeviceCountChange object:self.device];
                CAPUserSettingViewController *userSetting = [[UIStoryboard storyboardWithName:@"Pair" bundle:nil] instantiateViewControllerWithIdentifier:@"UserSettingViewController"];
                userSetting.device = self.device;
                userSetting.device.isOwner = @"owner";
                [self.navigationController pushViewController:userSetting animated:YES];
            }else{
                [gApp showHUD:[data objectForKey:@"message"] cancelTitle:@"确定" onCancelled:^{
                    [gApp hideHUD];
                }];
            }
        }];
        
    }else{
        if (self.deviceStr) {
            [gApp showHUD:@"正在处理，请稍后..."];
            NSDictionary *param = @{
                                    @"name":self.deviceName.text,
                                    @"sos":self.deviceNumber.telField.text
                                    };
            [deviceService bindDevice:self.deviceStr param:param reply:^(CAPHttpResponse *response) {
                NSDictionary *data = response.data;
                if ([[data objectForKey:@"code"] integerValue] == 200) {
                    self.device = [CAPDevice mj_objectWithKeyValues:[data objectForKey:@"result"]];
                    [gApp hideHUD];
                    [self.navigationController popViewControllerAnimated:YES];
                    !self->_inputDeviceBlock ? : self->_inputDeviceBlock(self.device);
                }else{
                    [gApp showHUD:[data objectForKey:@"message"] cancelTitle:@"确定" onCancelled:^{
                        [gApp hideHUD];
                    }];
                }
            }];
        }
    }
}

-(void)labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    [self get];
}
- (void)buttonAction:(UIButton *)button{
    [self get];
}

@end
