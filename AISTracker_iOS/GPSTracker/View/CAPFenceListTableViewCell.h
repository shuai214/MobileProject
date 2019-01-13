//
//  CAPFenceListTableViewCell.h
//  GPSTracker
//
//  Created by 曹帅 on 2019/1/3.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAPFenceList.h"
NS_ASSUME_NONNULL_BEGIN

@interface CAPFenceListTableViewCell : UITableViewCell
- (void)setListData:(List *)list;
@property (nonatomic, copy) void (^switchIsBlock)(BOOL isOn,CAPFenceListTableViewCell *cell);

@end

NS_ASSUME_NONNULL_END
