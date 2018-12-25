//
//  CAPAlerts.m
//  GPSTracker
//
//  Created by WeifengYao on 12/7/2017.
//  Copyright © 2017 capelabs. All rights reserved.
//

#import "CAPAlerts.h"
#import "SCLAlertView.h"

@implementation CAPAlerts

+ (CAPAlert *)alertSuccess:(NSString *)message {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert showSuccess:@"" subTitle:message closeButtonTitle:NSLocalizedString(@"ok", nil) duration:0.0f];
    return (CAPAlert *)alert;
}

+ (void)alertSuccess:(NSString *)message actionBlock:(CAPAlertActionBlock)action {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    SCLButton * okButton = [alert addButton:NSLocalizedString(@"ok", nil) actionBlock:action];
    okButton.accessibilityIdentifier = @"alert_ok_button";
    [alert showSuccess:@""subTitle:message closeButtonTitle:nil duration:0.0f];
}

+ (void)alertSuccess:(NSString *)message buttonTitle:(NSString *)buttonTitle actionBlock:(CAPAlertActionBlock)action {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:buttonTitle actionBlock:action];
    [alert showSuccess:@"" subTitle:message closeButtonTitle:nil duration:0.0f];
}
+ (void)showSuccess:(NSString *)message subTitle:(NSString *)subTitle buttonTitle:(NSString *)buttonTitle cancleButtonTitle:(NSString *)cancleTitle actionBlock:(CAPAlertActionBlock)action {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:buttonTitle actionBlock:action];
    [alert showSuccess:message subTitle:subTitle closeButtonTitle:cancleTitle duration:0.0f];
}
+ (void)alertWarning:(NSString *)message {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert showWarning:@"" subTitle:message closeButtonTitle:NSLocalizedString(@"ok", nil) duration:0.0f];
}

+ (void)alertWarning:(NSString *)message actionBlock:(CAPAlertActionBlock)action {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:NSLocalizedString(@"yes", nil) actionBlock:action];
    [alert showWarning:@"" subTitle:message closeButtonTitle:NSLocalizedString(@"no", nil) duration:0.0f];
}

+ (void)alertWarning:(NSString *_Nullable)title message:(NSString *_Nullable)message {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert showWarning:title subTitle:message closeButtonTitle:NSLocalizedString(@"ok", nil) duration:0.0f];
}

+ (void)alertWarning:(NSString *)message buttonTitle:(NSString *)title actionBlock:(CAPAlertActionBlock)action {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:title actionBlock:action];
    [alert showWarning:@"" subTitle:message closeButtonTitle:nil duration:0.0f];
}

+ (void)alertWarningWithoutClose:(NSString *)message buttonTitle:(NSString *)title actionBlock:(CAPAlertActionBlock)action {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    UIButton *button = [alert addButton:title actionBlock:action];
    button.tag = -99;
    [alert showWarning:@"" subTitle:message closeButtonTitle:nil duration:0.0f];
}

+ (void)alertWarning:(NSString *)message positiveActionBlock:(CAPAlertActionBlock)positiveAction negativeActionBlock:(CAPAlertActionBlock)negativeAction {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    SCLButton *yesButton = [alert addButton:NSLocalizedString(@"yes", nil) actionBlock:positiveAction];
    yesButton.accessibilityIdentifier = @"alert_yes_button";
    SCLButton *noButton = [alert addButton:NSLocalizedString(@"no", nil) actionBlock:negativeAction];
    noButton.accessibilityIdentifier = @"alert_no_button";
    
    [alert showWarning:@"" subTitle:message closeButtonTitle:nil duration:0.0f];
}

+ (void)alertError:(NSString *)message {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert showError:@"" subTitle:message closeButtonTitle:NSLocalizedString(@"ok", nil) duration:0.0f];
}

+ (void)alertError:(NSString *)message actionBlock:(CAPAlertActionBlock)action {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    SCLButton *yesButton = [alert addButton:NSLocalizedString(@"yes", nil) actionBlock:action];
    yesButton.accessibilityIdentifier = @"alert_yes_button";
    [alert showError:@"" subTitle:message closeButtonTitle:NSLocalizedString(@"no", nil) duration:0.0f];
}

