//
//  CAPDeviceListView.h
//  GPSTracker
//
//  Created by WeifengYao on 6/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAPDevice.h"

@protocol CAPDeviceListViewDelegate
- (void)didSelectDeviceAtIndex:(NSUInteger)index;
@end

@interface CAPDeviceListView : UIView
@property (nonatomic, strong) NSArray *devices;
@property (nonatomic, weak) id<CAPDeviceListViewDelegate> delegate;
@end
