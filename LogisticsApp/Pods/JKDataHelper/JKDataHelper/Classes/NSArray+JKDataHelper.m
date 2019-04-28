//
//  NSArray+JKDataHelper.m
//  Pods
//
//  Created by Jack on 17/3/28.
//
//

#import "NSArray+JKDataHelper.h"
#import "JKDataHelperMacro.h"
#import "NSObject+JK.h"

@implementation NSArray (JKDataHelper)
#ifdef JKDataHelperDebug

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class targetClass = NSClassFromString(@"__NSArrayI");
        [self JKswizzleMethod:@selector(objectAtIndex:) withMethod:@selector(JKsafeObjectAtIndex:) withClass:targetClass];
        [self JKswizzleMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(JKsafeObjectAtIndexedSubscript:) withClass:targetClass];
         [self JKswizzleMethod:@selector(initWithObjects:count:) withMethod:@selector(JKsafeInitWithObjects:count:) withClass:NSClassFromString(@"__NSPlaceholderArray")];
    });
}

#endif

-(id)jk_objectWithIndex:(NSUInteger)index{
    if (index <self.count) {
        return self[index];
    }else{
        return nil;
    }
}

- (NSString*)jk_stringWithIndex:(NSUInteger)index
{
    id value = [self jk_objectWithIndex:index];
    if (value == nil || value == [NSNull null] || [[value description] isEqualToString:@"<null>"])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString*)value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    
    return nil;
}

- (NSNumber*)jk_numberWithIndex:(NSUInteger)index
{
    id value = [self jk_objectWithIndex:index];
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        return [f numberFromString:(NSString*)value];
    }
    return nil;
}

- (NSDecimalNumber *)jk_decimalNumberWithIndex:(NSUInteger)index{
    id value = [self jk_objectWithIndex:index];
    
    if ([value isKindOfClass:[NSDecimalNumber class]]) {
        return value;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber * number = (NSNumber*)value;
        return [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    } else if ([value isKindOfClass:[NSString class]]) {
        NSString * str = (NSString*)value;
        return [str isEqualToString:@""] ? nil : [NSDecimalNumber decimalNumberWithString:str];
    }
    return nil;
}

- (NSArray*)jk_arrayWithIndex:(NSUInteger)index
{
    id value = [self jk_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSArray class]])
    {
        return value;
    }
    return nil;
}


- (NSDictionary*)jk_dictionaryWithIndex:(NSUInteger)index
{
    id value = [self jk_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSDictionary class]])
    {
        return value;
    }
    return nil;
}

- (NSInteger)jk_integerWithIndex:(NSUInteger)index
{
    id value = [self jk_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value integerValue];
    }
    return 0;
}
- (NSUInteger)jk_unsignedIntegerWithIndex:(NSUInteger)index
{
    id value = [self jk_objectWithIndex:index];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value unsignedIntegerValue];
    }
    return 0;
}
- (BOOL)jk_boolWithIndex:(NSUInteger)index
{
    id value = [self jk_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return NO;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value boolValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value boolValue];
    }
    return NO;
}
- (int16_t)jk_int16WithIndex:(NSUInteger)index
{
    id value = [self jk_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    return 0;
}
- (int32_t)jk_int32WithIndex:(NSUInteger)index
{
    id value = [self jk_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    return 0;
}
- (int64_t)jk_int64WithIndex:(NSUInteger)index
{
    id value = [self jk_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value longLongValue];
    }
    return 0;
}

- (char)jk_charWithIndex:(NSUInteger)index{
    
    id value = [self jk_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value charValue];
    }
    return 0;
}

- (short)jk_shortWithIndex:(NSUInteger)index
{
    id value = [self jk_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    return 0;
}
- (float)jk_floatWithIndex:(NSUInteger)index
{
    id value = [self jk_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value floatValue];
    }
    return 0;
}

- (CGFloat)jk_cgFloatWithIndex:(NSUInteger)index{
    CGFloat value = (CGFloat)[self jk_floatWithIndex:index];
    return value;
}
- (double)jk_doubleWithIndex:(NSUInteger)index
{
    id value = [self jk_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value doubleValue];
    }
    return 0;
}

- (NSDate *)jk_dateWithIndex:(NSUInteger)index dateFormat:(NSString *)dateFormat {
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.dateFormat = dateFormat;
    id value = [self jk_objectWithIndex:index];
    
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    
    if ([value isKindOfClass:[NSString class]] && ![value isEqualToString:@""] && !dateFormat) {
        return [formater dateFromString:value];
    }
    return nil;
}

- (NSMutableArray *)jk_valueArrayWithKey:(NSString *)key{
    if (!key) {
        NSAssert(NO, @"key can not be nil");
    }
    NSMutableArray *values = [NSMutableArray new];
    for (NSDictionary *dic in self) {
        if (![dic isKindOfClass:[NSDictionary class]]) {
           NSAssert(NO, @"value must be an instance of NSDictionary");
        }
        id value =  [dic objectForKey:key];
        [values addObject:value];
    }
    return values;
}

- (NSMutableArray *)jk_ascSort{
    NSMutableArray *array = (NSMutableArray *)self;
    if (![self isKindOfClass:[NSMutableArray class]]) {
        array = [NSMutableArray arrayWithArray:self];
    }
    [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 integerValue] > [obj2 integerValue];
    }];
    return array;
}

- (NSMutableArray *)jk_descSort{
    NSMutableArray *array = (NSMutableArray *)self;
    if (![self isKindOfClass:[NSMutableArray class]]) {
        array = [NSMutableArray arrayWithArray:self];
    }
    [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 integerValue] < [obj2 integerValue];
    }];
    return array;
}



//CG
- (CGFloat)jk_CGFloatWithIndex:(NSUInteger)index
{
    id value = [self jk_objectWithIndex:index];
    
    CGFloat f = [value doubleValue];
    
    return f;
}

- (CGPoint)jk_pointWithIndex:(NSUInteger)index
{
    id value = [self jk_objectWithIndex:index];
    
    CGPoint point = CGPointFromString(value);
    
    return point;
}
- (CGSize)jk_sizeWithIndex:(NSUInteger)index
{
    id value = [self jk_objectWithIndex:index];
    
    CGSize size = CGSizeFromString(value);
    
    return size;
}
- (CGRect)jk_rectWithIndex:(NSUInteger)index
{
    id value = [self jk_objectWithIndex:index];
    
    CGRect rect = CGRectFromString(value);
    
    return rect;
}

#ifdef JKDataHelperDebug

- (id)JKsafeObjectAtIndex:(NSInteger)index{
    if (index >=0 && index < self.count) {
        return [self JKsafeObjectAtIndex:index];
    }else{
        JKDataHelperLog(@"[__NSArrayI objectAtIndex:] index is greater than the array.count or the index is less than zero");
        return nil;
    }
}

- (id)JKsafeObjectAtIndexedSubscript:(NSInteger)index{
    if (index >=0 && index < self.count) {
        return [self JKsafeObjectAtIndex:index];
    }else{
        JKDataHelperLog(@"[__NSArrayI objectAtIndexedSubscript:] index is greater than the array.count or the index is less than zero");
        return nil;
    }
}


- (instancetype)JKsafeInitWithObjects:(int **)objects count:(NSInteger)count{
    for (int i=0; i<count; i++) {
        if (!objects[i]) {
            JKDataHelperLog(@"%@", [NSString stringWithFormat:@"[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil to objects[%d]",i]);
            return nil;
        }
    }
    return [self JKsafeInitWithObjects:objects count:count];
}

#endif




@end
