//
//  CAPAlertView.m
//  GPSTracker
//
//  Created by 曹帅 on 2019/1/15.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPAlertCustomView.h"
#import "SDAutoLayout.h"

#define CLOSE_BUTTON_W_H 40
#define PADDING 20
@interface CAPAlertCustomView ()
@property(nonatomic,copy)NSString *contentDesc;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *deviceNum;

@property(nonatomic,assign)AlertType alertType;
@property(nonatomic,strong)UIButton *closeButton;
@property(nonatomic,strong)UIButton *okButton;
@property(nonatomic,strong)UIView *paddingView;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UILabel *deviceNumLabel;
@end

@implementation CAPAlertCustomView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title contentDesc:(nonnull NSString *)desc alertType:(AlertType)alertType{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;
        self.contentDesc = desc;
        self.title = title;
        self.alertType = alertType;
        self.deviceNum = desc;
        switch (alertType) {
            case AlertTypeCustom:
                [self initCustomSubview];
                [self configCustomAutoLayout];
                break;
            case AlertTypeNoClose:
                [self initTwoButtonSubview];
                [self configTwoButtonAutoLayout];
                break;
            case AlertTypeTwoButton:
                [self initTwoButtonSubview];
                [self configTwoButtonAutoLayout];
                break;
            case AlertTypeButton:
                [self initButtonSubview];
                [self configButtonAutoLayout];
                break;
            default:
                break;
        }

    }
    return self;
}



#pragma mark - 初始化子视图

