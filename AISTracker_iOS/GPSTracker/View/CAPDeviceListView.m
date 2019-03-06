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
@property (nonatomic,strong) UIButton *selectedBtn;


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
        CGFloat width = size.width/7;
        CGFloat height = width;
        self.scrollView.contentSize = CGSizeMake(width * self.devices.count, height);
        for(int i=0; i<self.devices.count; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width*i, 0, width, height)];
            //边框宽度
            [button.layer setBorderWidth:2.0];
            if (i == 0) {
                [button.layer setBorderColor:[CAPColors red].CGColor];//边框颜色
                button.selected = YES;
                button.tag = i + 99;
                self.selectedBtn = button;
            }else{
                button.tag = i + 99;
                [button.layer setBorderColor:[CAPColors gray1].CGColor];//边框颜色
            }
            button.layer.cornerRadius = width / 2;
            button.layer.masksToBounds = YES;
            
            CAPDevice *device = self.devices[i];
            [button sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",device.setting.avatarBaseUrl,device.setting.avatarPath]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ic_default_avatar_new"]];
            [button addTarget:self action:@selector(onDeviceClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:button];
            NSLog(@"1111111111---------%@",button);
        }
    } else {
        for(UIView *view in self.scrollView.subviews) {
            [view removeFromSuperview];
        }
        self.scrollView.contentSize = CGSizeMake(0, 0);
    }
}

- (void)reloadButton:(NSInteger)index{
    UIButton *button = [self.scrollView viewWithTag:index + 99];
    
    [self onDeviceClicked:button];
}

- (void)onDeviceClicked:(UIButton *)button {
    if(self.delegate) {
        [self.delegate didSelectDeviceAtIndex:button.tag - 99];
    }

    if (!button.isSelected) {
        self.selectedBtn.selected = !self.selectedBtn.selected;
        [self.selectedBtn.layer setBorderColor:[CAPColors gray1].CGColor];
        button.selected = !button.selected;
        [button.layer setBorderColor:[CAPColors red].CGColor];
        self.selectedBtn = button;
    }
 
}

@end