+ (void)alertError:(NSString *)message actionBlock:(CAPAlertSwitchBlock)action switchLabel:(NSString *)label {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    SCLSwitchView *switchView = [alert addSwitchViewWithLabel:label];
    SCLButton *yesButton = [alert addButton:NSLocalizedString(@"yes", nil) actionBlock:^{
        action(switchView.selected);
    }];
    yesButton.accessibilityIdentifier = @"alert_yes_button";
    [alert showError:@"" subTitle:message closeButtonTitle:NSLocalizedString(@"no", nil) duration:0.0f];
}

+ (void)alertError:(NSString *)message buttonTitle:(NSString *)buttonTitle actionBlock:(CAPAlertActionBlock)action {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:buttonTitle actionBlock:action];
    [alert showError:@"" subTitle:message closeButtonTitle:nil duration:0.0f];
}

+ (CAPAlert *)alertError:(NSString *)message positiveTitle:(NSString *)positiveTitle positiveActionBlock:(CAPAlertActionBlock)positiveAction negativeTitle:(NSString *)negativeTitle negativeActionBlock:(CAPAlertActionBlock)negativeAction {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:positiveTitle actionBlock:positiveAction];
    [alert addButton:negativeTitle actionBlock:negativeAction];
    [alert showError:@"" subTitle:message closeButtonTitle:nil duration:0.0f];
    return alert;
}


+ (void)alertChooser:(NSArray *)titles icons:(NSArray *)icons target:(nullable id)target action:(nullable SEL)action currentSelectedIndex:(NSUInteger)index {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    NSUInteger topSpace = 20;
    NSUInteger bottomSpace = 20;
    NSUInteger width = [UIScreen mainScreen].bounds.size.width*0.9;
    NSUInteger height = [UIScreen mainScreen].bounds.size.height/5*3;
    NSUInteger itemHeight = 50;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, MIN(height, itemHeight * titles.count+topSpace))];
    scrollView.contentSize = CGSizeMake(width, itemHeight*titles.count+topSpace+bottomSpace);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    //scrollView.contentInset = UIEdgeInsetsMake(20, 20, 20, 20);
    [scrollView addSubview:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, topSpace)]];
    for(NSUInteger i=0; i<titles.count; i++) {
        if(i > 0) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(6, itemHeight*i+topSpace, width-12, 0.5)];
            line.backgroundColor = [UIColor grayColor];
            [scrollView addSubview:line];
        }
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, itemHeight*i+topSpace, width-20, itemHeight)];
        button.accessibilityIdentifier = [NSString stringWithFormat:@"source_phone_button%ld", (long)i];
        button.tag = i;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:80.0/255.0 green:81.0/255.0 blue:80.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:160.0/255.0 green:161.0/255.0 blue:160.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:icons[i]] forState:UIControlStateNormal];
        [button.titleLabel setFont:(i == index ? [UIFont boldSystemFontOfSize:15.0] : [UIFont systemFontOfSize:15.0])];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
    }
    [scrollView addSubview:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, bottomSpace)]];
    [alert addCustomView:scrollView]; //来源手机列表:
    [alert showSuccess:@"" subTitle:@"" closeButtonTitle:NSLocalizedString(@"cancel", nil) duration:0.0f];
}

+ (void)alertDetail:(NSArray * _Nullable)keys values:(NSArray * _Nullable)values actionBlock:(CAPAlertActionBlock)action {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];

    NSUInteger n = keys.count;
    NSUInteger topSpace = 20;
    NSUInteger bottomSpace = 20;
    NSUInteger width = [UIScreen mainScreen].bounds.size.width*0.9;
    NSUInteger height = [UIScreen mainScreen].bounds.size.height/20*11;
    NSUInteger itemHeight = 45;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, MIN(height, itemHeight * n+topSpace+bottomSpace))];
    scrollView.contentSize = CGSizeMake(width, itemHeight*n+topSpace+bottomSpace);
    //scrollView.backgroundColor = [UIColor redColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    //scrollView.contentInset = UIEdgeInsetsMake(20, 20, 20, 20);
    [scrollView addSubview:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)]];
    for(NSUInteger i=0; i<n; i++) {
        UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, itemHeight*i+topSpace, width-(i==0 ? 100 : 20), itemHeight)];
        keyLabel.tag = i;
        keyLabel.textColor = (i== 0 ? [UIColor blackColor] : [UIColor grayColor]);
        keyLabel.font = (i== 0 ? [UIFont systemFontOfSize:14] : [UIFont systemFontOfSize:13]);
        [keyLabel setText:keys[i]];
        keyLabel.textAlignment = NSTextAlignmentLeft;
        [scrollView addSubview:keyLabel];

        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, itemHeight*i+topSpace+(i==0 ? 0 : 20), width-20, itemHeight)];
        valueLabel.tag = i;
        valueLabel.textColor = [UIColor blackColor];
        valueLabel.font = [UIFont systemFontOfSize:14];
        [valueLabel setText:values[i]];
        valueLabel.textAlignment = (i== 0 ? NSTextAlignmentRight : NSTextAlignmentLeft);
        [scrollView addSubview:valueLabel];
        if(i == 0) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(6, itemHeight+topSpace, width-12, 0.5)];
            line.backgroundColor = [UIColor grayColor];
            [scrollView addSubview:line];
        }
    }

    [scrollView addSubview:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, bottomSpace)]];
    [alert addCustomView:scrollView];
    if(action) {
        SCLButton *addButton = [alert addButton:NSLocalizedString(@"add_tag", nil) actionBlock:action];
        addButton.accessibilityIdentifier = @"add_tag_button";
    }
    [alert showSuccess:@"" subTitle:@"" closeButtonTitle:NSLocalizedString(@"cancel", nil) duration:0.0f];
}

