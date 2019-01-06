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
@interface CAPPhotographViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIImageView *showPhotoImage;
@property (strong, nonatomic) NSMutableArray *showPhotos;
@end

@implementation CAPPhotographViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"拍照";
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.showPhotos = [NSMutableArray array];
    [self loadPhotoList];
}

- (void)loadPhotoList{
    NSArray *array = [CAPUserDefaults objectForKey:@"takePhoto"];
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
    return self.showPhotos.count * 5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"CollectionCell";
    CAPCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (self.showPhotos) {
        NSData *imgData = self.showPhotos[1];
        [cell.currentImageView setImage:[UIImage imageWithData:imgData]];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSData *imgData = self.showPhotos[indexPath.row];
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
        }
        [CAPNotifications addObserver:self selector:@selector(getNotification:) name:kNotificationPhotoCountChange object:nil];
    }];
}

- (void)getNotification:(NSNotification *)notifi{
    MQTTInfo *info = notifi.object;
    NSLog(@"%@",info);
    [gApp hideHUD];
    // 将base64字符串转为NSData
    NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:info.data options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    // 将NSData转为UIImage
    UIImage *decodedImage = [UIImage imageWithData:decodeData];
    [self.showPhotoImage setImage:decodedImage];
    NSArray *images = @[decodeData];
    [self.showPhotos addObjectsFromArray:images];
    [CAPUserDefaults setObject:self.showPhotos forKey:@"takePhoto"];
    [self.collectionView reloadData];
}

@end
