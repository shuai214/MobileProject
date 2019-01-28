//
//  CAPFenceAddView.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/16.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPFenceAddView.h"
#import "SDAutoLayout.h"

#define CLOSE_BUTTON_W_H 40
#define PADDING 20
@interface CAPFenceAddView()
@property(nonatomic,strong)UIButton *closeButton;
@property(nonatomic,strong)UIButton *okButton;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,copy)NSString *contentDesc;
@property(nonatomic,strong)UIView *line1;
@property(nonatomic,strong)UIView *line2;
@property(nonatomic,strong)UIView *paddingView;
@property(nonatomic,strong)UITextField *inputField;

@end

@implementation CAPFenceAddView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    
        self = [super initWithFrame:frame];
        if (self) {
            self.backgroundColor = [UIColor whiteColor];
            self.contentDesc = title;
            [self initCustomSubview];
            [self configTwoButtonAutoLayout];
            [self.inputField becomeFirstResponder];
        }
    return self;
}
#pragma mark - 初始化子视图

- (void)initCustomSubview{
    _contentLabel = [UILabel new];
    _contentLabel.text = self.contentDesc;
    _contentLabel.textColor = [UIColor lightGrayColor];
    _contentLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.numberOfLines = 0;
    [self addSubview:_contentLabel];
    
    _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _okButton.sd_cornerRadius = @5.0f;
    [_okButton.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [_okButton setTitle:@"确定" forState:UIControlStateNormal];
    [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_okButton setBackgroundColor:[CAPColors red]];
    [_okButton addTarget:self action:@selector(okAddressAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_okButton];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];;
    [_closeButton addTarget:self action:@selector(closeAddressAction) forControlEvents:UIControlEventTouchUpInside];
    _closeButton.sd_cornerRadius = @5.0f;
    [_closeButton.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [_closeButton setTitle:@"取消" forState:UIControlStateNormal];
    [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_closeButton setBackgroundColor:[CAPColors gray1]];
    [self addSubview:_closeButton];
    
    _line1 = [UIView new];
    _line1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_line1];
    _line2 = [UIView new];
    _line2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_line2];
    
    _inputField = [UITextField new];
    _inputField.placeholder = @"请输入围栏名称";
    [self addSubview:_inputField];
    _paddingView = [UIView new];
    _paddingView.backgroundColor = [UIColor clearColor];
    [self addSubview:_paddingView];
}
- (void)configTwoButtonAutoLayout{
    // 关闭按钮
    self.closeButton.sd_layout
    .topSpaceToView(self , PADDING)
    .rightSpaceToView(self , 40.0f)
    .widthIs(60.0f)
    .heightIs(CLOSE_BUTTON_W_H);
    
    // 打开按钮
    self.okButton.sd_layout
    .topSpaceToView(self , PADDING)
    .leftSpaceToView(self , 40.0f)
    .widthIs(60.0f)
    .heightIs(CLOSE_BUTTON_W_H);
    
    self.line1.sd_layout
    .topSpaceToView(self.okButton, PADDING / 2)
    .heightIs(0.5)
    .leftEqualToView(self)
    .rightEqualToView(self);
    
    CGSize Size = [self sizeWithString:self.contentDesc font: [UIFont boldSystemFontOfSize:18.0f] maxSize:CGSizeMake(self.width - CLOSE_BUTTON_W_H, MAXFLOAT)];
    self.contentLabel.sd_layout
    .topSpaceToView(self.closeButton, PADDING)
    .leftSpaceToView(self, 20.0f)
    .rightSpaceToView(self, 20.0f)
    .heightIs(Size.height);
    
    self.line2.sd_layout
    .topSpaceToView(self.contentLabel, PADDING / 2)
    .heightIs(0.5)
    .leftEqualToView(self)
    .rightEqualToView(self);
    
    self.inputField.sd_layout
    .topSpaceToView(self.contentLabel, PADDING)
    .leftSpaceToView(self, 20.0f)
    .rightSpaceToView(self, 20.0f)
    .heightIs(30.0f);
    self.paddingView.sd_layout.topSpaceToView(self.inputField, 10).heightIs(15);
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
