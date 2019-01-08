//
//  CAPBatteryView.m
//  GPSTracker
//
//  Created by WeifengYao on 6/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPBatteryView.h"

@interface CAPBatteryView ()
{
    NSString *imageName;
    UIColor *textColor;
}
@property (nonatomic, weak) UIButton *button;
@property (nonatomic, strong) UILabel *batteryLabel;
@property (nonatomic, strong) UIImageView *batteryImageView;

@end

@implementation CAPBatteryView
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setup {
    if (!self.batteryLabel) {
        self.batteryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
        self.batteryLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.height + 5,0, self.frame.size.width - self.frame.size.height, self.frame.size.height)];
        self.batteryLabel.font = [UIFont systemFontOfSize:10];
       
        if(self.battery <= 0.0) {
            imageName = @"battery_gray";
            textColor = [UIColor grayColor];
        } else if (self.battery > 20) {
            imageName = @"battery_green";
            textColor = [UIColor greenColor];
        } else {
            imageName = @"battery_red";
            textColor = [UIColor redColor];
        }
        [self.batteryImageView setImage:[UIImage imageNamed:imageName]];
        self.batteryLabel.textColor = textColor;
        self.batteryLabel.text = [NSString stringWithFormat:@"%.1f%%", self.battery];
        [self addSubview:self.batteryImageView];
        [self addSubview:self.batteryLabel];
        
    }
}
- (void)reloadBattery:(CGFloat)battery{
    if(battery <= 0.0) {
        imageName = @"battery_gray";
        textColor = [UIColor grayColor];
    } else if (battery > 20) {
        imageName = @"battery_green";
        textColor = [UIColor greenColor];
    } else {
        imageName = @"battery_red";
        textColor = [UIColor redColor];
    }
    [self.batteryImageView setImage:[UIImage imageNamed:imageName]];
    self.batteryLabel.textColor = textColor;
    self.batteryLabel.text = [NSString stringWithFormat:@"%.1f%%", battery];
}
- (void)setBattery:(CGFloat)battery{
    
}
@end
