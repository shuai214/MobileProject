//
//  UITableView+CAP.m
//  GPSTracker
//
//  Created by WeifengYao on 10/3/2017.
//  Copyright © 2017 capelabs. All rights reserved.
//

#import "UITableView+CAP.h"
#import "CAPCloudItemButton.h"

@implementation UITableView (CAP)
- (void)tableViewDisplayWithMessage:(NSString *)message dataSourceCount:(NSUInteger)count {
    if (count == 0) {
        self.backgroundView = [self createBackgroundView:message withImageName:@"empty_list"];
    } else {
        self.backgroundView = nil;
    }
}

- (void)displayEmptyMessage:(NSString *)message dataSourceCount:(NSUInteger)count imageName:(NSString *)imageName {
    if (count == 0) {
        self.backgroundView = [self createBackgroundView:message withImageName:imageName];
    } else {
        self.backgroundView = nil;
    }
}

- (UIView *)createBackgroundView:(NSString *)message withImageName:(NSString *)imageName {
    CAPCloudItemButton *button = [CAPCloudItemButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:message forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [button setup:-48 labelTop:8];
    button.titleLabel.font = [UIFont systemFontOfSize:18.0];
    button.userInteractionEnabled = NO;
    button.accessibilityIdentifier = @"empty_background_button";
    return button;
}

- (void)setBackgroundImage:(NSString *)imageName {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundImageView.image = [UIImage imageNamed:imageName];
    self.backgroundView = backgroundImageView;
}
@end
