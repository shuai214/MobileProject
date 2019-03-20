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
#import "CAPEditAlertView.h"
#import "CAPSOSAlertView.h"
#import "CAPModifyAvatar.h"
#import "CAPBindAlertView.h"
#import "CAPDeviceVerAlertView.h"
#import "CAPFenceAlertView.h"
@implementation CAPAlertView

+ (void)initAlertWithContent:(NSString *)content title:(NSString *)title closeBlock:(nonnull closeBlock)closeBlock okBlock:(nonnull okBlock)okBlock alertType:(AlertType)alertType{
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
    .LeeShow()
    .LeeClickBackgroundClose(YES)
    .LeeCornerRadius(15);
}
+ (void)initCloseAlertWithContent:(NSString *)content title:(NSString *)title closeBlock:(closeBlock)closeBlock alertType:(AlertType)alertType{
    CAPAlertCustomView *customView = [[CAPAlertCustomView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) title:content contentDesc:title alertType:alertType];
    
    [customView setCloseBlock:^{
        [LEEAlert closeWithCompletionBlock:^{
            // 打开XXX
            closeBlock();
        }];
    }];
    
    [LEEAlert alert].config
    .LeeCustomView(customView)
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderColor([UIColor clearColor])
    .LeeShow().LeeCornerRadius(15);
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
    .LeeShow().LeeCornerRadius(15);
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
    .LeeShow().LeeCornerRadius(15);
}
+ (void)initAddressEditWithContent:(NSString *)content ocloseBlock:(closeBlock)closeBlock okBlock:(okAddressBlock)okBlock{
    CAPEditAlertView *customView = [[CAPEditAlertView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) title:content];
    
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
    .LeeShow().LeeCornerRadius(15);
}

+ (void)initSOSAlertViewWithContent:(MQTTInfo *)contentInfo ocloseBlock:(closeBlock)closeBlock okBlock:(okMQTTInfoBlock)okMQTTInfoBlock{
    CAPSOSAlertView *view = [CAPSOSAlertView instance];
    [view fillData:contentInfo];
    // Nib形式请设置UIViewAutoresizingNone
    view.autoresizingMask = UIViewAutoresizingNone;
    [view setOkAddressBlock:^(MQTTInfo * _Nonnull info) {
            [LEEAlert closeWithCompletionBlock:^{
                // 打开XXX
                okMQTTInfoBlock(info);
            }];
    }];
    [view setCloseAddressBlock:^{
        [LEEAlert closeWithCompletionBlock:^{
            // 打开XXX
            closeBlock();
        }];
    }];
    [LEEAlert alert].config
    .LeeCustomView(view)
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderColor([UIColor clearColor])
    .LeeShow().LeeCornerRadius(15);
}
+ (void)initTakingPhotoBlock:(takingPhotoBlock)takingBlock albumBlock:(albumBlock)albumBlock closeBlock:(closeBlock)closeBlock{
     CAPModifyAvatar *view = [CAPModifyAvatar instance];
    [view initView];
    // Nib形式请设置UIViewAutoresizingNone
    view.autoresizingMask = UIViewAutoresizingNone;
    [view setTabkingPhotoBlock:^{
        [LEEAlert closeWithCompletionBlock:^{
            // 打开XXX
            takingBlock();
        }];
    }];
    [view setAlbumBlock:^{
        [LEEAlert closeWithCompletionBlock:^{
            // 打开XXX
            albumBlock();
        }];
    }];
    [view setCloseBlock:^{
        [LEEAlert closeWithCompletionBlock:^{
            // 打开XXX
            closeBlock();
        }];
    }];
    [LEEAlert alert].config
    .LeeCustomView(view)
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderColor([UIColor clearColor])
    .LeeShow().LeeCornerRadius(15);
}
+ (void)initBindAlertViewWithContent:(NSString *)content ocloseBlock:(closeBlock)closeBlock okBlock:(okBlock)okBlock{
    CAPBindAlertView *view = [CAPBindAlertView instance];
    [view fillData:content];
    // Nib形式请设置UIViewAutoresizingNone
    view.autoresizingMask = UIViewAutoresizingNone;
    [view setOkBindUserBlock:^{
        [LEEAlert closeWithCompletionBlock:^{
            // 打开XXX
            okBlock();
        }];
    }];
   
    [view setCloseUserBlock:^{
        [LEEAlert closeWithCompletionBlock:^{
            // 打开XXX
            closeBlock();
        }];
    }];
    [LEEAlert alert].config
    .LeeCustomView(view)
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderColor([UIColor clearColor])
    .LeeShow().LeeCornerRadius(15);
}
+ (void)initDeviceVerWithContent:(NSString *)content buttonTitle:(NSString *)buttonTitle closeBlock:(closeBlock)closeBlock okBlock:(okBlock)okBlock{
    CAPDeviceVerAlertView *customView = [[CAPDeviceVerAlertView alloc] initWithFrame:CGRectMake(0, 0, 280, 0) title:content buttonTitle:buttonTitle];
    
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
    .LeeShow()
    .LeeCornerRadius(15)
    .LeeClickBackgroundClose(YES);
}
+ (void)initDeviceFenceAlertView:(CAPDevice *)deviceInfo content:(NSString *)content closeBlock:(closeBlock)closeBlock{
    CAPFenceAlertView *view = [[CAPFenceAlertView alloc] init];
    [view fillData:deviceInfo content:content];
    // Nib形式请设置UIViewAutoresizingNone
    view.autoresizingMask = UIViewAutoresizingNone;
    [view setCloseBlock:^{
        [LEEAlert closeWithCompletionBlock:^{
            // 打开XXX
            closeBlock();
        }];
    }];
    [LEEAlert alert].config
    .LeeCustomView(view)
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderColor([UIColor clearColor])
    .LeeShow().LeeCornerRadius(15);
}
@end
