//
//  CAPModifyAvatar.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/23.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAPModifyAvatar : UIView
+ (instancetype)instance;
/**
 *  关闭Block
 */
@property (nonatomic , copy ) void (^closeBlock)(void);
/**
 *  拍照Block
 */
@property (nonatomic , copy ) void (^tabkingPhotoBlock)(void);
/**
 *  选择相册Block
 */
@property (nonatomic , copy ) void (^albumBlock)(void);
@end

NS_ASSUME_NONNULL_END
