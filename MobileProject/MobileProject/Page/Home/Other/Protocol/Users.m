//
//  Users.m
//  MobileProject
//
//  Created by capaipai@sina.com on 2018/11/22.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "Users.h"

@implementation Users
- (void)userShouldStudy:(id<StudyProtocol>)protocol indentifier:(NSString *)indentifier{
    if ([indentifier isEqualToString:@"student"]) {
        [protocol stuadens];
    }
    if ([indentifier isEqualToString:@"teacher"]) {
        [protocol teachers];
    }
}
@end
