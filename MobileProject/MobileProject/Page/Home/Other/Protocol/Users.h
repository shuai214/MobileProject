//
//  Users.h
//  MobileProject
//
//  Created by capaipai@sina.com on 2018/11/22.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudyProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface Users : NSObject

- (void)userShouldStudy:(id<StudyProtocol>)protocol indentifier:(NSString *)indentifier;
@end

NS_ASSUME_NONNULL_END
//D7881182-AD00-4C36-A94D-F45FC9B0CF85
