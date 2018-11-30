//
//  NSObject+KVO.m
//  MobileProject
//
//  Created by capaipai@sina.com on 2018/11/30.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/runtime.h>
#import <objc/message.h>
NSString *const kCSKVOClassPrefix = @"CSKVOClassPrefix_";
NSString *const kCSKVOAssociatedObservers = @"CSKVOAssociatedObservers";

//

@interface CSObservationInfo : NSObject

@property(nonatomic,weak)NSObject *observer;
@property(nonatomic,copy)NSString *key;
@property(nonatomic,copy)CSObserverBlock block;

@end

@implementation CSObservationInfo

- (instancetype)initWithObserver:(NSString *)observer Key:(NSString *)key block:(CSObserverBlock)block{
    self = [super init];
    if (self) {
        _observer = observer;
        _key = key;
        _block = block;
    }
    return self;
}

@end

//通过该方法可以获取相应的set和get方法的方法名
static NSString *setSelectorForKey(NSString *key){
    if (key.length <= 0) {
        return nil;
    }
    //获取key的首字母,并大写
    NSString *firstLetter = [[key substringToIndex:1] uppercaseString];
    //获取key第一个字母后的字符串
    NSString *remainingLetters = [key substringFromIndex:1];
    //拼接key所对应的set方法名
    NSString *setter = [NSString stringWithFormat:@"set%@%@:",firstLetter,remainingLetters];
    return setter;
}

/**
 根据setter方法返回get方法名

 @param setter setter方法名
 @return 返回一个get方法名
 */
static NSString *getSelectorForSetter(NSString *setter){
    //
    if (setter.length <=0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) {
        return nil;
    }
    // remove 'set' at the begining and ':' at the end
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *key = [setter substringWithRange:range];
    // 第一个字母小写
    NSString *firstLetter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                       withString:firstLetter];
    
    return key;
}

//3.重写 setter 方法。新的 setter 在调用原 setter 方法后，通知每个观察者（调用之前传入的 block ）：
/**
 覆盖原有的方法

 @param self 父类
 @param _cmd 方法名
 @param newValue 新的值
 */
static void kvo_setter(id self, SEL _cmd, id newValue){
    //获取setter方法名
    NSString *setterName = NSStringFromSelector(_cmd);
    //获取get方法名
    NSString *getterName = getSelectorForSetter(setterName);
    if (!getterName) {
        // throw invalid argument exception
        return;
    }
    
    id oldValue = [self valueForKey:getterName];
    //objc_getClass参数是类名的字符串，返回的就是这个类的类对象；object_getClass参数是id类型，它返回的是这个id的isa指针所指向的Class，如果传参是Class，则返回该Class的metaClass。
    struct objc_super superclass = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    //转换指针
    void (* objc_msgSendSuperCasted)(void *,SEL ,id) = (void *)objc_msgSendSuper;
    objc_msgSendSuperCasted(&superclass,_cmd,newValue);
    //查找观察者并调用块
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kCSKVOAssociatedObservers));
    for (CSObservationInfo *info in observers) {
        if ([info.key isEqualToString:getterName]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                info.block(self, getterName, oldValue, newValue);
            });
        }
    }
}


static Class kvo_class(id self , SEL _cmd){
    return class_getSuperclass(object_getClass(self));
}



@implementation NSObject (KVO)
- (void)CS_addObserver:(NSObject *)observer forKey:(NSString *)key block:(CSObserverBlock)block{
    //1.检查对象的类有没有相应的 setter 方法。如果没有抛出异常
    SEL setterSelector = NSSelectorFromString(setSelectorForKey(key));
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    if (!setterMethod) {
        NSString *errorMessage = [NSString stringWithFormat:@"Object %@ does not have a setter for key %@", self, key];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:errorMessage
                                     userInfo:nil];
        return;
    }
    
    //2.检查对象 isa 指向的类是不是一个 KVO 类。如果不是，新建一个继承原来类的子类，并把 isa 指向这个新建的子类；
    //获取该self的class对象 (isa的指向)
    Class class = object_getClass(self);
    NSString *className = NSStringFromClass(class);
    //判断className是否有前缀
    //如果没有则创建一个带有该前缀的class对象
    if (![className hasPrefix:kCSKVOClassPrefix]) {
        class = [self makeKvoClassWithPrefixClassName:className];
        object_setClass(self, class);
    }
    
    //3.如果这个类(不是超类)没有实现setter，添加我们的kvo setter?
    if (![self has_selector:setterSelector]) {
        const char *types = method_getTypeEncoding(setterMethod);
        class_addMethod(class, setterSelector, (IMP)kvo_setter, types);
    }
    //4.添加这个观察者
    CSObservationInfo *info = [[CSObservationInfo alloc] initWithObserver:(NSString *)observer Key:key block:block];
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kCSKVOAssociatedObservers));
    if (!observers) {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kCSKVOAssociatedObservers), observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [observers addObject:info];

    
}

- (void)CS_removeObserver:(NSObject *)observer forKey:(NSString *)key{
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(kCSKVOAssociatedObservers));
    CSObservationInfo *infoToRemove;
    for (CSObservationInfo* info in observers) {
        if (info.observer == observer && [info.key isEqual:key]) {
            infoToRemove = info;
            break;
        }
    }
    [observers removeObject:infoToRemove];
}


- (Class)makeKvoClassWithPrefixClassName:(NSString *)className{
//    NSString *prefixClassName = [NSString stringWithFormat:@"%@%@",kCSKVOClassPrefix,className];
    //给类名加一个前缀.并重新创建带有前缀的class对象
    NSString *prefixClassName = [kCSKVOClassPrefix stringByAppendingString:className];
    Class clazz = NSClassFromString(prefixClassName);
    if (clazz) {
        return clazz;
    }
    //如果类还不存在，就去创建它
    
    //获取当前类对象(原始类)
    Class originalClass = object_getClass(self);
    //通过原始类创建带有前缀的类
    
    /**
    动态创建新的类需要用 objc/runtime.h 中定义的 objc_allocateClassPair() 函数。传一个父类，类名，然后额外的空间（通常为 0），它返回给你一个类
     param originalClass 父类
     param prefixClassName.UTF8String 类名
     param 0 额外的空间（通常为 0
     return 返回给你一个类
     */
    Class kvoClass = objc_allocateClassPair(originalClass, prefixClassName.UTF8String, 0);
    //获取类方法的签名，以便我们可以借用它
    //然后就给这个类添加方法，也可以添加变量。
    Method originalClassMethod = class_getInstanceMethod(originalClass, @selector(class));
    const char *types = method_getTypeEncoding(originalClassMethod);
    //imp：指向实现方法的指针   就是要添加的方法的实现部分
    class_addMethod(kvoClass, @selector(class), (IMP)kvo_class , types);
    objc_registerClassPair(kvoClass);
    return kvoClass;
}

//判断是否实现了key的set方法
- (BOOL)has_selector:(SEL)selector{
    Class class = object_getClass(self);
    //获取self下的所有方法
    unsigned int count = 1;
    Method *methods = class_copyMethodList(class, &count);
    for (unsigned int i = 0; i < count; i++) {
        SEL thisSelector = method_getName(methods[i]);
        if (thisSelector == selector) {
            free(methods);
            return YES;
        }
    }
    free(methods);
    return NO;
}

@end