- (void)initCustomSubview{
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];;
    [_closeButton setBackgroundImage:GetImage(@"dialog_close_red") forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (self.alertType != AlertTypeNoClose) {
        [self addSubview:_closeButton];
    }
    
    _titleLabel = [UILabel new];
    _titleLabel.text = self.title;
    _titleLabel.textColor = [UIColor lightGrayColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    [self addSubview:_titleLabel];
    
    _contentLabel = [UILabel new];
    _contentLabel.text = self.contentDesc;
    _contentLabel.textColor = [UIColor lightGrayColor];
    _contentLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.numberOfLines = 0;
    [self addSubview:_contentLabel];
    
    _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _okButton.sd_cornerRadius = @5.0f;
    [_okButton.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [_okButton setTitle:CAPLocalizedString(@"ok") forState:UIControlStateNormal];
    [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_okButton setBackgroundColor:[CAPColors red]];
    [_okButton addTarget:self action:@selector(okButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_okButton];
    
    _paddingView = [UIView new];
    _paddingView.backgroundColor = [UIColor clearColor];
    [self addSubview:_paddingView];
}

- (void)configCustomAutoLayout{
    // 关闭按钮
    self.closeButton.sd_layout
    .topSpaceToView(self , 0.0f)
    .rightSpaceToView(self , 0.0f)
    .widthIs(CLOSE_BUTTON_W_H)
    .heightIs((self.alertType == AlertTypeNoClose) ? 0 : CLOSE_BUTTON_W_H);
    
    CGSize titleSize = [self sizeWithString:self.title font: [UIFont boldSystemFontOfSize:13.0f] maxSize:CGSizeMake(self.width - CLOSE_BUTTON_W_H, MAXFLOAT)];
    self.titleLabel.sd_layout
    .topSpaceToView(self.closeButton,(titleSize.height == 0) ? 0 : PADDING)
    .leftSpaceToView(self, 20.0f)
    .rightSpaceToView(self, 20.0f)
    .heightIs(titleSize.height);
    
   CGSize Size = [self sizeWithString:self.contentDesc font: [UIFont boldSystemFontOfSize:13.0f] maxSize:CGSizeMake(self.width - CLOSE_BUTTON_W_H, MAXFLOAT)];
    
    self.contentLabel.sd_layout
    .topSpaceToView(self.titleLabel, PADDING)
    .leftSpaceToView(self, 20.0f)
    .rightSpaceToView(self, 20.0f)
    .heightIs(Size.height);
    
    // 打开按钮
    self.okButton.sd_layout
    .topSpaceToView(self.contentLabel , PADDING)
    .leftSpaceToView(self , 20.0f)
    .rightSpaceToView(self , 20.0f)
    .heightIs(40.0f);
    
    self.paddingView.sd_layout.topSpaceToView(self.okButton, 10).heightIs(15);
    
    [self setupAutoHeightWithBottomView:self.paddingView bottomMargin:0.0f];

}


- (void)initTwoButtonSubview{
    
    _titleLabel = [UILabel new];
    _titleLabel.text = self.title;
    _titleLabel.textColor = [UIColor lightGrayColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    [self addSubview:_titleLabel];
    
    
    _deviceNumLabel = [UILabel new];
    _deviceNumLabel.text = self.contentDesc;
    _deviceNumLabel.textColor = [UIColor lightGrayColor];
    _deviceNumLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    _deviceNumLabel.textAlignment = NSTextAlignmentCenter;
    _deviceNumLabel.numberOfLines = 0;
    [self addSubview:_deviceNumLabel];
    
    _contentLabel = [UILabel new];
    _contentLabel.textColor = [UIColor lightGrayColor];
    _contentLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.numberOfLines = 0;
    [self addSubview:_contentLabel];
      __block int timeout = 60; //倒计时时间
      dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
      dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
      dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
      dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self->_okButton.enabled = YES;
                self->_closeButton.enabled = YES;
                self->_okButton.backgroundColor = [CAPColors red];
                self->_closeButton.backgroundColor = [CAPColors gray2];
            });
        }else{
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self->_contentLabel.text = [NSString stringWithFormat:@"%@S",strTime];
            });
            timeout--;
        }
    });
    if(self.alertType == AlertTypeNoClose){
        
    }else if(self.alertType == AlertTypeTwoButton){
        dispatch_resume(_timer);
    }
    _imgView = [[UIImageView alloc] initWithImage:GetImage(@"ic_default_avatar_new")];
    _imgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_imgView];
    
    _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _okButton.sd_cornerRadius = @5.0f;
    [_okButton.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [_okButton setTitle:CAPLocalizedString(@"ok") forState:UIControlStateNormal];
    [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_okButton addTarget:self action:@selector(okButtonAction) forControlEvents:UIControlEventTouchUpInside];
    if(self.alertType == AlertTypeNoClose){
        _okButton.enabled = YES;
        [_okButton setBackgroundColor:[CAPColors red]];
    }else if(self.alertType == AlertTypeTwoButton){
        _okButton.enabled = NO;
        [_okButton setBackgroundColor:[CAPColors gray1]];
    }
    [self addSubview:_okButton];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];;
    [_closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    _closeButton.sd_cornerRadius = @5.0f;
    [_closeButton.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [_closeButton setTitle:CAPLocalizedString(@"cancel") forState:UIControlStateNormal];
    [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_closeButton setBackgroundColor:[CAPColors gray1]];
    _closeButton.enabled = NO;
    [self addSubview:_closeButton];
    
    _paddingView = [UIView new];
    _paddingView.backgroundColor = [UIColor clearColor];
    [self addSubview:_paddingView];
}

- (void)configTwoButtonAutoLayout{
    
    CGSize Size = [self sizeWithString:self.contentDesc font: [UIFont boldSystemFontOfSize:13.0f] maxSize:CGSizeMake(self.width - CLOSE_BUTTON_W_H, MAXFLOAT)];
    self.titleLabel.sd_layout
    .topSpaceToView(self, PADDING)
    .leftSpaceToView(self, 20.0f)
    .rightSpaceToView(self, 20.0f)
    .heightIs(Size.height);
    
    CGSize titleSize = [self sizeWithString:self.deviceNum font: [UIFont boldSystemFontOfSize:13.0f] maxSize:CGSizeMake(self.width - CLOSE_BUTTON_W_H, MAXFLOAT)];
    CGFloat x = (CLOSE_BUTTON_W_H - titleSize.height) / 2;
    CGFloat y = self.width - (CLOSE_BUTTON_W_H + titleSize.width + PADDING);
    
    self.imgView.sd_layout
    .topSpaceToView(self.titleLabel, PADDING)
    .leftSpaceToView(self, y / 2)
    .widthIs(CLOSE_BUTTON_W_H)
    .heightIs(CLOSE_BUTTON_W_H);
    
    self.deviceNumLabel.sd_layout
    .topSpaceToView(self.titleLabel,PADDING + x)
    .leftSpaceToView(self.imgView, PADDING)
    .widthIs(titleSize.width)
    .heightIs(titleSize.height);
    
    CGFloat timeHeight = 0;
    if(self.alertType == AlertTypeNoClose){
        timeHeight = 0;
    }else if(self.alertType == AlertTypeTwoButton){
        timeHeight = 20;
    }
    self.contentLabel.sd_layout
    .topSpaceToView(self.deviceNumLabel,PADDING + x)
    .leftSpaceToView(self, PADDING)
    .rightSpaceToView(self,PADDING)
    .heightIs(timeHeight);
    
    if (self.alertType == AlertTypeNoClose) {
        // 打开按钮
        self.okButton.sd_layout
        .topSpaceToView(self.contentLabel , PADDING)
        .leftSpaceToView(self , CLOSE_BUTTON_W_H)
        .rightSpaceToView(self , CLOSE_BUTTON_W_H)
        .heightIs(CLOSE_BUTTON_W_H);
    }else if(self.alertType == AlertTypeTwoButton){
        // 关闭按钮
        self.closeButton.sd_layout
        .topSpaceToView(self.contentLabel , PADDING)
        .rightSpaceToView(self , 40.0f)
        .widthIs(60.0f)
        .heightIs(CLOSE_BUTTON_W_H);
        
        // 打开按钮
        self.okButton.sd_layout
        .topSpaceToView(self.contentLabel , PADDING)
        .leftSpaceToView(self , 40.0f)
        .widthIs(60.0f)
        .heightIs(CLOSE_BUTTON_W_H);
    }
   
    
    self.paddingView.sd_layout.topSpaceToView(self.okButton, 10).heightIs(15);
    [self setupAutoHeightWithBottomView:self.paddingView bottomMargin:0.0f];
    
}


- (void)initButtonSubview{
    _titleLabel = [UILabel new];
    _titleLabel.text = self.title;
    _titleLabel.textColor = [UIColor lightGrayColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    [self addSubview:_titleLabel];
    
    
    _deviceNumLabel = [UILabel new];
    _deviceNumLabel.text = self.deviceNum;
    _deviceNumLabel.textColor = [UIColor lightGrayColor];
    _deviceNumLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    _deviceNumLabel.textAlignment = NSTextAlignmentCenter;
    _deviceNumLabel.numberOfLines = 0;
    [self addSubview:_deviceNumLabel];
    
    _imgView = [[UIImageView alloc] initWithImage:GetImage(@"ic_default_avatar_new")];
    _imgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_imgView];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];;
    [_closeButton setBackgroundImage:GetImage(@"dialog_close_red") forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_closeButton];

    
    _paddingView = [UIView new];
    _paddingView.backgroundColor = [UIColor clearColor];
    [self addSubview:_paddingView];
}

