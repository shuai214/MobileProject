//
//  CAPDeviceMessage.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/15.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPDeviceMessage.h"
#define CAPNameFont [UIFont systemFontOfSize:15]
#define CAPTextFont [UIFont systemFontOfSize:16]
@implementation CAPDeviceMessage
- (void)setMessageInfo:(DeviceMessageInfo *)deviceMessageInfo
{
    _messageInfo = deviceMessageInfo;
    // 间隙
    CGFloat padding = 10;
    
    // 设置头像的frame
    CGFloat iconViewX = padding;
    CGFloat iconViewY = padding;
    CGFloat iconViewW = 30;
    CGFloat iconViewH = 30;
    self.iconF = CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH);
    // 时间的frame
    // 时间的x = 头像最大的x + 间隙
    CGFloat timeLabelX = CGRectGetMaxX(self.iconF) + padding;
    // 计算文字的宽高
    CGSize timeSize = [self sizeWithString:_messageInfo.deviceMessage font:CAPNameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat timeLabelH = timeSize.height;
    CGFloat timeLabelW = timeSize.width;
    CGFloat timeLabelY = iconViewY + (iconViewH - timeLabelH) * 0.5;
    self.timeF = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    // 设置正文的frame
    CGFloat introLabelX = iconViewX;
    CGFloat introLabelY = CGRectGetMaxY(self.iconF) + padding;
    CGSize textSize =  [self sizeWithString:_messageInfo.deviceMessage font:CAPTextFont maxSize:CGSizeMake(300, MAXFLOAT)];
    CGFloat introLabelW = textSize.width;
    CGFloat introLabelH = textSize.height;
    self.introF = CGRectMake(introLabelX, introLabelY, introLabelW, introLabelH);
     self.cellHeight = CGRectGetMaxY(self.introF) + padding;
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
@end
