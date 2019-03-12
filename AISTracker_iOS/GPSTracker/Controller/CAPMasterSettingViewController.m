//
//  CAPMasterSettingViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPMasterSettingViewController.h"
#import "CAPBatteryView.h"
#import "CAPEditNameViewController.h"
#import "CAPGuardianListViewController.h"
#import "CAPDeviceService.h"
#import "CAPGuardianListViewController.h"
#import "CAPSOSMobileViewController.h"
#import "CAPUploadFrequencyViewController.h"
#import "CAPFileUpload.h"
#import "CAPDeviceBindInfo.h"
#import "CAPChangeUserTelViewController.h"
@interface CAPMasterSettingViewController () <UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet CAPBatteryView *batteryView;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nextDeviceImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<NSString *> *titles;
@property (strong, nonatomic) NSArray<NSString *> *details;
@property (copy, nonatomic)NSString *time;
@property (copy, nonatomic)NSString *deviceVer;
@end

@implementation CAPMasterSettingViewController
//-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
//{
//    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
//    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return scaledImage;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.time = @"";
    if (self.device.setting.reportFrequency) {
        if (self.device.setting.reportFrequency / 60 < 60) {
            self.time = [NSString stringWithFormat:@"%ld%@",self.device.setting.reportFrequency / 60,CAPLocalizedString(@"minutes")];
        }
        if (self.device.setting.reportFrequency / 60 > 60) {
            self.time = [NSString stringWithFormat:@"%ld%@",self.device.setting.reportFrequency / 60 / 60,CAPLocalizedString(@"hour")];
        }
    }
    self.title = CAPLocalizedString(@"profile");
    self.titles = @[CAPLocalizedString(@"name"), CAPLocalizedString(@"setting_device_id"), CAPLocalizedString(@"setting_device_imei"),
                   CAPLocalizedString(@"setting_device_number"), CAPLocalizedString(@"guardian_s_qualification"),CAPLocalizedString(@"sos_number"),CAPLocalizedString(@"update_frequency"),CAPLocalizedString(@"unbind"),CAPLocalizedString(@"firmware_version")];
    self.details = @[self.device? self.device.name:@"", self.device?self.device.deviceID:@"", @"XXXX", self.device?self.device.mobile:@"", @"",@"",self.time,@"",@""];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    UIImage *avatar = GetImage(@"ic_default_avatar_new");
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",self.device.setting.avatarBaseUrl,self.device.setting.avatarPath]] placeholderImage:avatar];
    self.avatarImageView.layer.cornerRadius =  self.avatarImageView.width/2.0;
    self.avatarImageView.layer.masksToBounds = YES;
    
    self.deviceLabel.text = [@"Device ID: " stringByAppendingString:self.device ? self.device.deviceID:@""];
    [self.batteryView reloadBattery:self.battery];
    
    self.headerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [self.headerView addGestureRecognizer:labelTapGestureRecognizer];
    [self refreshLocalizedString];
    [self checkDevice];
    [CAPNotifications addObserver:self selector:@selector(getDeviceVerno:) name:kNotificationVernoName object:nil];
    [CAPNotifications addObserver:self selector:@selector(updateDeviceVerno:) name:kNotificationUPGRADEREQName object:nil];
}