- (void)configButtonAutoLayout{
    
    // 关闭按钮
    self.closeButton.sd_layout
    .topSpaceToView(self , 0.0f)
    .rightSpaceToView(self , 0.0f)
    .widthIs(CLOSE_BUTTON_W_H)
    .heightIs(CLOSE_BUTTON_W_H);
    
    CGSize titleSize = [self sizeWithString:self.title font: [UIFont boldSystemFontOfSize:13.0f] maxSize:CGSizeMake(self.width - CLOSE_BUTTON_W_H, MAXFLOAT)];
    self.titleLabel.sd_layout
    .topSpaceToView(self.closeButton,(titleSize.height == 0) ? 0 : PADDING)
    .leftSpaceToView(self, 20.0f)
    .rightSpaceToView(self, 20.0f)
    .heightIs(titleSize.height);
    
    CGSize Size = [self sizeWithString:self.contentDesc font: [UIFont boldSystemFontOfSize:13.0f] maxSize:CGSizeMake(self.width - CLOSE_BUTTON_W_H, MAXFLOAT)];
    
    self.deviceNumLabel.sd_layout
    .topSpaceToView(self.titleLabel, PADDING)
    .leftSpaceToView(self, 20.0f)
    .rightSpaceToView(self, 20.0f)
    .heightIs(Size.height);
    
    self.imgView.sd_layout
    .topSpaceToView(self.deviceNumLabel, PADDING)
    .centerXEqualToView(self)
    .heightIs(CLOSE_BUTTON_W_H)
    .widthIs(CLOSE_BUTTON_W_H);
    
    self.paddingView.sd_layout.topSpaceToView(self.imgView, 10).heightIs(15);
    [self setupAutoHeightWithBottomView:self.paddingView bottomMargin:0.0f];
    
}



#pragma mark --- button action
- (void)closeAction{
    if (self.closeBlock) self.closeBlock();
}
- (void)okButtonAction{
    if (self.okBlock) self.okBlock();

}
/**
 *  计算文本的宽高
 *
 *  @param str     需要计算的文本
 *  @param font    文本显示的字体
 *  @param maxSize 文本显示的范围
 *
 *  @return 文本占用的真实宽高
 */
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    if (str.length == 0) {
        return CGSizeMake(0, 0);
    }
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}
@end
