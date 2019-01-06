//
//  CAPWeekView.m
//  GPSTracker
//
//  Created by WeifengYao on 8/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPWeekView.h"

@interface CAPWeekView ()
@property (strong, nonatomic) IBOutlet CAPWeekView *contentView;

@end

@implementation CAPWeekView
- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"CAPTrackerView" owner:self options:nil];
    [self addSubview:self.contentView];
   
}

@end
