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
#import "CAPFileUpload.h"
#import "CAPDeviceService.h"
@interface CAPUserSettingViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet CAPDeviceNumber *number;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (strong, nonatomic)  CAPUser *capUser;
@property (strong, nonatomic)  NSArray *countryArrays;
@property (strong, nonatomic)  NSArray *countryCodeArrays;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (copy, nonatomic) NSString *avatarBaseUrl;
@property (copy, nonatomic) NSString *avatarPath;
@property (copy, nonatomic) NSString *sos;

@end

@implementation CAPUserSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"填写用户信息";
    self.view.backgroundColor = [UIColor whiteColor];

    self.countryArrays = [[NSArray alloc] init];
    self.countryCodeArrays = [[NSArray alloc] init];
    [self get];
    self.capUser = (CAPUser *)[NSKeyedUnarchiver unarchiveObjectWithData:[CAPUserDefaults objectForKey:@"CAP_User"]];
    if (self.capUser) {
        if (self.capUser.info.mobile.length != 0) {
            self.userField.text = self.capUser.profile.firstName;
            NSArray *array = [self.capUser.info.mobile componentsSeparatedByString:@" "];
            NSUInteger index = [self.countryCodeArrays indexOfObject:array.firstObject];
            NSString *country = [self.countryArrays objectAtIndex:(NSInteger)index];
            self.number.telField.text = array.lastObject;
            self.number.telAreaCodeLabel.text = array.firstObject;
            self.number.countryNameLabel.text = country;
        }else{
            self.sos = @"sos";
        }
    }
   
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStyleDone) target:self action:@selector(back)];
    self.number.countryNameLabel.userInteractionEnabled = YES;
    self.number.isEdit = YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [self.number.countryNameLabel addGestureRecognizer:labelTapGestureRecognizer];
    [ self.number.buttonSend addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.userImageView.userInteractionEnabled = YES;
    self.userImageView.layer.cornerRadius =  self.userImageView.width/2.0;
    self.userImageView.layer.masksToBounds = YES;
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",self.capUser.profile.avatarBaseUrl,self.capUser.profile.avatarPath]] placeholderImage:GetImage(@"user_default_avatar")];
    UITapGestureRecognizer *imageViewTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTouchUpInside)];
    [self.userImageView addGestureRecognizer:imageViewTapGestureRecognizer];
    
}
- (void)imageViewTouchUpInside{
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

-(void)labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    [BRStringPickerView showStringPickerWithTitle:CAPLocalizedString(@"no_country") dataSource:self.countryArrays defaultSelValue:@"" resultBlock:^(id selectValue) {
        NSUInteger index = [self.countryArrays indexOfObject:selectValue];
        NSString *telCode = [self.countryCodeArrays objectAtIndex:(NSInteger)index];
        self.number.telAreaCodeLabel.text = [NSString stringWithFormat:@"%@",telCode];
        self.number.countryNameLabel.text = selectValue;
    }];
}
- (void)buttonAction:(UIButton *)button{
    
    [BRStringPickerView showStringPickerWithTitle:CAPLocalizedString(@"no_country") dataSource:self.countryArrays defaultSelValue:@"" resultBlock:^(id selectValue) {
        NSUInteger index = [self.countryArrays indexOfObject:selectValue];
        NSString *telCode = [self.countryCodeArrays objectAtIndex:(NSInteger)index];
        self.number.telAreaCodeLabel.text = [NSString stringWithFormat:@"%@",telCode];
        self.number.countryNameLabel.text = selectValue;
    }];
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
//            if ( [c.name isEqualToString:@"台湾"] ){
//                c.name = @"中国台湾";
//            }
            [countriesArray addObject:c.name];
            [countryCodeArray addObject:c.dial_code];
        }
    }
    self.countryArrays = countriesArray;
    self.countryCodeArrays = countryCodeArray;
   
}

- (IBAction)okAction:(UIButton *)sender {
    
    if (self.userField.text.length != 0) {
        self.capUser.profile.firstName = self.userField.text;
    }else{
        [CAPToast toastError:@"请输入设备名称"];
        return;
    }
    if (self.number.telField.text.length != 0) {
        if ([CAPValidators validPhoneNumber:self.number.telField.text]) {
            self.capUser.info.mobile = [NSString stringWithFormat:@"%@ %@",self.number.telAreaCodeLabel.text,self.number.telField.text];
            self.device.sos = [NSString stringWithFormat:@"%@ %@",self.number.telAreaCodeLabel.text,self.number.telField.text];
        }else{
            [CAPToast toastError:@"输入的号码不正确"];
            return;
        }
    }else{
        [CAPToast toastError:@"请输入号码"];
        return;
    }
    if (self.device) {
        if (self.device.isOwner.length != 0) {
            self.device.sos = self.capUser.info.mobile;
        }
        CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
        [deviceService addDevice:self.device reply:^(CAPHttpResponse *response) {
            
        }];
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

//选择图片后,更换头像,并保存到沙盒,上传到服务器
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *iconImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *newIconImage = [self newSizeImage:CGSizeMake(self.userImageView.width, self.userImageView.height) image:iconImage];
    [self.userImageView setImage:newIconImage];
    
    CAPFileUpload *fileUpload = [[CAPFileUpload alloc] init];
    [fileUpload uploadRecording:newIconImage withImageIndex:arc4random() % 100];
    [fileUpload setSuccessBlockObject:^(id  _Nonnull object) {
        NSDictionary *dic = (NSDictionary *)object;
        if ([[dic objectForKey:@"code"] integerValue] == 200) {
            NSDictionary *resultDic = [dic objectForKey:@"result"];
            self.avatarBaseUrl = resultDic[@"base_url"];
            self.avatarPath = resultDic[@"path"];
            self.capUser.profile.avatarPath = self.avatarPath;
            self.capUser.profile.avatarBaseUrl = self.avatarBaseUrl;
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
@end
