//
//  CAPTrackerView.m
//  GPSTracker
//
//  Created by WeifengYao on 6/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CustomView.h"
@interface CustomView ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation CustomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView = [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:self options:nil].lastObject;
        self.contentView.wtj_width = self.wtj_width;
        self.contentView.wtj_height = self.wtj_height;
        [self addSubview:self.contentView];
        self.userInteractionEnabled = YES;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        //给图层添加一个有色边框
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:199.0/255.0 alpha:1] CGColor];
      
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.userInteractionEnabled = YES;
    
}

- (void)fillContentView:(NSString *)imgName title:(NSString *)title content:(NSString *)content{
    [self.imgView setImage:GetImage(imgName)];
    self.titlelabel.text = title;
    self.contentLabel.text = content;
}

@end
