//
//  CAPUserSettingViewController.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/12.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPUserSettingViewController.h"
#import "CAPDeviceNumber.h"
#import "CAPUserService.h"
#import "CAPToast.h"
#import "CAPMMCountry.h"
#import "CAPValidators.h"
#import "CAPUser.h"
#import "CAPFetchUserProfileResponse.h"
@interface CAPUserSettingViewController ()
@property (weak, nonatomic) IBOutlet CAPDeviceNumber *number;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (strong, nonatomic)  CAPUser *capUser;

@end

@implementation CAPUserSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"填写用户信息";
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStyleDone) target:self action:@selector(back)];
    self.number.countryNameLabel.userInteractionEnabled = YES;
    self.number.isEdit = YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [self.number.countryNameLabel addGestureRecognizer:labelTapGestureRecognizer];
    [ self.number.buttonSend addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    [self get];
}
- (void)buttonAction:(UIButton *)button{
    [self get];
}
-(void)get{
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
        self.number.telAreaCodeLabel.text = [NSString stringWithFormat:@"%@",telCode];
        self.number.countryNameLabel.text = selectValue;
    }];
}
-(void)back
{
    
}
- (IBAction)okAction:(UIButton *)sender {
    self.capUser = (CAPUser *)[NSKeyedUnarchiver unarchiveObjectWithData:[CAPUserDefaults objectForKey:@"CAP_User"]];//setObject:data forKey:@"CAP_User"];
    if (self.userField.text.length != 0) {
        self.capUser.profile.firstName = self.userField.text;
    }else{
        [CAPToast toastError:@"请输入设备名称"];
        return;
    }
    if (self.number.telField.text.length != 0) {
        if ([CAPValidators validPhoneNumber:self.number.telField.text]) {
            self.capUser.info.mobile = [NSString stringWithFormat:@"%@ %@",self.number.telAreaCodeLabel.text,self.number.telField.text];
        }else{
            [CAPToast toastError:@"输入的号码不正确"];
            return;
        }
    }else{
        [CAPToast toastError:@"请输入号码"];
        return;
    }
    if (self.device) {
        [gApp showHUD:@"正在处理，请稍后..."];
        if (self.device.isOwner.length != 0) {
            
        }
        CAPUserService *userService = [[CAPUserService alloc] init];
        [gApp showHUD:CAPLocalizedString(@"loading")];
        [userService putProfile:self.capUser reply:^(CAPFetchUserProfileResponse *response) {
            if (response.code == 200) {
                [CAPUserDefaults setObject:@"YES" forKey:@"userSetting"];
                [gApp hideHUD];
                [self performSegueWithIdentifier:@"Main" sender:nil];
            }
            [gApp hideHUD];
        }];
    }
}


@end
