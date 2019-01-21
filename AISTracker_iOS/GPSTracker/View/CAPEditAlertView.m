//
//  CAPEditAlertView.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/21.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPEditAlertView.h"
#import "SDAutoLayout.h"

#define CLOSE_BUTTON_W_H 40
#define PADDING 20
@interface CAPEditAlertView()
@property(nonatomic,strong)UIButton *closeButton;
@property(nonatomic,strong)UIButton *okButton;
@property(nonatomic,strong)UITextField *inputField;
@property(nonatomic,strong)UIView *paddingView;
@property(nonatomic,copy)NSString *title;

@end

@implementation CAPEditAlertView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;
        self.backgroundColor = [UIColor whiteColor];
        [self initCustomSubview];
        [self configTwoButtonAutoLayout];
    }
    return self;
}
#pragma mark - 初始化子视图

- (void)initCustomSubview{
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];;
    [_closeButton setBackgroundImage:GetImage(@"dialog_close_red") forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeAddressAction) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_closeButton];

    _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _okButton.sd_cornerRadius = @5.0f;
    [_okButton.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [_okButton setTitle:@"确定" forState:UIControlStateNormal];
    [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_okButton setBackgroundColor:[CAPColors red]];
    [_okButton addTarget:self action:@selector(okAddressAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_okButton];
    
    _inputField = [UITextField new];
    _inputField.placeholder = self.title;
    [self addSubview:_inputField];
    _paddingView = [UIView new];
    _paddingView.backgroundColor = [UIColor clearColor];
    [self addSubview:_paddingView];
}
- (void)configTwoButtonAutoLayout{
    // 关闭按钮
    self.closeButton.sd_layout
    .topSpaceToView(self , 0.0f)
    .rightSpaceToView(self , 0.0f)
    .widthIs(CLOSE_BUTTON_W_H)
    .heightIs(CLOSE_BUTTON_W_H);
    
    
    self.inputField.sd_layout
    .topSpaceToView(self.closeButton, PADDING)
    .leftSpaceToView(self, 20.0f)
    .rightSpaceToView(self, 20.0f)
    .heightIs(30.0f);
    
    // 打开按钮
    self.okButton.sd_layout
    .topSpaceToView(self.inputField , PADDING)
    .leftSpaceToView(self , 20.0f)
    .rightSpaceToView(self , 20.0f)
    .heightIs(40.0f);
    
    self.paddingView.sd_layout.topSpaceToView(self.okButton, 10).heightIs(15);
    [self setupAutoHeightWithBottomView:self.paddingView bottomMargin:0.0f];
    
}
#pragma mark --- button action
- (void)closeAddressAction{
    if (self.closeAddressBlock) self.closeAddressBlock();
}
- (void)okAddressAction{
    if (self.okAddressBlock) self.okAddressBlock(self.inputField.text);
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

