//
//  CAPSOSMobileViewController.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/9.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPSOSMobileViewController.h"
#import "CAPDeviceNumber.h"
#import "CAPMMCountry.h"
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
    label.text = [NSString stringWithFormat:@"%ld",(long)index];
    [imgView addSubview:label];
    [bgView addSubview:imgView];
    
    CAPDeviceNumber *deviceNumberView = [[CAPDeviceNumber alloc] initWithFrame:CGRectMake(imgView.right + 10, 0, width - imgView.right - 30, height) isEdit:is];
    deviceNumberView.countryNameLabel.tag = index + 99;
    deviceNumberView.countryNameLabel.userInteractionEnabled = is;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [deviceNumberView.countryNameLabel addGestureRecognizer:labelTapGestureRecognizer];
    [bgView addSubview:deviceNumberView];
    return bgView;
}
-(void)labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    UILabel *label= (UILabel *)recognizer.view;
    CAPDeviceNumber *deviceNumber = (CAPDeviceNumber *)label.superview;
    [self get:deviceNumber];
}

-(void)get:(CAPDeviceNumber *)deviceNumber{
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"diallingcode" ofType:@"json"]];
    NSError *error = nil;
    NSArray *arrayCode = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if ( error ) {
        return;
    }
    NSLog(@"%@", arrayCode);
    //读取文件
    NSMutableDictionary *dicCode = [@{} mutableCopy];
    for ( NSDictionary *item in arrayCode ){
        CAPMMCountry *c = [CAPMMCountry new];
        c.code      = item[@"code"];
        c.dial_code = item[@"dial_code"];
        [dicCode setObject:c forKey:c.code];
    }
    //获取国家名
    NSLocale *locale = [NSLocale currentLocale];
    NSArray *countryArray = [NSLocale ISOCountryCodes];
    NSMutableArray*countriesArray = [[NSMutableArray alloc] init];
    NSMutableArray*countryCodeArray = [[NSMutableArray alloc] init];
    
    for (NSString *countryCode in countryArray) {
        if (dicCode[countryCode] ){
            CAPMMCountry *c = dicCode[countryCode];
            if ([c.code isEqualToString:@"CN"]) {
                c.name = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
                [countriesArray insertObject:c.name atIndex:0];
                [countryCodeArray insertObject:c.dial_code atIndex:0];
            }
            c.name = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
            if ( [c.name isEqualToString:@"台湾"] ){
                c.name = @"中国台湾";
            }
            [countriesArray addObject:c.name];
            [countryCodeArray addObject:c.dial_code];
        }
    }
    NSArray *array = countriesArray;
    [BRStringPickerView showStringPickerWithTitle:@"选择国家" dataSource:array defaultSelValue:@"" resultBlock:^(id selectValue) {
        NSUInteger index = [array indexOfObject:selectValue];
        NSString *telCode = [countryCodeArray objectAtIndex:(NSInteger)index];
        deviceNumber.telAreaCodeLabel.text = [NSString stringWithFormat:@"%@",telCode];
        deviceNumber.countryNameLabel.text = selectValue;
    }];
}
@end
