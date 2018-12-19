//
//  CAPTableCell.m
//  Ruyi
//
//  Created by user on 8/16/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPTableCell.h"
#import "CAPStyles.h"

@implementation CAPTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self == [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self == [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [CAPStyles applyStyleForTableCell:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
