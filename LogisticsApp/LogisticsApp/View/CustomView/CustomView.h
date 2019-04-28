//
//  CAPTrackerView.h
//  GPSTracker
//
//  Created by WeifengYao on 6/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomView : UIView
@property (strong, nonatomic) IBOutlet CustomView *contentView;
- (void)fillContentView:(NSString *)imgName title:(NSString *)title content:(NSString *)content;
@end
