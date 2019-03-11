//
//  CAPPhotographViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 4/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPPhotographViewController.h"
#import "CAPPhotoService.h"
#import "CAPDeviceService.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "MQTTCenter.h"
#import "CAPDeviceCommand.h"
#import "CAPCollectionCell.h"
#import "CAPPhotoListViewController.h"
@interface CAPPhotographViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIImageView *showPhotoImage;
@property (strong, nonatomic) NSMutableArray *showPhotos;
@property (strong, nonatomic) MQTTInfo *mqttInfo;
@property (strong, nonatomic) UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation CAPPhotographViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = CAPLocalizedString(@"take_photo");
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [CAPNotifications addObserver:self selector:@selector(getNotification:) name:kNotificationPhotoCountChange object:nil];
    self.nameLabel.text = CAPLocalizedString(@"records");
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.imgView removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.showPhotos = [NSMutableArray array];
    [self loadPhotoList];
    self.imgView = [[UIImageView alloc] initWithImage:GetImage(@"ic_default_avatar_new")];
    self.imgView.frame = CGRectMake(Main_Screen_Width - 70, TabBarHeight - 35, 40, 40);
    [self.navigationController.navigationBar addSubview:self.imgView];
}
- (void)loadPhotoList{
    NSArray *array = [CAPUserDefaults objectForKey:kNotificationPhotoCountChange];
    [self.showPhotos addObjectsFromArray:array];
    [self.collectionView reloadData];
}

- (void)refreshLocalizedString {
    
}
#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.showPhotos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"CollectionCell";
    CAPCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (self.showPhotos) {
        NSDictionary *dataDic = self.showPhotos[indexPath.row];
        NSData *imgData = dataDic[@"image"];
        [cell.currentImageView setImage:[UIImage imageWithData:imgData]];
        [cell.timeLabel setText:dataDic[@"time"]];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = self.showPhotos[indexPath.row];
    NSData *imgData = dataDic[@"image"];
    [self.showPhotoImage setImage:[UIImage imageWithData:imgData]];
}
- (void)setDevice:(CAPDevice *)device{
    if (_device != device) {
        _device = device;
    }
}

- (IBAction)onCameraButtonClicked:(id)sender {
    CAPDeviceService *photoService = [[CAPDeviceService alloc] init];
    [photoService deviceSendCommand:self.device.deviceID cmd:@"PHOTO" param:@"1" reply:^(CAPHttpResponse *response) {
        NSLog(@"%@",response);
        CAPDeviceCommand *command = [CAPDeviceCommand mj_objectWithKeyValues:response.data];
        if (command) {
            [gApp showHUD:command.message];
            //GCD延迟
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (!self.mqttInfo) {
                    [gApp hideHUD];
                    [gApp showNotifyInfo:CAPLocalizedString(@"take_photo_error") backGroundColor:[CAPColors gray1]];
                }
            });
        }
        
    }];
}

- (void)getNotification:(NSNotification *)notifi{
    self.mqttInfo = notifi.object;
    NSLog(@"%@",self.mqttInfo);
    [gApp hideHUD];
    // 将base64字符串转为NSData
    NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:self.mqttInfo.data options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    // 将NSData转为UIImage
    UIImage *decodedImage = [UIImage imageWithData:decodeData];
    [self.showPhotoImage setImage:decodedImage];
    NSDictionary *dic = @{
                          @"time":[NSString dateFormateWithTimeInterval:(self.mqttInfo.time / 1000)],
                          @"image":decodeData
                          };
    [self.showPhotos addObject:dic];
    [CAPUserDefaults setObject:self.showPhotos forKey:kNotificationPhotoCountChange];
    [self.collectionView reloadData];
}
- (IBAction)pushPhotoListVC:(id)sender {
    CAPPhotoListViewController *photoList = [[UIStoryboard storyboardWithName:@"Tracker" bundle:nil] instantiateViewControllerWithIdentifier:@"PhotoListViewController"];
    [self.navigationController pushViewController:photoList animated:YES];
}

@end
