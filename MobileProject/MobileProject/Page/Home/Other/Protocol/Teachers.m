//
//  Teachers.m
//  MobileProject
//
//  Created by capaipai@sina.com on 2018/11/22.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "Teachers.h"

@implementation Teachers
- (void)stuadens{
    NSLog(@"I am a student,I should study well ,%@",NSStringFromClass([self class]));
}
- (void)teachers{
    NSLog(@"I am a teacher,I should teach well ,%@",NSStringFromClass([self class]));
}
@end
