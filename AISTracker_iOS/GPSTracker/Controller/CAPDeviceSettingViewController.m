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
#import "CAPFileUpload.h"
#import "CAPUser.h"
@interface CAPDeviceSettingViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *deviceName;
@property (weak, nonatomic) IBOutlet CAPDeviceNumber *deviceNumber;
@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (copy, nonatomic) NSString *avatarBaseUrl;
@property (copy, nonatomic) NSString *avatarPath;

@end

@implementation CAPDeviceSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.device.role isEqualToString:@"owner"] && self.device.isOwner.length == 0) {
        self.title = CAPLocalizedString(@"device_setting");
    }else if (self.device.isOwner != nil){
        self.title = CAPLocalizedString(@"account_setting");
    }else{
        self.title = CAPLocalizedString(@"device_setting");
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.deviceNumber.countryNameLabel.userInteractionEnabled = YES;
    self.deviceNumber.isEdit = YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [self.deviceNumber.countryNameLabel addGestureRecognizer:labelTapGestureRecognizer];
    [ self.deviceNumber.buttonSend addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStyleDone) target:self action:@selector(back)];
    self.deviceImageView.userInteractionEnabled = YES;
    self.deviceImageView.layer.cornerRadius =  self.deviceImageView.width/2.0;
    self.deviceImageView.layer.masksToBounds = YES;
    UITapGestureRecognizer *imageViewTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTouchUpInside)];
    [self.deviceImageView addGestureRecognizer:imageViewTapGestureRecognizer];
}
-(void)imageViewTouchUpInside{
    UIImagePickerController *imagePickerVc = [[UIImagePickerController alloc] init];
    imagePickerVc.delegate = self;
    imagePickerVc.allowsEditing = YES;
    [CAPAlertView initTakingPhotoBlock:^{
        imagePickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    } albumBlock:^{
        imagePickerVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    } closeBlock:^{
        
    }];
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
//            if ( [c.name isEqualToString:@"台湾"] ){
//                c.name = @"中国台湾";
//            }
            [countriesArray addObject:c.name];
            [countryCodeArray addObject:c.dial_code];
        }
    }
    NSArray *array = countriesArray;
    [BRStringPickerView showStringPickerWithTitle:CAPLocalizedString(@"no_country") dataSource:array defaultSelValue:@"" resultBlock:^(id selectValue) {
        NSUInteger index = [array indexOfObject:selectValue];
        NSString *telCode = [countryCodeArray objectAtIndex:(NSInteger)index];
        self.deviceNumber.telAreaCodeLabel.text = [NSString stringWithFormat:@"%@",telCode];
        self.deviceNumber.countryNameLabel.text = selectValue;
    }];
}
- (IBAction)nextAction:(UIButton *)sender {
    CAPUser *capUser = (CAPUser *)[NSKeyedUnarchiver unarchiveObjectWithData:[CAPUserDefaults objectForKey:@"CAP_User"]];
    if (capUser) {
        if (capUser.info.mobile.length != 0) {
            self.device.sos = capUser.info.mobile;
        }
    }
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    if (self.deviceName.text.length != 0) {
        self.device.name = self.deviceName.text;
    }else{
        [CAPToast toastError:CAPLocalizedString(@"device_name_hint")];
        return;
    }
    if ([CAPValidators validPhoneNumber:self.deviceNumber.telField.text]) {
        self.device.mobile = [NSString stringWithFormat:@"%@ %@",self.deviceNumber.telAreaCodeLabel.text,self.deviceNumber.telField.text];
    }else{
        [CAPToast toastError:CAPLocalizedString(@"phone_number_error")];
        return;
    }
    if (kStringIsEmpty(self.deviceStr)) {
//        [gApp showHUD:CAPLocalizedString(@"loading")];
//        [deviceService updateDevice:self.device reply:^(CAPHttpResponse *response) {
//            NSDictionary *data = response.data;
//            if ([[data objectForKey:@"code"] integerValue] == 200) {
                NSString *userSettingStr = [CAPUserDefaults objectForKey:@"userSetting"];
                if (userSettingStr) {
                    [gApp showHUD:CAPLocalizedString(@"loading")];
                    CAPDeviceService *service = [[CAPDeviceService alloc] init];
                    [service addDevice:self.device reply:^(CAPHttpResponse *response) {
                        [gApp hideHUD];
                        if ([[response.data objectForKey:@"code"] integerValue] == 200) {
                            CAPDevice *getDevice = [CAPDevice mj_objectWithKeyValues:[response.data objectForKey:@"result"]];
                            [CAPNotifications notify:kNotificationDeviceCountChange object:getDevice];
                            [self performSegueWithIdentifier:@"Main" sender:nil];
                        }
                    }];
                    return ;
                }
//                [gApp hideHUD];
//                [CAPNotifications notify:kNotificationDeviceCountChange object:self.device];
                CAPUserSettingViewController *userSetting = [[UIStoryboard storyboardWithName:@"Pair" bundle:nil] instantiateViewControllerWithIdentifier:@"UserSettingViewController"];
                userSetting.device = self.device;
                userSetting.device.isOwner = @"owner";
                [self.navigationController pushViewController:userSetting animated:YES];
//            }else{
//                [gApp showHUD:[data objectForKey:@"message"] cancelTitle:@"确定" onCancelled:^{
//                    [gApp hideHUD];
//                }];
//            }
//        }];
        
    }else{
        if (self.deviceStr) {
            [gApp showHUD:CAPLocalizedString(@"loading")];
            NSDictionary *param = @{
                                    @"name":self.deviceName.text ? self.deviceName.text: @"",
                                    @"sos":self.deviceNumber.telField.text ? [NSString stringWithFormat:@"%@ %@",self.deviceNumber.telAreaCodeLabel.text,self.deviceNumber.telField.text]:@"",
                                    @"avatarPath":self.avatarPath ? self.avatarPath: @"",
                                    @"avatarBaseUrl":self.avatarBaseUrl ? self.avatarPath: @""
                                    };
//            NSString *strJson= [self dictionaryToJson:param];
//            NSMutableDictionary *json = [NSMutableDictionary dictionary];
//            [json setObject:strJson forKey:@"json"];
            [deviceService bindDevice:self.deviceStr param:param reply:^(CAPHttpResponse *response) {
                NSDictionary *data = response.data;
                if ([[data objectForKey:@"code"] integerValue] == 200) {
                    self.device = [CAPDevice mj_objectWithKeyValues:[data objectForKey:@"result"]];
                    [gApp hideHUD];
                    [self.navigationController popViewControllerAnimated:YES];
                    !self->_inputDeviceBlock ? : self->_inputDeviceBlock(self.device);
                }else{
                    [gApp showHUD:[data objectForKey:@"message"] cancelTitle:CAPLocalizedString(@"ok") onCancelled:^{
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
//选择图片后,更换头像,并保存到沙盒,上传到服务器
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *iconImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *newIconImage = [self newSizeImage:CGSizeMake(self.deviceImageView.width, self.deviceImageView.height) image:iconImage];
    [self.deviceImageView setImage:newIconImage];
    
    CAPFileUpload *fileUpload = [[CAPFileUpload alloc] init];
    [fileUpload uploadRecording:newIconImage withImageIndex:arc4random() % 100];
    [fileUpload setSuccessBlockObject:^(id  _Nonnull object) {
        NSLog(@"%@",object);
        NSDictionary *dic = (NSDictionary *)object;
        if ([[dic objectForKey:@"code"] integerValue] == 200) {
            NSDictionary *resultDic = [dic objectForKey:@"result"];
            self.avatarBaseUrl = resultDic[@"base_url"];
            self.avatarPath = resultDic[@"path"];
            self.device.avatarPath = self.avatarPath;
            self.device.avatarBaseUrl = self.avatarBaseUrl;
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 调整图片分辨率/尺寸（等比例缩放）
- (UIImage *)newSizeImage:(CGSize)size image:(UIImage *)sourceImage {
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / size.height;
    CGFloat tempWidth = newSize.width / size.width;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    } else if (tempHeight > 1.0 && tempWidth < tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
