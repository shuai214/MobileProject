//
//  CSKVOCustomViewController.m
//  MobileProject
//
//  Created by capaipai@sina.com on 2018/11/30.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "CSKVOCustomViewController.h"
#import "UIView+BlockGesture.h"
#import "NSObject+KVO.h"

@interface Message : NSObject
@property (nonatomic, copy) NSString *text;
@end

@implementation Message

@end

@interface CSKVOCustomViewController ()
@property (nonatomic, strong) Message *message;
@end

@implementation CSKVOCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake((Main_Screen_Width - 100 ) / 2, 90, 100, 30)];
    label.font = CHINESE_SYSTEM(14);
    label.backgroundColor = [UIColor RandomColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    self.message = [[Message alloc] init];
    [self.message CS_addObserver:self forKey:NSStringFromSelector(@selector(text)) block:^(id observerObject, NSString *obertverKey, id oldValue, id newValue) {
        NSLog(@"%@.%@ is now: %@", observerObject, obertverKey, newValue);
        dispatch_async(dispatch_get_main_queue(), ^{
            label.text = newValue;
        });
    }];
    
    UIButton *BUTTON = [[UIButton alloc] initWithFrame:CGRectMake((Main_Screen_Width - 100 ) / 2, 150, 100, 30)];
    [BUTTON setBackgroundColor:[UIColor RandomColor]];
    [BUTTON addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        NSArray *msgs = @[@"Hello World!", @"Objective C", @"Swift", @"Peng Gu", @"peng.gu@me.com", @"www.gupeng.me", @"glowing.com"];
        NSUInteger index = arc4random_uniform((u_int32_t)msgs.count);
        self.message.text = msgs[index];
        NSLog(@"%@",self.message.text);
    }];
    [self.view addSubview:BUTTON];
    
    
    
    
    
    
}



@end
