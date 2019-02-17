//
//  CAPDeviceVerAlertView.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/2/17.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPDeviceVerAlertView.h"
#import "SDAutoLayout.h"

#define CLOSE_BUTTON_W_H 40
#define PADDING 20

@interface CAPDeviceVerAlertView()
@property(nonatomic,strong)UIButton *closeButton;
@property(nonatomic,strong)UIButton *okButton;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,copy)NSString *contentDesc;

@end

@implementation CAPDeviceVerAlertView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentDesc = title;
        [self initCustomSubview];
        [self configCustomAutoLayout];
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
    [_okButton setTitle:@"升级" forState:UIControlStateNormal];
    [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_okButton setBackgroundColor:[CAPColors red]];
    [_okButton addTarget:self action:@selector(okButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_okButton];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];;
    [_closeButton setBackgroundImage:GetImage(@"dialog_close_red") forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_closeButton];
   
}
- (void)configCustomAutoLayout{
    // 关闭按钮
    self.closeButton.sd_layout
    .topSpaceToView(self , 0.0f)
    .rightSpaceToView(self , 0.0f)
    .widthIs(CLOSE_BUTTON_W_H)
    .heightIs(CLOSE_BUTTON_W_H);
    
    CGSize Size = [self sizeWithString:self.contentDesc font: [UIFont boldSystemFontOfSize:13.0f] maxSize:CGSizeMake(self.width - CLOSE_BUTTON_W_H, MAXFLOAT)];
    
    self.contentLabel.sd_layout
    .topSpaceToView(self.closeButton, PADDING)
    .leftSpaceToView(self, 20.0f)
    .rightSpaceToView(self, 20.0f)
    .heightIs(Size.height);
    
    // 打开按钮
    self.okButton.sd_layout
    .topSpaceToView(self.contentLabel , PADDING)
    .leftSpaceToView(self , 20.0f)
    .rightSpaceToView(self , 20.0f)
    .heightIs(40.0f);
    
    [self setupAutoHeightWithBottomView:self.okButton bottomMargin:10.0f];
    
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
