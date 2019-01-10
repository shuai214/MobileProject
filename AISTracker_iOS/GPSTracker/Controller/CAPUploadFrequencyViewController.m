//
//  CAPUploadFrequencyViewController.m
//  GPSTracker
//
//  Created by 曹帅 on 2019/1/9.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPUploadFrequencyViewController.h"
#import "CAPDeviceService.h"
#import "CAPDeviceCommand.h"
#import "MQTTInfo.h"
@interface CAPUploadFrequencyViewController ()
@property(nonatomic,strong)UIButton *sdButton;
@property(nonatomic,strong)UIButton *customButton;
@property(nonatomic,strong)UIImageView *sdImageView;
@property(nonatomic,strong)UIImageView *customImageView;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,strong)MQTTInfo *mqttInfo;

@end
#define  IMAGE_W_H 40
@implementation CAPUploadFrequencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"定位模式";
    self.view.backgroundColor = gCfg.appBackgroundColor;
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(10,10 + TopHeight,Main_Screen_Width - 20,120)];
    buttonView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, buttonView.height / 2 - 1, buttonView.width - 10, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [buttonView addSubview:lineView];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, buttonView.width / 2 - 15, buttonView.height / 2)];
    label.text = @"省电模式";
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    [buttonView addSubview:label];
    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, lineView.bottom, buttonView.width / 2 - 15, buttonView.height / 2)];
    label1.text = @"普通模式";
    label1.font = [UIFont systemFontOfSize:14];
    label1.textAlignment = NSTextAlignmentLeft;
    [buttonView addSubview:label1];
    
    
    self.sdButton = [[UIButton alloc] initWithFrame:CGRectMake(label.right, 0, buttonView.width / 2, buttonView.height / 2)];
    [self.sdButton addTarget:self action:@selector(electricityAction) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:self.sdButton];
    
    self.customButton = [[UIButton alloc] initWithFrame:CGRectMake(label.right, lineView.bottom, buttonView.width / 2, buttonView.height / 2)];
    [self.customButton addTarget:self action:@selector(chooseTimeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.customButton setTitleColor:[CAPColors green1] forState:UIControlStateNormal];
    [buttonView addSubview:self.customButton];
    
    
    self.sdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.sdButton.width - IMAGE_W_H - 10, (self.sdButton.height - IMAGE_W_H) / 2, IMAGE_W_H, IMAGE_W_H)];
    [self.sdButton addSubview:self.sdImageView];
    self.customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.customButton.width - IMAGE_W_H - 10, (self.customButton.height - IMAGE_W_H) / 2, IMAGE_W_H, IMAGE_W_H)];
    [self.customButton addSubview:self.customImageView];
    
    [self.sdImageView setImage:[CAPUserDefaults objectForKey:@"uploadTime"]? GetImage(@"check_off"):GetImage(@"check_on")];
    [self.customImageView setImage:[CAPUserDefaults objectForKey:@"uploadTime"]? GetImage(@"check_on"):GetImage(@"check_off")];
    [self.customButton setTitle:[CAPUserDefaults objectForKey:@"uploadTime"] forState:UIControlStateNormal];

    [self.view addSubview:buttonView];
    
    
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(15, Main_Screen_Height - TabBarHeight - IMAGE_W_H, Main_Screen_Width - 30, IMAGE_W_H)];
    okButton.backgroundColor = [CAPColors red];
    [okButton setTitle:@"完成" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okButton.layer.cornerRadius = 4.0;
    [okButton addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:okButton];
    
}

- (void)electricityAction{
    [self.sdImageView setImage:GetImage(@"check_on")];
    [self.customImageView setImage:GetImage(@"check_off")];
    self.time = @"-1";
    [CAPUserDefaults removeObjectForKey:@"uploadTime"];
}

- (void)chooseTimeAction{
    [self.sdImageView setImage:GetImage(@"check_off")];
    [self.customImageView setImage:GetImage(@"check_on")];
    NSArray *times = @[@"实时", @"1小时", @"4小时",@"8小时",@"12小时"];
    [BRStringPickerView showStringPickerWithTitle:@"更新频率" dataSource:times defaultSelValue:@"" resultBlock:^(id selectValue) {
        [self.customButton setTitle:[NSString stringWithFormat:@"%@",selectValue] forState:UIControlStateNormal];
        [CAPUserDefaults setObject:selectValue forKey:@"uploadTime"];
        NSInteger index = [times indexOfObject:selectValue];
        switch (index) {
            case 0:
                self.time = @"0";
                break;
            case 1:{
                NSInteger timeInterval = 60 * 60;
                self.time = [NSString stringWithFormat:@"%ld",timeInterval];
            }
                break;
            case 2:{
                NSInteger timeInterval = 60 * 60 * 4;
                self.time = [NSString stringWithFormat:@"%ld",timeInterval];
            }
                break;
            case 3:{
                NSInteger timeInterval = 60 * 60 *8;
                self.time = [NSString stringWithFormat:@"%ld",timeInterval];
            }
                break;
            case 4:{
                NSInteger timeInterval = 60 * 60 * 12;
                self.time = [NSString stringWithFormat:@"%ld",timeInterval];
            }
                break;
            default:
                break;
        }
    }];
}
- (void)okAction{
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    [deviceService deviceSendCommand:self.device.deviceID cmd:@"UPLOAD" param:self.time reply:^(CAPHttpResponse *response) {
        NSLog(@"%@",response.data);
        CAPDeviceCommand *command = [CAPDeviceCommand mj_objectWithKeyValues:response.data];
        if (command.code == 200) {
            [gApp showHUD:command.message];
            [CAPNotifications addObserver:self selector:@selector(getNotification:) name:kNotificationUPLOADCountChange object:nil];
            //GCD延迟
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (!self.mqttInfo) {
                    [gApp hideHUD];
                    [gApp showNotifyInfo:@"请求错误❌" backGroundColor:[UIColor grayColor]];
                }
            });
           
        }
    }];
}
- (void)getNotification:(NSNotification *)notifi{
    self.mqttInfo = notifi.object;
    NSLog(@"%@",self.mqttInfo);
    [gApp hideHUD];
   
}
@end
