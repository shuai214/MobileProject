//
//  CAPAlertView.m
//  GPSTracker
//
//  Created by 曹帅 on 2019/1/15.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPAlertView.h"
#import "LEEAlert.h"
#import "CAPAlertCustomView.h"
#import "CAPFenceAddView.h"
@implementation CAPAlertView

+ (void)initAlertWithContent:(NSString *)content title:(nonnull NSString *)title closeBlock:(nonnull closeBlock)closeBlock okBlock:(nonnull okBlock)okBlock alertType:(AlertType)alertType{
    CAPAlertCustomView *customView = [[CAPAlertCustomView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) title:title contentDesc:content alertType:alertType];
    
    [customView setCloseBlock:^{
        [LEEAlert closeWithCompletionBlock:^{
            // 打开XXX
            closeBlock();
        }];
    }];
    
    [customView setOkBlock:^{
        [LEEAlert closeWithCompletionBlock:^{
            // 打开XXX
          okBlock();
        }];
    }];
    
    [LEEAlert alert].config
    .LeeCustomView(customView)
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderColor([UIColor clearColor])
    .LeeShow();
}

+ (void)initAlertWithContent:(NSString *)content okBlock:(okBlock)okBlock alertType:(AlertType)alertType{
    CAPAlertCustomView *customView = [[CAPAlertCustomView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) title:@"" contentDesc:content alertType:alertType];
    
    [customView setOkBlock:^{
        [LEEAlert closeWithCompletionBlock:^{
            // 打开XXX
            okBlock();
        }];
    }];
    
    [LEEAlert alert].config
    .LeeCustomView(customView)
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderColor([UIColor clearColor])
    .LeeShow();
}

+(void)initAddressAlertWithContent:(NSString *)content ocloseBlock:(closeBlock)closeBlock okBlock:(okAddressBlock)okBlock{
    CAPFenceAddView *customView = [[CAPFenceAddView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) title:content];
    
    [customView setOkAddressBlock:^(NSString * _Nonnull name) {
        [LEEAlert closeWithCompletionBlock:^{
            // 打开XXX
            okBlock(name);
        }];
    }];
    [customView setCloseAddressBlock:^{
        [LEEAlert closeWithCompletionBlock:^{
            // 打开XXX
            closeBlock();
        }];
    }];
    [LEEAlert alert].config
    .LeeCustomView(customView)
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderColor([UIColor clearColor])
    .LeeShow();
}

@end