//
//  UITableView+CAP.h
//  GPSTracker
//
//  Created by WeifengYao on 10/3/2017.
//  Copyright © 2017 capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (CAP)
- (void)tableViewDisplayWithMessage:(NSString *)message dataSourceCount:(NSUInteger)count;
- (void)displayEmptyMessage:(NSString *)message dataSourceCount:(NSUInteger)count imageName:(NSString *)imageName;
- (void)setBackgroundImage:(NSString *)imageName;
@end