+ (void)hideAnyAlert {
    NSLog(@"[CAPViews hideAnyAlert]");
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *controller = window.rootViewController;
    if([controller isKindOfClass:[SCLAlertView class]]) {
        SCLAlertView *alert = (SCLAlertView *)controller;
        [alert hideView];
    }
}

+ (void)hideAlert {
    NSLog(@"[CAPViews hideAlert]");
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if(window.windowLevel >= UIWindowLevelAlert+15) {
        UIViewController *controller = window.rootViewController;
        if([controller isKindOfClass:[SCLAlertView class]]) {
            SCLAlertView *alert = (SCLAlertView *)controller;
            [alert hideView];
        }
    }
}

+ (void)hideAlert:(CAPAlert *)alert {
    [((SCLAlertView *)alert) hideView];
}

+ (void)alertInfo:(NSString *)message actionBlock:(CAPAlertActionBlock)action {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:NSLocalizedString(@"ok", nil) actionBlock:action];
    [alert showInfo:NSLocalizedString(@"tips", nil) subTitle:message closeButtonTitle:nil duration:0.0f];
}

+ (void)alertNotice:(NSString *)message actionBlock:(CAPAlertActionBlock)action {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:NSLocalizedString(@"ok", nil) actionBlock:action];
    [alert showNotice:NSLocalizedString(@"notice", nil) subTitle:message closeButtonTitle:nil duration:0.0f];
}

+ (void)alertEdit:(UIViewController *)vc title:(NSString *)title  defaultText:(NSString *)defaultText placeholder:(NSString *)placeholder actionBlock:(CAPAlertEditBlock)action {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    SCLTextView *textField = [alert addTextField:placeholder];
    textField.text = defaultText;
    textField.accessibilityIdentifier = @"alert_text_field";
    alert.hideAnimationType = SCLAlertViewHideAnimationSimplyDisappear;
    SCLButton *okButton = [alert addButton:NSLocalizedString(@"sure", nil) actionBlock:^(void) {
        if(textField.text.length > 0 && textField.text.length < 128) {
            NSLog(@"Text value: %@", textField.text);
            action(textField.text);
        }
    }];
    okButton.accessibilityIdentifier = @"alert_ok_button";
    
    [alert showEdit:vc title:title subTitle:@"" closeButtonTitle:NSLocalizedString(@"cancel", nil) duration:0.0f];
}

+ (void)alertCustomViews:(NSArray *)views actionBlock:(CAPAlertActionBlock)action {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.hideAnimationType = SCLAlertViewHideAnimationSimplyDisappear;
    
    for(UIView *view in views) {
        [alert addCustomView:view];
    }
    
    [alert addButton:NSLocalizedString(@"sure", nil) actionBlock:action];
    [alert showSuccess:@"" subTitle:@"" closeButtonTitle:NSLocalizedString(@"cancel", nil) duration:0.0f];
}

+ (void)alertConfirmation:(NSString *)message actionBlock:(CAPAlertActionBlock)action {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:NSLocalizedString(@"yes", nil) actionBlock:action];
    [alert showNotice:NSLocalizedString(@"confirm", nil) subTitle:message closeButtonTitle:NSLocalizedString(@"no", nil) duration:0.0f];
}

+ (void)alertPin:(NSString *)message {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert showSuccess:@"" subTitle:message closeButtonTitle:NSLocalizedString(@"ok", nil) duration:0.0f];
}
@end
