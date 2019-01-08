//
//  CAPDeviceNumber.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/8.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPDeviceNumber.h"

@interface CAPDeviceNumber()
@property(nonatomic,strong)UILabel *countryLabel;

@end

@implementation CAPDeviceNumber

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutSubview];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self layoutSubview];
}

- (void)layoutSubview{
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.countryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 4, self.frame.size.height / 2 - 1)];
    self.countryLabel.text = @"Country";
    self.countryLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.countryLabel];
    
    UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width / 4 + 1, 0, 1, self.frame.size.height)];
    verticalLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:verticalLine];
    
    self.telAreaCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height / 2, self.frame.size.width / 4, self.frame.size.height / 2)];
    self.telAreaCodeLabel.text = @"+66";
    self.telAreaCodeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.telAreaCodeLabel];
    
    self.countryNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(verticalLine.frame.origin.x + 1, 0, self.frame.size.width / 4 * 2, self.frame.size.height / 2)];
    self.countryNameLabel.text = @"泰国";
    self.countryNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.countryNameLabel];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 4 * 3, 0, self.frame.size.width / 4, self.frame.size.height / 2)];
    [button setImage:GetImage(@"next_gray") forState:UIControlStateNormal];
    [self addSubview:button];
    
    self.telField = [[UITextField alloc] initWithFrame:CGRectMake(self.frame.size.width / 4 , self.frame.size.height / 2, self.frame.size.width / 4 * 3, self.frame.size.height / 2 - 1)];
    self.telField.placeholder = @"Please input number";
    self.telField.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.telField];
    
    UIView *crossLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height / 2 - 0.5, self.frame.size.width, 1)];
    crossLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:crossLine];
    
    
}










@end
