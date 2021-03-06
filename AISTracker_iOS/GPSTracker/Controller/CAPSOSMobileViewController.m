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
#import "CAPDeviceService.h"
#import "CAPDevice.h"
#import "CAPDeviceLists.h"
#import "CAPValidators.h"
#import "CAPDeviceBindList.h"
#import "CAPFileUpload.h"

@interface CAPSOSMobileViewController ()
@property(nonatomic,strong)UIScrollView *bgscrollView;
@property(nonatomic,strong)CAPDeviceLists *deviceLists;
@property(nonatomic,strong)NSMutableArray *countryArray;
@property(nonatomic,strong)NSMutableArray *telCodeArray;
@property(nonatomic,strong)NSMutableArray *inputTelArray;
@property (strong , nonatomic)NSMutableArray<USERS *> *dataArray;
@property (strong , nonatomic)NSMutableArray<NSString *> *sosArray;
@property (strong , nonatomic)NSMutableArray <UIView *>*firstViewArray;
@property (strong , nonatomic)NSMutableArray <UIView *>*twoViewArray;
@end

@implementation CAPSOSMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = CAPLocalizedString(@"sos_number");
    // Do any additional setup after loading the view.
    [self setRightBarImageButton:@"save_sos" action:@selector(saveButtonClicked)];

   
    self.view.backgroundColor = gCfg.appBackgroundColor;
    [self get:nil];
    self.dataArray = [NSMutableArray array];
    self.sosArray = [NSMutableArray array];
    [self configSubView];
    [self fetchDevice];
}

