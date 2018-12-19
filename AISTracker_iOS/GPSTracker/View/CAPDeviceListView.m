//
//  CAPDeviceListView.m
//  GPSTracker
//
//  Created by WeifengYao on 6/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPDeviceListView.h"

@interface CAPDeviceListView ()
@property (nonatomic, weak) UIScrollView *scrollView;
@end

@implementation CAPDeviceListView

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
    if(!self.scrollView) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.pagingEnabled = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.scrollView.frame = self.bounds;
}

- (void)setDevices:(NSArray *)devices {
    _devices = devices;
    [self refreshData];
}

- (void)refreshData {
    if(self.devices && self.devices.count > 0) {
        for(UIView *view in self.scrollView.subviews) {
            [view removeFromSuperview];
        }
        CGSize size = self.frame.size;
        CGFloat width = size.width/6;
        CGFloat height = size.height;
        self.scrollView.contentSize = CGSizeMake(width * self.devices.count, height);
        for(int i=0; i<self.devices.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width*i, 0, width, height)];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [imageView setImage:[UIImage imageNamed:@"tracker_phone"]];
            [self.scrollView addSubview:imageView];
            
            UIGestureRecognizer *singleTap = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(onDeviceClicked:)];
            [imageView addGestureRecognizer:singleTap];
        }
    } else {
        self.scrollView.contentSize = CGSizeMake(0, 0);
    }
}

- (void)onDeviceClicked:(UIGestureRecognizer *)gestureRecognizer {
    if(self.delegate) {
        UIView *view = [gestureRecognizer view];
        [self.delegate didSelectDeviceAtIndex:view.tag];
    }
}

@end
