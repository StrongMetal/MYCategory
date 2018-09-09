//
//  NSArray+MYSafe.m
//  SwizzleProject
//
//  Created by oh on 2017/4/25.
//  Copyright © 2017年 oh. All rights reserved.
//

#import "NSArray+MYSafe.h"
#import "NSObject+Swizzle.h"

@implementation NSArray (MYSafe)

//数组初始化类
static NSString *KInitArrayClass   = @"__NSPlaceholderArray";
//空元素数组类，空数组
static NSString *KEmptyArrayClass  = @"__NSArray0";
//单元素数组类，一个元素的数组
static NSString *KSingleArrayClass = @"__NSSingleObjectArrayI";
//多元素数组类，两个元素以上的数组
static NSString *KMultiArrayClass  = @"__NSArrayI";

#define KSelectorFromString(s1,s2) NSSelectorFromString([NSString stringWithFormat:@"%@%@",s1,s2])

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(KInitArrayClass)
                                            srcSel:@selector(initWithObjects:count:)
                                       swizzledSel:@selector(MY_safeInitWithObjects:count:)];
        
        [self MY_arrayMethodSwizzleWithRealClass:KEmptyArrayClass prefix:@"MY_emptyArray"];
        [self MY_arrayMethodSwizzleWithRealClass:KSingleArrayClass prefix:@"MY_singleArray"];
        [self MY_arrayMethodSwizzleWithRealClass:KMultiArrayClass prefix:@"MY_multiArray"];
        
    });

}

+ (void)MY_arrayMethodSwizzleWithRealClass:(NSString *)realClass prefix:(NSString *)prefix
{
    
    [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(realClass)
                                        srcSel:@selector(objectAtIndex:)
                                   swizzledSel:KSelectorFromString(prefix, @"ObjectAtIndex:")];
    
    [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(realClass)
                                        srcSel:@selector(arrayByAddingObject:)
                                   swizzledSel:KSelectorFromString(prefix, @"ArrayByAddingObject:")];
    
    if (iOS11) {
        [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(realClass)
                                            srcSel:@selector(objectAtIndexedSubscript:)
                                       swizzledSel:KSelectorFromString(prefix, @"ObjectAtIndexedSubscript:")];
    }
}

#pragma mark -- swizzled Methods
- (instancetype)MY_safeInitWithObjects:(id *)objects count:(NSUInteger)cnt
{
    for (NSUInteger i = 0; i < cnt; i++)
    {
        if (!objects[i]) objects[i] = @"";
    }
    return [self MY_safeInitWithObjects:objects count:cnt];
}

- (id)MY_emptyArrayObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) return nil;
    return [self MY_emptyArrayObjectAtIndex:index];
}

- (id)MY_singleArrayObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) return nil;
    return [self MY_singleArrayObjectAtIndex:index];
}

- (id)MY_multiArrayObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) return nil;
    // NSLog(@"%@",NSStringFromClass(self.class));      //__NSArrayI
    // NSLog(@"%@",NSStringFromClass(self.superclass)); //NSArray
    // __NSArrayI是NSArray的子类
    // MY_multiArrayObjectAtIndex:是NSArray的方法,self是__NSArrayI的实例，子类调用父类的方法，没问题
    return [self MY_multiArrayObjectAtIndex:index];
}

//解决array[index] 字面量语法超出界限的bug
- (id)MY_emptyArrayObjectAtIndexedSubscript:(NSUInteger)index
{
    if (index >= self.count) return nil;
    return [self MY_emptyArrayObjectAtIndexedSubscript:index];
}

- (id)MY_singleArrayObjectAtIndexedSubscript:(NSUInteger)index
{
    if (index >= self.count) return nil;
    return [self MY_singleArrayObjectAtIndexedSubscript:index];
}

- (id)MY_multiArrayObjectAtIndexedSubscript:(NSUInteger)index
{
    if (index >= self.count) return nil;
    return [self MY_multiArrayObjectAtIndexedSubscript:index];
}

- (NSArray*)MY_emptyArrayArrayByAddingObject:(id)anObject
{
    if(!anObject) return self;
    return [self MY_emptyArrayArrayByAddingObject:anObject];
}

- (NSArray*)MY_singleArrayArrayByAddingObject:(id)anObject
{
    if(!anObject) return self;
    return [self MY_singleArrayArrayByAddingObject:anObject];
}

- (NSArray*)MY_multiArrayArrayByAddingObject:(id)anObject
{
    if(!anObject) return self;
    return [self MY_multiArrayArrayByAddingObject:anObject];
}

@end


