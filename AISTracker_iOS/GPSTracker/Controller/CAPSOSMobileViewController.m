//
//  CAPSOSMobileViewController.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/9.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPSOSMobileViewController.h"
#import "CAPDeviceNumber.h"
@interface CAPSOSMobileViewController ()
@property(nonatomic,strong)UIScrollView *bgscrollView;
@end

@implementation CAPSOSMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SOS Number";
    // Do any additional setup after loading the view.
    self.bgscrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.bgscrollView.backgroundColor = gCfg.appBackgroundColor;
    [self.view addSubview:self.bgscrollView];
    
    UILabel *mustBeThreeNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, TopHeight / 2, Main_Screen_Width, 20)];
    mustBeThreeNumber.text = @"There three numbers are from APP";
    mustBeThreeNumber.textAlignment = NSTextAlignmentCenter;
    [self.bgscrollView addSubview:mustBeThreeNumber];
    NSMutableArray <UIView *>*mustViews = [NSMutableArray array];
    CGFloat numViewHeight = 80;
    NSInteger j = 1;
    for (NSInteger i = 0; i<3; i++) {
        CGRect frame = CGRectMake(0, mustBeThreeNumber.bottom + (numViewHeight + 10 )* i + 10, Main_Screen_Width, numViewHeight);
        UIView *view = [self setNumberView:frame isEdit:NO index:j];
        [self.bgscrollView addSubview:view];
        [mustViews addObject:view];
        j++;
    }
    
    UILabel *mayBeTwoNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, mustViews.lastObject.bottom + 20, Main_Screen_Width, 20)];
    mayBeTwoNumber.text = @"You can set these two numbers freely";
    mayBeTwoNumber.textAlignment = NSTextAlignmentCenter;
    [self.bgscrollView addSubview:mayBeTwoNumber];
    
    NSMutableArray <UIView *>*mayViews = [NSMutableArray array];

    for (NSInteger i = 0; i< 2; i++) {
        j++;
        CGRect frame = CGRectMake(0, mayBeTwoNumber.bottom + (numViewHeight + 10 ) * i + 10, Main_Screen_Width, numViewHeight);
        UIView *view = [self setNumberView:frame isEdit:YES index:j];
        [self.bgscrollView addSubview:view];
        [mayViews addObject:view];
    }
    self.bgscrollView.contentSize = CGSizeMake(Main_Screen_Width, mayViews.lastObject.bottom + 40);
}




- (UIView *)setNumberView:(CGRect)frame isEdit:(BOOL)is index:(NSInteger)index{
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
   
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, height / 4, height / 2, height / 2)];
    [imgView setImage:GetImage(@"sos_phone")];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imgView.width / 2, 0, imgView.width / 2, imgView.height / 2)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:10];
    label.text = [NSString stringWithFormat:@"%d",index];
    [imgView addSubview:label];
    [bgView addSubview:imgView];
    
    CAPDeviceNumber *deviceNumberView = [[CAPDeviceNumber alloc] initWithFrame:CGRectMake(imgView.right + 10, 0, width - imgView.right - 30, height) isEdit:is];
    [bgView addSubview:deviceNumberView];
    return bgView;
    
}

@end
