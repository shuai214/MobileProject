//
//  CAPMessageListTableViewCell.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2018/12/27.
//  Copyright © 2018年 Capelabs. All rights reserved.
//

#import "CAPMessageListTableViewCell.h"
#define CAPNameFont [UIFont systemFontOfSize:15]
#define CAPTextFont [UIFont systemFontOfSize:16]
@interface CAPMessageListTableViewCell()
/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;
/**
 *  时间
 */
@property (nonatomic, weak) UILabel *timeLabel;
/**
 *  正文
 */
@property (nonatomic, weak) UILabel *introLabel;
@end

@implementation CAPMessageListTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"CAPMessageListTableViewCell";
    // 1.缓存中取
    CAPMessageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[CAPMessageListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 让自定义Cell和系统的cell一样, 一创建出来就拥有一些子控件提供给我们使用
        // 1.创建头像
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        // 2.创建时间lable
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = CAPNameFont;
        // nameLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;

        // 3.创建正文
        UILabel *introLabel = [[UILabel alloc] init];
        introLabel.font = CAPTextFont;
        introLabel.numberOfLines = 0;
        // introLabel.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:introLabel];
        self.introLabel = introLabel;
        
    }
    return self;
}

- (void)setDeviceMessage:(CAPDeviceMessage *)deviceMessage{
    _deviceMessage = deviceMessage;
    // 1.给子控件赋值数据
    [self settingData];
    // 2.设置frame
    [self settingFrame];
}
/**
 *  设置子控件的数据
 */
- (void)settingData
{
    DeviceMessageInfo *messageInfo = self.deviceMessage.messageInfo;
    
    // 设置头像
    self.iconView.image = GetImage(@"tracker_phone");
    // 设置时间
    self.timeLabel.text = messageInfo.deviceMessageTime;
   
    // 设置内容
    self.introLabel.text = messageInfo.deviceMessage;
}
/**
 *  设置子控件的frame
 */
- (void)settingFrame
{
    
    // 设置头像的frame
    self.iconView.frame = self.deviceMessage.iconF;
    
    // 设置昵称的frame
    self.timeLabel.frame = self.deviceMessage.timeF;
    
    // 设置正文的frame
    self.introLabel.frame = self.deviceMessage.introF;
    
}

/**
 *  计算文本的宽高
 *
 *  @param str     需要计算的文本
 *  @param font    文本显示的字体
 *  @param maxSize 文本显示的范围
 *
 *  @return 文本占用的真实宽高
 */
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    self.multipleSelectionBackgroundView = [UIView new];
}

-(void)layoutSubviews
{
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (self.selected) {
                        img.image=[UIImage imageNamed:@"check_on"];
                    }else
                    {
                        img.image=[UIImage imageNamed:@"check_off"];
                    }
                }
            }
        }
    }
    [super layoutSubviews];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (!self.selected) {
                        img.image=[UIImage imageNamed:@"check_on"];
                    }
                }
            }
        }
    }
}
@end
