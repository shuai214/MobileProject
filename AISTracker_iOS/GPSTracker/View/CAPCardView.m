//
//  CAPCardView.m
//  GPSTracker
//
//  Created by WeifengYao on 6/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPCardView.h"

@interface CAPCardView ()
@end

@implementation CAPCardView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setup {
    if(self.layer.cornerRadius < 1.0) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(5, 5);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 9.0;
        self.layer.cornerRadius = 9.0;
        self.clipsToBounds = NO;
        self.userInteractionEnabled = YES;
        
//        UIView *contentView = [[UIView alloc] initWithFrame:self.frame];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
//        [self addSubview:contentView];
    }
}

@end
