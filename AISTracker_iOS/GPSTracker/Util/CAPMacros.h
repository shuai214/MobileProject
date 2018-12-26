//
//  CAPMacros.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2018/12/21.
//  Copyright © 2018年 Capelabs. All rights reserved.
//

#ifndef CAPMacros_h
#define CAPMacros_h

//获取View的属性
#define GetViewWidth(view)  view.frame.size.width
#define GetViewHeight(view) view.frame.size.height
#define GetViewX(view)      view.frame.origin.x
#define GetViewY(view)      view.frame.origin.y

// MainScreen Height&Width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \ || [_object isKindOfClass:[NSNull class]] \ || ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \ || ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

//获取图片资源
#define GetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]


#endif /* CAPMacros_h */
