//
//  CSActionSheet.h
//  ChinaScpet
//
//  Created by 曹帅 on 2018/5/22.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import <UIKit/UIKit.h>

//按钮顺序index依次从上往下
typedef  void(^CSActionSheetBlock)(int index);


//按钮显示顺序 title 其他按钮 销毁按钮 取消按钮
@interface CSActionSheet : UIView

+(void)showWithTitle:(NSString*)title  destructiveTitle:(NSString*)destructiveTitle  otherTitles:(NSArray*)otherTitles block:(CSActionSheetBlock)block;

@end