- (void)fetchDevice{
    [capgApp showHUD:CAPLocalizedString(@"loading")];
    CAPDeviceService *deviceServer = [[CAPDeviceService alloc] init];
    [deviceServer getDeviceBindList:self.device reply:^(CAPHttpResponse *response) {
        NSLog(@"%@",response.data);
        NSDictionary *dic =(NSDictionary *)response.data;
        if ([[dic objectForKey:@"code"] integerValue] == 200) {
            CAPDeviceBindList *bindList = [CAPDeviceBindList mj_objectWithKeyValues:[dic objectForKey:@"result"]];
            NSLog(@"%lu",(unsigned long)bindList.users.count);
            for (USERS *user in bindList.users) {
                [self.dataArray addObject:user];
            }
        }
        [self initFirstView];
        [capgApp hideHUD];
    }];
    [deviceServer getSOSMobile:self.device reply:^(CAPHttpResponse *response) {
        NSLog(@"%@",response.data);
        NSDictionary *dic =(NSDictionary *)response.data;
        if ([[dic objectForKey:@"code"] integerValue] == 200) {
            NSArray *result = dic[@"result"];
            NSDictionary *dicSos = result.firstObject;
            id sos = dicSos[@"sos"];
            if ([sos isKindOfClass:[NSDictionary class]]) {
                NSDictionary *sosDic= (NSDictionary *)sos;
                NSArray *sosArr = sosDic[@"sos"];
                [self.sosArray addObjectsFromArray:sosArr];
            }else if ([sos isKindOfClass:[NSArray class]]){
                NSArray *sosArr = dicSos[@"sos"];
                [self.sosArray addObjectsFromArray:sosArr];
            }
        }
        [self initTwoView];
        [capgApp hideHUD];
    }];
}
- (void)configSubView{
    if (!self.bgscrollView) {
        self.bgscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TopHeight, Main_Screen_Width, Main_Screen_Height - TopHeight)];
        self.bgscrollView.backgroundColor = gCfg.appBackgroundColor;
        if (@available(iOS 11.0, *)) {
            self.bgscrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            NSLog(@"11.0f");
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
            NSLog(@"10f");
        }
        [self.view addSubview:self.bgscrollView];
    }
}
- (void)initFirstView{
    self.firstViewArray = [NSMutableArray array];
    UILabel *mustBeThreeNumber = [[UILabel alloc] init];
    mustBeThreeNumber.text = CAPLocalizedString(@"sos_numbers_from_app");
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
    CGSize labelSize = [mustBeThreeNumber.text boundingRectWithSize:CGSizeMake(200, 5000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    //200为UILabel的宽度，5000是预设的一个高度，表示在这个范围内
    //注意：之前使用了NSString类的sizeWithFont: constrainedToSize: lineBreakMode:方法，但是该方法已经被iOS7 Deprecated了，而iOS7新出了一个boudingRectWithSize: options: attributes: context:方法来代替。
    mustBeThreeNumber.frame = CGRectMake(10, TopHeight / 2, Main_Screen_Width - 20, labelSize.height);
    //保持原来Label的位置和宽度，只是改变高度。
    mustBeThreeNumber.numberOfLines = 0;//表示label可以多行显示
    mustBeThreeNumber.font = [UIFont systemFontOfSize:16];
    [self.bgscrollView addSubview:mustBeThreeNumber];

    CGFloat numViewHeight = 80;
    NSInteger j = 0;
    NSInteger count = 3;
    
    for (NSInteger i = 0; i< count; i++) {
        CGRect frame = CGRectMake(0, mustBeThreeNumber.bottom + (numViewHeight + 10 )* i + 10, Main_Screen_Width, numViewHeight);
        UIView *view = [self setNumberView:frame isEdit:NO index:j];
        [self.bgscrollView addSubview:view];
        [self.firstViewArray addObject:view];
        j++;
    }
}
- (void)initTwoView{
    CGFloat numViewHeight = 80;
    NSInteger j = 3;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
    CGSize labelSize = [CAPLocalizedString(@"sos_numbers_from_app") boundingRectWithSize:CGSizeMake(200, 5000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    CGRect frame = CGRectMake(0, TopHeight / 2 + labelSize.height + (numViewHeight + 10 )* (j - 1) + 10, Main_Screen_Width, numViewHeight);
    
    
    UILabel *mayBeTwoNumber = [[UILabel alloc] init];
    mayBeTwoNumber.text = CAPLocalizedString(@"sos_numbers_input_manual");
    CGSize label2Size = [mayBeTwoNumber.text boundingRectWithSize:CGSizeMake(200, 5000) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    //200为UILabel的宽度，5000是预设的一个高度，表示在这个范围内
    //注意：之前使用了NSString类的sizeWithFont: constrainedToSize: lineBreakMode:方法，但是该方法已经被iOS7 Deprecated了，而iOS7新出了一个boudingRectWithSize: options: attributes: context:方法来代替。
    mayBeTwoNumber.frame = CGRectMake(10, frame.size.height + frame.origin.y + 20, Main_Screen_Width - 20, label2Size.height);
    //保持原来Label的位置和宽度，只是改变高度。
    mayBeTwoNumber.numberOfLines = 0;//表示label可以多行显示
    mayBeTwoNumber.font = [UIFont systemFontOfSize:16];
    [self.bgscrollView addSubview:mayBeTwoNumber];

    
    NSMutableArray <UIView *>*mayViews = [NSMutableArray array];
    
    for (NSInteger i = 0; i< 2; i++) {
        CGRect frame = CGRectMake(0, mayBeTwoNumber.bottom + (numViewHeight + 10 ) * i + 10, Main_Screen_Width, numViewHeight);
        UIView *view = [self setNumberView:frame isEdit:YES index:j];
        [self.bgscrollView addSubview:view];
        [mayViews addObject:view];
        j++;
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
    label.text = [NSString stringWithFormat:@"%ld",((long)index + 1)];
    [imgView addSubview:label];
    [bgView addSubview:imgView];
    
    CAPDeviceNumber *deviceNumberView = [[CAPDeviceNumber alloc] initWithFrame:CGRectMake(imgView.right + 10, 0, width - imgView.right - 30, height) isEdit:is];
    deviceNumberView.tag = index + 999;
    deviceNumberView.countryNameLabel.tag = index + 99;
    deviceNumberView.countryNameLabel.userInteractionEnabled = is;
    if (index < 3) {
        if (self.dataArray.count != 0) {
            if (index < self.dataArray.count) {
                USERS *user = self.dataArray[index];
                NSArray *array = [user.device.sos componentsSeparatedByString:@" "];
                deviceNumberView.telAreaCodeLabel.text = array.firstObject;
                deviceNumberView.telField.text = array.lastObject;
                NSArray *telCode = self.telCodeArray;
                NSUInteger index = [telCode indexOfObject:deviceNumberView.telAreaCodeLabel.text];
                if (!(index > telCode.count)) {
                    NSString *countryName = [self.countryArray objectAtIndex:(NSInteger)index];
                    deviceNumberView.countryNameLabel.text = countryName;
                }
            }
        }
    }else{
        if (self.sosArray.count != 0) {
            if ((index - 3) < self.sosArray.count) {
                NSArray *array = [self.sosArray[index - 3] componentsSeparatedByString:@" "];
                deviceNumberView.telAreaCodeLabel.text = array.firstObject;
                deviceNumberView.telField.text = array.lastObject;
                NSArray *telCode = self.telCodeArray;
                NSUInteger index = [telCode indexOfObject:deviceNumberView.telAreaCodeLabel.text];
                if (index >= self.countryArray.count) {
                    
                }else{
                    NSString *countryName = [self.countryArray objectAtIndex:(NSInteger)index];
                    deviceNumberView.countryNameLabel.text = countryName;
                }
               
            }
        }
    }
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [deviceNumberView.countryNameLabel addGestureRecognizer:labelTapGestureRecognizer];
    [deviceNumberView.buttonSend addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    deviceNumberView.buttonSend.enabled = is;
    [bgView addSubview:deviceNumberView];
    return bgView;
}
-(void)labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    UILabel *label= (UILabel *)recognizer.view;
    CAPDeviceNumber *deviceNumber = (CAPDeviceNumber *)label.superview;
    [self get:deviceNumber];
}

- (void)buttonAction:(UIButton *)button{
    CAPDeviceNumber *deviceNumber = (CAPDeviceNumber *)button.superview;
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
    self.countryArray = [[NSMutableArray alloc] init];
    self.telCodeArray = [[NSMutableArray alloc] init];
    
    for (NSString *countryCode in countryArray) {
        if (dicCode[countryCode] ){
            CAPMMCountry *c = dicCode[countryCode];
            if ([c.code isEqualToString:@"CN"]) {
                c.name = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
                [self.countryArray insertObject:c.name atIndex:0];
                [self.telCodeArray insertObject:c.dial_code atIndex:0];
            }
            c.name = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
//            if ( [c.name isEqualToString:@"台湾"] ){
//                c.name = @"中国台湾";
//            }
            [self.countryArray addObject:c.name];
            [self.telCodeArray addObject:c.dial_code];
        }
    }
    NSArray *array = self.countryArray;
    if (!deviceNumber) {
        return;
    }
    [BRStringPickerView showStringPickerWithTitle:CAPLocalizedString(@"no_country") dataSource:array defaultSelValue:@"" resultBlock:^(id selectValue) {
        NSUInteger index = [array indexOfObject:selectValue];
        NSString *telCode = [self.telCodeArray objectAtIndex:(NSInteger)index];
        deviceNumber.telAreaCodeLabel.text = [NSString stringWithFormat:@"%@",telCode];
        deviceNumber.countryNameLabel.text = selectValue;
    }];
}

- (void)saveButtonClicked{
    self.inputTelArray = [NSMutableArray array];
    CAPDeviceNumber *deviceNumber3 = (CAPDeviceNumber *)[self.bgscrollView viewWithTag:1002];
    CAPDeviceNumber *deviceNumber4 = (CAPDeviceNumber *)[self.bgscrollView viewWithTag:1003];
    if (deviceNumber3.telField.text.length != 0) {
        if ([CAPValidators validPhoneNumber:deviceNumber3.telField.text]) {
            [self.inputTelArray addObject:[NSString stringWithFormat:@"%@ %@",deviceNumber3.telAreaCodeLabel.text,deviceNumber3.telField.text]];
        }
    }
    if (deviceNumber4.telField.text.length != 0) {
        if ([CAPValidators validPhoneNumber:deviceNumber4.telField.text]) {
            [self.inputTelArray addObject:[NSString stringWithFormat:@"%@ %@",deviceNumber4.telAreaCodeLabel.text,deviceNumber4.telField.text]];
        }
    }
    [capgApp showHUD:CAPLocalizedString(@"loading")];
//    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
//    [deviceService setSOSMobile:self.device sosMobiles:self.inputTelArray reply:^(CAPHttpResponse *response) {
//        [capgApp hideHUD];
//        if ([[response.data objectForKey:@"code"] integerValue] == 200) {
//            [capgApp showNotifyInfo:[response.data objectForKey:@"message"] backGroundColor:[CAPColors green1]];
//        }else{
//            [capgApp showNotifyInfo:[response.data objectForKey:@"message"] backGroundColor:[CAPColors gray1]];
//        }
//    }];
    CAPFileUpload *fileUpload = [[CAPFileUpload alloc] init];
    [fileUpload setSOSMobile:self.device array:self.inputTelArray];
    [fileUpload setSuccessBlockObject:^(id  _Nonnull object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [capgApp hideHUD];
            if ([[object objectForKey:@"code"] integerValue] == 200) {
                CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.inputTelArray
                                                                   options:kNilOptions
                                                                     error:nil];
                NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                             encoding:NSUTF8StringEncoding];
                [deviceService deviceSendCommand:self.device.deviceID cmd:@"SOS" param:jsonString reply:^(CAPHttpResponse *response) {
                    NSLog(@"%@",response);
                }];
                [capgApp showNotifyInfo:CAPLocalizedString(@"update_success") backGroundColor:[CAPColors green1]];
            }else{
                [capgApp showNotifyInfo:[object objectForKey:@"message"] backGroundColor:[CAPColors gray1]];
            }
        });
    }];
}


- (CGFloat)getStringHeightWithText:(NSString *)text font:(UIFont *)font viewWidth:(CGFloat)width {
    // 设置文字属性 要和label的一致
    NSDictionary *attrs = @{NSFontAttributeName :font};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    // 计算文字占据的宽高
    CGSize size = [text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
    
    // 当你是把获得的高度来布局控件的View的高度的时候.size转化为ceilf(size.height)。
    return  ceilf(size.height);
}
@end
