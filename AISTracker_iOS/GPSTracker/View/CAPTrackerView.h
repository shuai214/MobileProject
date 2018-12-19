//
//  CAPTrackerView.h
//  GPSTracker
//
//  Created by WeifengYao on 6/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CAPTrackerViewAction) {
    CAPTrackerViewActionFence= 0,
    CCAPTrackerViewActionFootprint,
    CAPTrackerViewActionPhotograph,
    CAPTrackerViewActionNavigation,
    CAPTrackerViewActionSetting
};

@protocol CAPTrackerViewDelegate
-(void)onTrackerViewActionPerformed:(CAPTrackerViewAction)action;
@end

@interface CAPTrackerView : UIView
@property (strong, nonatomic) IBOutlet CAPTrackerView *contentView;
@property (nonatomic, weak) id<CAPTrackerViewDelegate> delegate;
@end
