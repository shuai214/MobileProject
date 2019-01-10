//

#import "CAPAlertView.h"
#import "CAPTimer.h"
#define ScreenWd ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHt ([[UIScreen mainScreen] bounds].size.height)
#define BaseWindow    ([UIApplication sharedApplication].keyWindow)
#define FontSize [UIFont systemFontOfSize:14]

@interface CAPAlertView()
@property(nonatomic,strong)UIButton *btnBack;//背景
@property(nonatomic,strong)UILabel *labTitle;//标题
@property(nonatomic,strong)UIImageView *imgLine;//线
@property(nonatomic,strong)UILabel *labMessage;//内容
@property(nonatomic,strong)UIButton *cancelButton;//取消按钮1
@property(nonatomic,strong)NSString *titles;
@property(nonatomic,strong)NSString *message;
@property(nonatomic,strong)NSString *cancelTitle;

@end

@implementation CAPAlertView

- (instancetype)initWithTitle:(NSString *)title messages:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle {
    self = [super init];
    if (self) {
        _titles = title;
        _message = message;
        _cancelTitle = cancelButtonTitle;
        self.backgroundColor = [UIColor whiteColor];
        [self addBack];
        [self addSubview:self.labTitle];
        [self addSubview:self.imgLine];
        [self addSubview:self.labMessage];
        [self addSubview:self.cancelButton];
        self.alpha = 0;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0;
    }
    return self;
}
//添加确定
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        [CAPTimer initWithGCD:3 beginState:^{
            //设置按钮的样式
            [self.cancelButton setTitle:_cancelTitle forState:UIControlStateNormal];
            self.cancelButton.userInteractionEnabled = YES;
        } endState:^(int seconds) {
            [self.cancelButton setTitle:[NSString stringWithFormat:@"请认真阅读(%.2d)", seconds] forState:UIControlStateNormal];
            self.cancelButton.userInteractionEnabled = NO;
        }];
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.backgroundColor = [UIColor colorWithWhite:0.976 alpha:1.000];
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.layer.cornerRadius = 3.0;
        _cancelButton.layer.borderWidth = 1.0;
        _cancelButton.layer.borderColor = [UIColor colorWithWhite:0.875 alpha:1.000].CGColor;
        [_cancelButton setTitle:_cancelTitle forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = FontSize;
        [_cancelButton addTarget:self action:@selector(gotoCancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.frame = CGRectMake(20, CGRectGetMaxY(self.labMessage.frame)+10, ScreenWd-80, 30);
        
    }
    return _cancelButton;
}
-(void)gotoCancelButtonClick:(UIButton *)btn {
    [self dismiss];
}
//添加内容
- (UILabel *)labMessage {
    if (!_labMessage) {
        _labMessage = [[UILabel alloc] init];
        _labMessage.textColor = [UIColor colorWithWhite:0.259 alpha:1.000];
        _labMessage.textAlignment = NSTextAlignmentCenter;
        _labMessage.numberOfLines = 0;
        _labMessage.text = _message;
        _labMessage.font = FontSize;
        NSDictionary *attrs = @{NSFontAttributeName : FontSize};
        CGRect messageSize = [_message boundingRectWithSize:CGSizeMake(ScreenWd-80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
        _labMessage.frame = CGRectMake(20, CGRectGetMaxY(self.imgLine.frame)+10, ScreenWd-80, messageSize.size.height);
    }
    return _labMessage;
}


//添加横线
- (UIImageView *)imgLine {
    if (!_imgLine) {
        _imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.labTitle.frame)+10, ScreenWd-80, 1)];
        _imgLine.backgroundColor = [UIColor colorWithWhite:0.925 alpha:1.000];
    }
    return _imgLine;
}
//添加头部提示
- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, ScreenWd-80, 20)];
        _labTitle.textAlignment = NSTextAlignmentCenter;
        _labTitle.text = _titles;
    }
    return _labTitle;
}
//添加背景
-(void)addBack
{
    self.btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.btnBack.backgroundColor = [UIColor blackColor];
    [self.btnBack addTarget:self action:@selector(gotoBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.btnBack.alpha = 0;

}
//点击背景按钮
- (void)gotoBackBtnClick:(UIButton *)btn{
//    [self dismiss];
}
/**
 *  视图显示
 */
- (void)show {
    self.bounds = CGRectMake(0, 0, ScreenWd - 40, CGRectGetMaxY(self.cancelButton.frame)+10);
    self.center = CGPointMake(ScreenWd/2, ScreenHt/2);
    [BaseWindow addSubview:self.btnBack];
    [BaseWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.btnBack.alpha = 0.4;
        self.alpha = 1.0;
    }];
}
/**
 *  视图隐藏
 */
- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.btnBack.alpha = 0;
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self.btnBack removeFromSuperview];
        [self removeFromSuperview];
    }];
}
@end
