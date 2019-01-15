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
@implementation CAPAlertView

- (void)initAlertWithContent:(NSString *)content closeBlock:(closeBlock)closeBlock okBlock:(okBlock)okBlock{
    CAPAlertCustomView *customView = [[CAPAlertCustomView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width / 4 * 3, 0) contentDesc:content];
    
    [LEEAlert alert].config
    .LeeCustomView(customView)
    .LeeHeaderInsets(UIEdgeInsetsMake(0, 0, 0, 0))
    .LeeHeaderColor([UIColor clearColor])
    .LeeShow();
    
    closeBlock = customView.closeBlock;
    okBlock = customView.okBlock;
}

@end
