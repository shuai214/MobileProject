//
//  CAPMeViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPMeViewController.h"
#import "CAPLanguageViewController.h"
#import "CAPViews.h"
#import "MQTTCenter.h"
#import "CAPUserService.h"
#import "CAPFetchUserProfileResponse.h"
#import "CAPUser.h"
#import <AFNetworking/AFNetworking.h>
#import "CAPEditNameViewController.h"
#import "CAPFileUpload.h"
@interface CAPMeViewController ()<UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) NSArray<NSString *> *titles;
@property (strong, nonatomic) NSArray<NSString *> *details;
@property (strong, nonatomic) CAPUser *capUser;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@end

@implementation CAPMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = CAPLocalizedString(@"me");
    self.titles = @[CAPLocalizedString(@"name"), CAPLocalizedString(@"language"), CAPLocalizedString(@"version")];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.userImageView.layer.cornerRadius =  self.userImageView.width/2.0;
    self.userImageView.layer.masksToBounds = YES;
    [self getDeviceUser];
    [CAPNotifications addObserver:self selector:@selector(getDeviceUser) name:kNotificationChangeNickName object:nil];
}

- (void)getDeviceUser{
    [gApp showHUD:@"正在加载，请稍后..."];
    CAPUserService *userServer = [[CAPUserService alloc] init];
    [userServer fetchProfile:^(CAPFetchUserProfileResponse *response) {
        NSLog(@"%@",response.result);
        [gApp hideHUD];
        self.capUser = response.result;
        [self.tableView reloadData];
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",self.capUser.profile.avatarBaseUrl,self.capUser.profile.avatarPath]] placeholderImage:GetImage(@"user_default_avatar")];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const cellIdentifier = @"detail_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.titles[indexPath.row];
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = self.capUser.info.name;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CAPEditNameViewController *editName = [[UIStoryboard storyboardWithName:@"EditName" bundle:nil] instantiateViewControllerWithIdentifier:@"EditNameViewController"];
        editName.capUser = self.capUser;
        editName.isUser = YES;
        CAPWeakSelf(self);
        [editName setUpdateSuccessBlock:^(id cap) {
            [weakself getDeviceUser];
        }];
        [self.navigationController pushViewController:editName animated:YES];
    }
    if (indexPath.row == 1) {
        
        [self performSegueWithIdentifier:@"language.segue" sender:nil];
    }
}

- (IBAction)onFeedbackButtonClicked:(id)sender {
//    [CAPViews pushFromViewController:self storyboarName:@"Me" withIdentifier:@"FeedbackViewController"];
//    [self.navigationController performSegueWithIdentifier:@"feedback.segue" sender:nil];
    [self performSegueWithIdentifier:@"feedback.segue" sender:nil];
}
- (IBAction)takingPhoto:(id)sender {
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

- (IBAction)onLogoutButtonClicked:(id)sender {
//    [self performSegueWithIdentifier:@"language.segue" sender:nil];
//     [self performSegueWithIdentifier:@"feedback.segue" sender:nil];
    MQTTConfig *config = [[MQTTConfig alloc] init];
    config.host = @"www.capelabs.net";
    config.port = 1883;
    config.username = @"demo_app";
    config.password = @"demo_890_123_654";
    config.clientID = @"X3211fd93441ed535NVWR4E00120000000052";
    config.userID = @"130";
    config.deviceType = MQTTDeviceTypeApp;
    config.platformID = @"TRUEIOT";
    config.keepAliveInterval = 20;
    [[MQTTCenter center] open:config];
}


//选择图片后,更换头像,并保存到沙盒,上传到服务器
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *iconImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *newIconImage = [self newSizeImage:CGSizeMake(self.userImageView.width, self.userImageView.height) image:iconImage];
    [self.userImageView setImage:newIconImage];
    
    CAPFileUpload *fileUpload = [[CAPFileUpload alloc] init];
    [fileUpload uploadRecording:newIconImage withImageIndex:arc4random() % 100];
    [fileUpload setSuccessBlockObject:^(id  _Nonnull object) {
        NSLog(@"%@",object);
        NSDictionary *dic = (NSDictionary *)object;
        if ([[dic objectForKey:@"code"] integerValue] == 200) {
            NSDictionary *resultDic = [dic objectForKey:@"result"];
            self.capUser.profile.avatarBaseUrl = resultDic[@"base_url"];
            self.capUser.profile.avatarPath = resultDic[@"path"];
            CAPUserService *userService = [[CAPUserService alloc] init];
            [userService putProfile:self.capUser reply:^(CAPFetchUserProfileResponse *response) {
                NSLog(@"%@",response);
                [gApp hideHUD];
            }];
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
