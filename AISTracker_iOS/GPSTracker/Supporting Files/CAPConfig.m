//
//  CAPConfig.m
//  GPSTrackerSDK
//
//  Created by capaipai@sina.com on 2019/3/26.
//  Copyright © 2019年 capaipai. All rights reserved.
//

#import "CAPConfig.h"
#import "IQKeyboardManager.h"

CAPConfig* capgApp = nil;
@interface CAPConfig(){
    MBProgressHUD *_textHud;
    MBProgressHUD *_progressHud;
}
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) UIWindow *window;
@property (copy, nonatomic) CAPHUDCancelReply cancelBlock;

@end
@implementation CAPConfig
- (instancetype)init{
    self = [super init];
    if(self){
        [IQKeyboardManager sharedManager].enable = YES;
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
        [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
        capgApp = self;
        self.window = [[UIApplication sharedApplication].windows lastObject];
        BOOL hud = [self createHUD];
    }
    return self;
}
- (void)showHUD {
    [self showHUD:NSLocalizedString(@"default_hud_tips", nil)];
}

- (void)showHUD:(NSString *)title {
    _textHud.label.text = title;
    [self.window addSubview:_textHud];
    [_textHud showAnimated:YES];
}

- (void)showHUDWithCancelTitle:(NSString *)cancelTitle onCancelled:(CAPHUDCancelReply)cancelBlock {
    [self showHUD:NSLocalizedString(@"default_hud_tips", nil) cancelTitle:cancelTitle onCancelled:cancelBlock];
}

- (void)showHUD:(NSString *)title cancelTitle:(NSString *)cancelTitle onCancelled:(CAPHUDCancelReply)cancelBlock {
    NSLog(@"showHUD: %@, %@", title, cancelTitle);
    _progressHud.label.text = title;
    _progressHud.progress = 0.0;
    [_progressHud.button setTitle:cancelTitle forState:UIControlStateNormal];
    [self.window addSubview:_progressHud];
    [_progressHud showAnimated:YES];
    self.cancelBlock = cancelBlock;
}

- (void)showHUDWithCancel {
    __weak typeof(self)weakSelf = self;
    [self showHUDWithCancelTitle:NSLocalizedString(@"cancel", nil) onCancelled:^{
        [weakSelf hideHUD];
    }];
}

- (void)updateProgress:(CGFloat)progress {
    _progressHud.progress = progress;
}

- (void)hideHUD {
    [_textHud hideAnimated:YES];
    [_progressHud hideAnimated:YES];
}
- (void)showNotifyInfo:(NSString *)info backGroundColor:(UIColor *)color{
    MBProgressHUD *hud = [MBProgressHUD showTitleToView:self.window postion:NHHUDPostionBottom title:info];
    hud.bezelBackgroundColor(color);
}
- (BOOL)createHUD {
    NSLog(@"[%@ createHUD]", [self class]);
    BOOL result = NO;
    {
        //_hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        _textHud = [[MBProgressHUD alloc] initWithView:self.window];
        _textHud.removeFromSuperViewOnHide = YES;
        _textHud.mode = MBProgressHUDModeIndeterminate;
        _textHud.contentColor = [CAPColors blue3];
        _textHud.label.text = NSLocalizedString(@"default_hud_tips", nil);
        _textHud.label.numberOfLines = 0;
        _textHud.label.lineBreakMode = NSLineBreakByWordWrapping;
        _textHud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        _textHud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.5f];
        //_textHud.margin = 60;
        _textHud.minSize = CGSizeMake(self.window.screen.bounds.size.width*0.78, 160);
        
        _progressHud = [[MBProgressHUD alloc] initWithView:self.window];
        _progressHud.removeFromSuperViewOnHide = YES;
        _progressHud.mode = MBProgressHUDModeDeterminate;
        _progressHud.contentColor = [CAPColors blue3];
        _progressHud.label.text = NSLocalizedString(@"default_hud_tips", nil);
        _progressHud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        _progressHud.backgroundView.color = [UIColor colorWithWhite:0.8f alpha:0.2f];
        _progressHud.button.backgroundColor = [CAPColors blue3];
        _progressHud.minSize = CGSizeMake(self.window.screen.bounds.size.width*0.78, 180);
        [_progressHud.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_progressHud.button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_progressHud.button addTarget:self action:@selector(onCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        result = YES;
        return result;
    }
    return result;
}
- (void)onCancelButtonClicked:(id)sender {
    NSLog(@"onCancelButtonClicked");
    if(self.cancelBlock) {
        self.cancelBlock();
        self.cancelBlock = nil;
    }
}




@end
