//
//  CAPTrackerView.m
//  GPSTracker
//
//  Created by WeifengYao on 6/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPTrackerView.h"
#import "MQTTInfo.h"
@interface CAPTrackerView ()
@property (weak, nonatomic) IBOutlet UIButton *fenceButton;
@property (weak, nonatomic) IBOutlet UIButton *footprintButton;
@property (weak, nonatomic) IBOutlet UIButton *photographButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UILabel *DeviceName;
@property (weak, nonatomic) IBOutlet UILabel *DeviceLocation;
@property (weak, nonatomic) IBOutlet UIStackView *ownerStackView;
@property (weak, nonatomic) IBOutlet UIStackView *userStackView;
@property (weak, nonatomic) IBOutlet UIButton *userCall;
@property (weak, nonatomic) IBOutlet UIButton *userFootprint;
@property (weak, nonatomic) IBOutlet UIButton *userSetting;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;
@property (weak, nonatomic) IBOutlet UIButton *unbindung;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;

@end

@implementation CAPTrackerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"CAPTrackerView" owner:self options:nil];
        [self addSubview:self.contentView];
        self.userInteractionEnabled = YES;
        [self initButton:self.fenceButton];
        [self initButton:self.footprintButton];
        [self initButton:self.photographButton];
        [self initButton:self.callButton];
        [self initButton:self.settingButton];
        [self initButton:self.userCall];
        [self initButton:self.userFootprint];
        [self initButton:self.userSetting];
        [self initButton:self.unbindung];
        [self.fenceButton addTarget:self action:@selector(did) forControlEvents:UIControlEventTouchUpInside];
        [CAPNotifications addObserver:self selector:@selector(deviceOnline:) name:kNotificationDeviceOnlineChange object:nil];
    }
//    https://www.googleapis.com/geolocation/v1/geolocate?key=
    return self;
}
- (void)deviceOnline:(NSNotification *)notifi{
    MQTTInfo *info = (MQTTInfo *)notifi.object;
    if (info.online ? 0 : 1) {
        self.onlineLabel.text = @"offline";
//        self.onlineLabel.textColor = [UIColor lightGrayColor];
    }else{
        self.onlineLabel.text = @"online";
//        self.onlineLabel.textColor = [CAPColors green1];
    }
}
- (void)isLine:(BOOL)isLine{
    if (isLine) {
        self.onlineLabel.text = @"online";
    }else{
        self.onlineLabel.text = @"offline";
        [self.batteryView reloadBattery:0];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"CAPTrackerView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.userInteractionEnabled = YES;
    [self initButton:self.fenceButton];
    [self initButton:self.footprintButton];
    [self initButton:self.photographButton];
    [self initButton:self.callButton];
    [self initButton:self.settingButton];
    [self initButton:self.userCall];
    [self initButton:self.userFootprint];
    [self initButton:self.userSetting];
    [self initButton:self.unbindung];
    [self.fenceButton addTarget:self action:@selector(did) forControlEvents:UIControlEventTouchUpInside];
}

- (void)userOrowner:(BOOL)is{
    if (is) {
        self.ownerStackView.hidden = YES;
        self.userStackView.hidden = NO;
    }else{
        self.ownerStackView.hidden = NO;
        self.userStackView.hidden = YES;
    }
}

- (void)did{
    NSLog(@"11");
}
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.contentView.frame = self.bounds;
}
- (void)refreshDeviceLocation:(CAPDevice *)device location:(NSString *)location time:(NSString *)time{
    self.DeviceName.text = device.name;
    self.DeviceLocation.text = location;
    if (time.length != 0) {
        time = [time substringWithRange:NSMakeRange(0,time.length - 3)];
    }
    time ? self.updateTimeLabel.text = [NSString stringWithFormat:@"%@%@",CAPLocalizedString(@"last_updated"),time] : @"";
}
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [self.contentView layoutSubviews];
//}

//- (instancetype)init:(NSCoder *)aDecoder {
//    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"CAPTrackerView" owner:self options:nil] lastObject];
//    if (view) {
//        self.frame = self.bounds;
//        [self addSubview:view];
//    }
//    return self;
//}

//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    self = [[[NSBundle mainBundle] loadNibNamed:@"CAPTrackerView" owner:self options:nil] lastObject];
//    if (self) {
//        self.frame = frame;
//    }
//    return self;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)onFenceButtonClicked:(id)sender {
    NSLog(@"onFenceButtonClicked");
    [self performAction:CAPTrackerViewActionFence];
}

- (IBAction)onFootprintButtonClicked:(id)sender {
    [self performAction:CCAPTrackerViewActionFootprint];
}

- (IBAction)onPhotographButtonClicked:(id)sender {
    [self performAction:CAPTrackerViewActionPhotograph];
}

- (IBAction)onCallButtonClicked:(id)sender {
    [self performAction:CAPTrackerViewActionCall];
}

- (IBAction)onSettingButtonClicked:(id)sender {
    [self performAction:CAPTrackerViewActionSetting];
}
- (IBAction)unbindingAction:(id)sender {
    [self performAction:CAPTrackerViewActionUnbinding];
}

-(void)initButton:(UIButton*)button {
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [button setTitleEdgeInsets:UIEdgeInsetsMake(button.imageView.frame.size.height+12 ,-button.imageView.frame.size.width, 0.0, 0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -button.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}

- (void)performAction:(CAPTrackerViewAction)action {
    if(self.delegate) {
        [self.delegate onTrackerViewActionPerformed:action];
    }
}
@end
