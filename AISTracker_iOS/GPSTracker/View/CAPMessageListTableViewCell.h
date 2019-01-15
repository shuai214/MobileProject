//
//  CAPMessageListTableViewCell.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2018/12/27.
//  Copyright © 2018年 Capelabs. All rights reserved.
//

#import "CAPTableCell.h"
#import "CAPDeviceMessage.h"
NS_ASSUME_NONNULL_BEGIN

@interface CAPMessageListTableViewCell : CAPTableCell

@property (nonatomic, strong) CAPDeviceMessage *deviceMessage;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
