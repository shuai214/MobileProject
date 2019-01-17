//
//  CAPDeviceNumber.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/8.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAPDeviceNumber : UIView
- (instancetype)initWithFrame:(CGRect)frame isEdit:(BOOL)isEdit;
@property(nonatomic,strong)UILabel *telAreaCodeLabel;
@property(nonatomic,strong)UILabel *countryNameLabel;
@property(nonatomic,strong)UITextField *telField;
@property(nonatomic,strong)UIButton *buttonSend;

@property(nonatomic,assign)BOOL isEdit;
@end

NS_ASSUME_NONNULL_END
