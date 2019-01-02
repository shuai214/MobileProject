//
//  CAPDeviceListView.m
//  GPSTracker
//
//  Created by WeifengYao on 6/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPDeviceListView.h"
#import "CAPDevice.h"
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"11--11");
}

- (void)setup {
    self.userInteractionEnabled = YES;
    if(!self.scrollView) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.pagingEnabled = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        scrollView.userInteractionEnabled = YES;
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
        CGFloat height = width;
        self.scrollView.contentSize = CGSizeMake(width * self.devices.count, height);
        for(int i=0; i<self.devices.count + 1; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width*i, 0, width, height)];
            button.layer.cornerRadius = width / 2;
            button.layer.masksToBounds = YES;
            button.tag = i;
            if (i != 0) {
                CAPDevice *device = self.devices[i - 1];
                [button sd_setImageWithURL:[NSURL URLWithString:device.setting.avatar.url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"tracker_phone"]];
            }else{
                [button setBackgroundImage:[UIImage imageNamed:@"tracker_phone"] forState:UIControlStateNormal];
            }
            [button addTarget:self action:@selector(onDeviceClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:button];
        }
    } else {
        self.scrollView.contentSize = CGSizeMake(0, 0);
    }
}


- (void)onDeviceClicked:(UIButton *)button {
    if(self.delegate) {
        [self.delegate didSelectDeviceAtIndex:button.tag];
    }
}

@end
