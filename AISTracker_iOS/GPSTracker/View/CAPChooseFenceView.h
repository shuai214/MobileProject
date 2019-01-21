//
//  CAPChooseFenceView.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/21.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAPFence.h"
NS_ASSUME_NONNULL_BEGIN

@interface CAPChooseFenceView : UIView
- (void)setDatafenceInfo:(CAPFence *)fenceInfo;
@property (nonatomic, copy) void (^closeButtonBlock)(CAPChooseFenceView *view);
@property (nonatomic, copy) void (^editFenceNameBlock)(CAPChooseFenceView *view);
@property (nonatomic, copy) void (^editRangeBlock)(CAPChooseFenceView *view);
@end

NS_ASSUME_NONNULL_END
