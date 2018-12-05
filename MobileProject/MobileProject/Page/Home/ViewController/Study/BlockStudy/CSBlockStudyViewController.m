//
//  CSBlockStudyViewController.m
//  MobileProject
//
//  Created by capaipai@sina.com on 2018/12/5.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "CSBlockStudyViewController.h"
typedef void(^CSBlock) (CSBlockStudyViewController *);
@interface CSBlockStudyViewController ()
@property(nonatomic,copy)CSBlock csBlock;
@property(nonatomic,copy)NSString *name;
@end

@implementation CSBlockStudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //block (定义)  从栈区copy到堆区.
#pragma mark =============block 初探==============
//    int a = 10; // 捕获外部变量
//
//    void (^block)(void) = ^{
//        //当block在捕获b外部变量的时候就是一个堆block
//        NSLog(@"hello block   %d",a);// 捕获外部变量 a  这是的block NSMallocBlock (堆block)
//    };//匿名函数    声明[block copy] -->保存到堆区.
//    block();//block的调用
//
//    //为什么可以用%@ 打印出block 因为block也是一个对象!  RAC -- > 万物皆是signal(信号)
//    NSLog(@"%@",block);
    
//    ------------------------------------------------------------------
//    |             1.  全局block  NSGlobalBlock : 在静态区域             |
//    |                                                                |
//    |     block   2.  堆block    NSMallocBlock : 在堆区域              |
//    |                                                                |
//    |             3.  栈block    NSStackBlock  : 在栈区                |
//    |                                                                |
//    -------------------------------------------------------------------
    //blok 分类
    
    //1.全局block  NSGlobalBlock : 在静态区域
    
    //2.堆block    NSMallocBlock : 在堆区域
    
    //3.栈block    NSStackBlock  : 在栈区
//    NSLog(@"栈block -- %@",^{
//        NSLog(@"%d",a);
//    });
    
    
    
#pragma mark =================block循环引用=====================
    
    //    ------------------------------------------------------------------
    //    |     A dealloc 给B放信号
    //    |        |
    //    |        |  持有B   |-> B returnCount 0 + 1;//引用计数+1;
    //    |        A ---\-->B
    //    |
    //    |                     B接到release信号 if returnCount = 0 就会调用dealloc方法
    //    |           A持有B   |-> B returnCount 0 + 1;//引用计数+1;
    //    |        A ------>  B
    //               <------
    //               B持有A    此时B还持有A A无法滴啊用dealloc给B放信号  则B接不到release信号
    //                                                             就不会调用dealloc方法
    //    -------------------------------------------------------------------
    
    
    self.name = @"study block";
    //第一种解决循环引用的方式: weak strong
//    __weak typeof(self) weakSelf = self; //对当前对象进行弱引用
//    self.csBlock = ^(CSBlockStudyViewController *vc) {
////        NSLog(@"%@",self.name);//引起循环引用.........
////         NSLog(@"%@",weakSelf.name); //解决循环引用......
//        //此时不知道self是否 释放.那么就进行对象生命周期的延长...  strong
//        __strong typeof(self) self = weakSelf;
//        NSLog(@"%@",self.name); //这种方式解决循环引用比较安全....
//    };
#pragma mark ---第二种方法采用临时对象的方式解决循环引用
    //第二种解决循环引用方式 arc : __block
//    //__block 本身无法避免循环引用的问题，但是我们可以通过在 block 内部手动把 blockObj 赋值为 nil 的方式来避免循环引用的问题。另外一点就是 __block 修饰的变量在 block 内外都是唯一的，要注意这个特性可能带来的隐患。
////    但是__block有一点：这只是限制在ARC(自动引用计数)环境下。在非arc下，__block是可以避免引用循环的
//
//    //__block会捕捉到当前对象 由栈内存空间copy到堆内存空间中.在堆内存空间当前的block就会捕捉到对象的属性.
//
//    __block CSBlockStudyViewController *csWeakVC = self; // 一 .重新copy一份csWeakVC 有了当前self对象的所有东西 csWeakVC则是临时对象
//    self.csBlock = ^(CSBlockStudyViewController *vc) {
////         NSLog(@"%@",csWeakVC.name);//此时不能解决循环引用........
//        //二 .临时对象被block所持有
//        NSLog(@"%@",csWeakVC.name); // csWeakVC只是临时拥有..
//        csWeakVC = nil;//对该临时对象进行释放 --此时就不存在循环引用
//    };
//    // csWeakVC ---> 持有 self --- > 持有 block --- > csWeakVC = nil; 当block再次被调用时csWeakVC 已经是nil 就不存在循环引用...
//    self.csBlock(self);
    
    
    //第三种解决循环引用的方式 --- 为什么会产生循环引用.
    //self -- > block -- >self
//    self.csBlock = ^(CSBlockStudyViewController *csVC) {
////        此时的csvc 就是临时对象
//        NSLog(@"%@",csVC.name);
//    };
//    self.csBlock(self);
    
    
    
    
    
#pragma mark __block 修改的变量在block内部进行修改
    __block int a = 10; // 捕获外部变量 -- 内存在栈中.
    NSLog(@"前1 ==== %p",&a);

    //使用__block修饰 内存空间进行copy 由栈 → 到堆
    void (^block)(void) = ^{
        //当block在捕获b外部变量的时候就是一个堆block
        a++;
        NSLog(@"中 ==== %p",&a);//前后内存地址发生了改变
        NSLog(@"hello block   %d",a);// 捕获外部变量 a  这是的block NSMallocBlock (堆block)
    };//匿名函数    声明[block copy] -->保存到堆区.
    a++;
    NSLog(@"前2 ==== %p",&a);
    block();//block的调用
    NSLog(@"后 ==== %p",&a);//前后内存地址发生了改变

    
}

- (void)dealloc{
    NSLog(@"dealloc 来了");
}

@end
