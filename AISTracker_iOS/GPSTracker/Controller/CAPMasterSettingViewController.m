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
@interface CAPMasterSettingViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet CAPBatteryView *batteryView;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<NSString *> *titles;
@property (strong, nonatomic) NSArray<NSString *> *details;
@end

@implementation CAPMasterSettingViewController
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备详情";
    self.titles = @[@"Name", @"Guardian", @"Update Frequency",
                    @"Untether", @"Firmware version"];
    self.details = @[self.device.name, @"", [NSString dateFormateWithTimeInterval:self.device.createdDate], @"", @"V1.7.05"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIImage *avatar =GetImage(@"ic_default_avatar");
    
    [self.avatarImageView setImage:[self OriginImage:avatar scaleToSize:CGSizeMake(self.avatarImageView.frame.size.width, self.avatarImageView.frame.size.width)]];
    self.deviceLabel.text = [@"Device ID: " stringByAppendingString:self.device.deviceID];
}
- (void)loadDeviceInfo{
    
}

- (void)refreshLocalizedString {
//    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
//    [deviceService fetchDevice:self.device.deviceID reply:^(CAPHttpResponse *response) {
//         CAPDevice *getDevice = [CAPDevice mj_objectWithKeyValues:[response.data objectForKey:@"result"]];
//    }];
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
    cell.detailTextLabel.text = self.details[indexPath.row];
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
        [self.navigationController pushViewController:EditNameVC animated:YES];
        }
            break;
        case 1:
//            [self performSegueWithIdentifier:@"guardian.list.segue" sender:nil];GuardianListViewController
        {UIStoryboard *story = [UIStoryboard storyboardWithName:@"MasterSetting" bundle:nil];
            CAPGuardianListViewController *GuardianVC = [story instantiateViewControllerWithIdentifier:@"GuardianListViewController"];
            [self.navigationController pushViewController:GuardianVC animated:YES];
        }
            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            break;
        default:
            break;
    }
}

@end

