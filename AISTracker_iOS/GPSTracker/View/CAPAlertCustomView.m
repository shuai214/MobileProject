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
#define PADDING 10
@interface CAPAlertCustomView ()
@property(nonatomic,copy)NSString *contentDesc;
@property(nonatomic,strong)UIButton *closeButton;
@property(nonatomic,strong)UIButton *okButton;
@property(nonatomic,strong)UIView *paddingView;
@property(nonatomic,strong)UILabel *contentLabel;

@end

@implementation CAPAlertCustomView

- (instancetype)initWithFrame:(CGRect)frame contentDesc:(nonnull NSString *)desc{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubview];
    }
    return self;
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];;
    [_closeButton setImage:GetImage(@"dialog_close_red") forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_closeButton];
    
    _contentLabel = [UILabel new];
    _contentLabel.text = self.contentDesc;
    _contentLabel.textColor = [UIColor lightGrayColor];
    _contentLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [self addSubview:_contentLabel];
    
    _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _okButton.sd_cornerRadius = @5.0f;
    [_okButton.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [_okButton setTitle:@"确定" forState:UIControlStateNormal];
    [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_okButton setBackgroundColor:[CAPColors red]];
    [_okButton addTarget:self action:@selector(okButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_okButton];
    
    _paddingView = [UIView new];
    _paddingView.backgroundColor = [UIColor clearColor];
    [self addSubview:_paddingView];
}

- (void)configAutoLayout{
    // 关闭按钮
    self.closeButton.sd_layout
    .topSpaceToView(self , 0.0f)
    .rightSpaceToView(self , 0.0f)
    .widthIs(CLOSE_BUTTON_W_H)
    .heightIs(CLOSE_BUTTON_W_H);
    
   CGSize Size = [self sizeWithString:self.contentDesc font: [UIFont boldSystemFontOfSize:18.0f] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    self.contentLabel.sd_layout
    .topSpaceToView(self.closeButton, PADDING)
    .leftSpaceToView(self, 20.0f)
    .rightSpaceToView(self, 20.0f)
    .heightIs(Size.height);
    
    // 打开按钮
    
    self.okButton.sd_layout
    .topSpaceToView(self.contentLabel , 10.0f)
    .leftSpaceToView(self , 20.0f)
    .rightSpaceToView(self , 20.0f)
    .heightIs(40.0f);
    
    self.paddingView.sd_layout.topSpaceToView(self.okButton, 10).heightIs(15);
}

#pragma mark --- button action
- (void)closeAction{
    
}
- (void)okButtonAction{
    
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
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}
@end
