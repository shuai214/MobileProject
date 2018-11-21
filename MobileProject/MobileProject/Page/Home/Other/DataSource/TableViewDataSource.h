//
//  TableViewDataSource.h
//  MobileProject
//
//  Created by capaipai@sina.com on 2018/11/21.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^TableViewCellConfigureBlock)(id cell, id item);
@interface TableViewDataSource : NSObject<UITableViewDataSource>
- (id)initWithItems:(NSArray *)aItems cellIdentifier:(NSString *)cellIdentifier cellConfigureBlock:(TableViewCellConfigureBlock)block;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