- (void)labelTouchUpInside:(NSNotification *)notifi{
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
- (void)loadDeviceInfo{
    [gApp showHUD:@"loading"];

    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    [deviceService getDevice:self.device reply:^(id response) {

    }];
    //    [deviceService getDeviceBindinfo:self.device reply:^(CAPHttpResponse *response) {
    //        self.deviceBindInfo = [CAPDeviceBindInfo mj_objectWithKeyValues:response.data];
    //        if (self.deviceBindInfo.code == 200) {
    //            self.details = @[self.deviceBindInfo.result.bindinfo.name? self.deviceBindInfo.result.bindinfo.name:@"", self.deviceBindInfo.result.deviceID?self.deviceBindInfo.result.deviceID:@"", @"XXXX", self.deviceBindInfo.result.mobile?self.deviceBindInfo.result.mobile:@"", @"",@"",@"",@"",@""];
    //            [self.tableView reloadData];
    //            [gApp hideHUD];
    //        }
    //    }];
}

- (void)refreshLocalizedString {
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    [deviceService getDeviceBindinfo:self.device reply:^(CAPHttpResponse *response) {
         CAPDeviceBindInfo *getDevice = [CAPDeviceBindInfo mj_objectWithKeyValues:[response.data objectForKey:@"result"]];
        NSLog(@"%@",getDevice);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const cellIdentifier = @"right_detail_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.titles[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.text = self.details[indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
        case 0:
//            [self performSegueWithIdentifier:@"edit.name.segue" sender:nil];
        {UIStoryboard *story = [UIStoryboard storyboardWithName:@"EditName" bundle:nil];
            CAPEditNameViewController *EditNameVC = [story instantiateViewControllerWithIdentifier:@"EditNameViewController"];
            EditNameVC.isUser = NO;
            EditNameVC.capDevice = self.device;
            CAPWeakSelf(self);
            [EditNameVC setUpdateSuccessBlock:^(id cap) {
                CAPDevice *device = (CAPDevice*)cap;
                weakself.details = @[device? device:@"", device?device.deviceID:@"", @"XXXX", device?device.mobile:@"", @"",@"",device.setting,@"",@""];
                [weakself.tableView reloadData];
            }];
        [self.navigationController pushViewController:EditNameVC animated:YES];
        }
            break;
        case 1:
//            [self performSegueWithIdentifier:@"guardian.list.segue" sender:nil];GuardianListViewController
//        {UIStoryboard *story = [UIStoryboard storyboardWithName:@"MasterSetting" bundle:nil];
//            CAPGuardianListViewController *GuardianVC = [story instantiateViewControllerWithIdentifier:@"GuardianListViewController"];
//            [self.navigationController pushViewController:GuardianVC animated:YES];
//        }
            break;
        case 2:
            break;
        case 3:{
            CAPChangeUserTelViewController *editName = [[CAPChangeUserTelViewController alloc] init];
            editName.device = self.device;
            CAPWeakSelf(self);
            [editName setUpdateDeviceSuccessBlock:^(CAPDevice * _Nonnull device) {
                weakself.device = device;
                weakself.titles = @[CAPLocalizedString(@"name"), CAPLocalizedString(@"setting_device_id"), @"Device IMEI",
                                @"Device Number", CAPLocalizedString(@"guardian_s_qualification"),CAPLocalizedString(@"sos_number"),CAPLocalizedString(@"update_frequency"),CAPLocalizedString(@"no_tethering"),CAPLocalizedString(@"firmware_version")];
                weakself.details = @[device? device.name:@"", device?device.deviceID:@"", @"XXXX", device?device.mobile:@"", @"",@"",self.time,@"",@""];
                [weakself checkDevice];
                [weakself.tableView reloadData];
            }];
            [self.navigationController pushViewController:editName animated:YES];
        }
            break;
        case 4:
        {UIStoryboard *story = [UIStoryboard storyboardWithName:@"MasterSetting" bundle:nil];
            CAPGuardianListViewController *GuardianVC = [story instantiateViewControllerWithIdentifier:@"GuardianListViewController"];
            GuardianVC.device = self.device;
            [self.navigationController pushViewController:GuardianVC animated:YES];
        }
            break;
        case 5:
        {
            CAPSOSMobileViewController *sosVC = [[UIStoryboard storyboardWithName:@"MasterSetting" bundle:nil] instantiateViewControllerWithIdentifier:@"SOSMobileViewController"];
            sosVC.device = self.device;
            [self.navigationController pushViewController:sosVC animated:YES];
        }
            break;
        case 6:
        {
            CAPUploadFrequencyViewController *uploadVC = [[CAPUploadFrequencyViewController alloc] init];
            uploadVC.device = self.device;
            [self.navigationController pushViewController:uploadVC animated:YES];
        }
            break;
        case 7:
        {
            [CAPAlertView initAlertWithContent:CAPLocalizedString(@"confirm_delete_device") title:@"" closeBlock:^{
                
            } okBlock:^{
                [gApp showHUD:CAPLocalizedString(@"loading")];
                CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
                [deviceService deleteDevice:self.device reply:^(CAPHttpResponse *response) {
                    NSDictionary *data = response.data;
                    if ([[data objectForKey:@"code"] integerValue] == 200) {
                        [gApp hideHUD];
                        [CAPNotifications notify:kNotificationDeviceCountChange object:nil];
                        [CAPUserDefaults removeObjectForKey:@"userSetting"];//setObject:@"YES" forKey:@"userSetting"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [gApp showHUD:[data objectForKey:@"message"] cancelTitle:CAPLocalizedString(@"ok") onCancelled:^{
                            
                        }];
                    }
                    
                }];
            } alertType:AlertTypeCustom];
        }
            break;
        case 8:{
            if (kStringIsEmpty(self.deviceVer)) {
                [CAPToast toastWarning:CAPLocalizedString(@"wait_response_from_device")];
                [self checkDevice];
            }else{
                [CAPAlertView initDeviceVerWithContent:CAPLocalizedString(@"confirm_upgrade") closeBlock:^{
                    
                } okBlock:^{
                    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
                    [deviceService deviceSendCommand:self.device.deviceID cmd:@"UPGRADECHK" param:nil reply:^(id response) {
                        NSLog(@"%@",response);
                    }];
                }];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark -----imagePickerController delegate
//选择图片后,更换头像,并保存到沙盒,上传到服务器
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"%f --- %f",self.avatarImageView.width,self.avatarImageView.height);
    UIImage *iconImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *newIconImage = [self newSizeImage:CGSizeMake(self.avatarImageView.width, self.avatarImageView.height) image:iconImage];
    [self.avatarImageView setImage:newIconImage];
    
    CAPFileUpload *fileUpload = [[CAPFileUpload alloc] init];
    [fileUpload uploadRecording:newIconImage withImageIndex:arc4random() % 100];
    [fileUpload setSuccessBlockObject:^(id  _Nonnull object) {
        NSLog(@"%@",object);
        NSDictionary *dic = (NSDictionary *)object;
        if ([[dic objectForKey:@"code"] integerValue] == 200) {
            NSDictionary *resultDic = [dic objectForKey:@"result"];
            self.device.avatarBaseUrl = resultDic[@"base_url"];
            self.device.avatarPath = resultDic[@"path"];
            CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
            [deviceService updateSetting:self.device reply:^(id response) {
                NSLog(@"%@",response);
                [gApp hideHUD];
                [CAPNotifications notify:kNotificationDeviceCountChange object:nil];
            }];
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 获取设备的版本
- (void)checkDevice{
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    [deviceService deviceSendCommand:self.device.deviceID cmd:@"VERNO" param:nil reply:^(id response) {
        NSLog(@"%@",response);
    }];
}
- (void)getDeviceVerno:(NSNotification *)notifi{
    MQTTInfo *info = notifi.object;
    NSLog(@"%@",info);
    self.deviceVer = info.ver;
    self.details = @[self.device? self.device.name:@"", self.device?self.device.deviceID:@"", @"XXXX", self.device?self.device.mobile:@"", @"",@"",self.time,@"",self.deviceVer];

    [self.tableView reloadData];
}
- (void)updateDeviceVerno:(NSNotification *)notifi{
    MQTTInfo *info = notifi.object;
    NSLog(@"%@",info);
    self.deviceVer = info.ver;
    self.details = @[self.device? self.device.name:@"", self.device?self.device.deviceID:@"", @"XXXX", self.device?self.device.mobile:@"", @"",@"",self.time,@"",self.deviceVer];
    [self.tableView reloadData];
}
#pragma mark 调整图片分辨率/尺寸（等比例缩放）
- (UIImage *)newSizeImage:(CGSize)size image:(UIImage *)sourceImage {
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / size.height;
    CGFloat tempWidth = newSize.width / size.width;
    
    if (tempWidth > 1.0 && tempWidth >= tempHeight) {
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

