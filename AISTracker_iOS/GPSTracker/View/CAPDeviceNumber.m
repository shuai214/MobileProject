//
//  CAPDeviceNumber.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/8.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPDeviceNumber.h"

@interface CAPDeviceNumber()<UITextFieldDelegate>
@property(nonatomic,strong)UILabel *countryLabel;
@end

@implementation CAPDeviceNumber

- (instancetype)initWithFrame:(CGRect)frame isEdit:(BOOL)isEdit{
    self = [super initWithFrame:frame];
    if (self) {
        self.isEdit = isEdit;
        [self layoutSubview];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.isEdit = YES;
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
    if (!self.isEdit) {
        self.countryNameLabel.textColor = [UIColor lightGrayColor];
    }else{
        self.countryNameLabel.textColor = [UIColor blackColor];
    }
    self.countryNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.countryNameLabel];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 4 * 3, 0, self.frame.size.width / 4, self.frame.size.height / 2)];
    [button setImage:GetImage(@"downCountry") forState:UIControlStateNormal];
    [self addSubview:button];
    
    self.telField = [[UITextField alloc] initWithFrame:CGRectMake(self.frame.size.width / 4 , self.frame.size.height / 2, self.frame.size.width / 4 * 3, self.frame.size.height / 2 - 1)];
    self.telField.placeholder = @"Please input number";
    self.telField.textAlignment = NSTextAlignmentCenter;
    self.telField.delegate = self;
    [self addSubview:self.telField];
    
    UIView *crossLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height / 2 - 0.5, self.frame.size.width, 1)];
    crossLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:crossLine];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"这里返回为NO。则为禁止编辑");
    return self.isEdit;
}

@end
