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
        
        [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(KInitArrayClass)
                                            srcSel:@selector(initWithObjects:count:)
                                       swizzledSel:@selector(my_safeInitWithObjects:count:)];
        
        [self my_arrayMethodSwizzleWithRealClass:KEmptyArrayClass prefix:@"my_emptyArray"];
        [self my_arrayMethodSwizzleWithRealClass:KSingleArrayClass prefix:@"my_singleArray"];
        [self my_arrayMethodSwizzleWithRealClass:KMultiArrayClass prefix:@"my_multiArray"];
        
    });

}

+ (void)my_arrayMethodSwizzleWithRealClass:(NSString *)realClass prefix:(NSString *)prefix
{
    
    [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(realClass)
                                        srcSel:@selector(objectAtIndex:)
                                   swizzledSel:KSelectorFromString(prefix, @"ObjectAtIndex:")];
    
    [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(realClass)
                                        srcSel:@selector(arrayByAddingObject:)
                                   swizzledSel:KSelectorFromString(prefix, @"ArrayByAddingObject:")];
    
    if (iOS11) {
        [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(realClass)
                                            srcSel:@selector(objectAtIndexedSubscript:)
                                       swizzledSel:KSelectorFromString(prefix, @"ObjectAtIndexedSubscript:")];
    }
}

#pragma mark -- swizzled Methods
- (instancetype)my_safeInitWithObjects:(id *)objects count:(NSUInteger)cnt
{
    for (NSUInteger i = 0; i < cnt; i++)
    {
        if (!objects[i]) objects[i] = @"";
    }
    return [self my_safeInitWithObjects:objects count:cnt];
}

- (id)my_emptyArrayObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) return nil;
    return [self my_emptyArrayObjectAtIndex:index];
}

- (id)my_singleArrayObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) return nil;
    return [self my_singleArrayObjectAtIndex:index];
}

- (id)my_multiArrayObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) return nil;
    // NSLog(@"%@",NSStringFromClass(self.class));      //__NSArrayI
    // NSLog(@"%@",NSStringFromClass(self.superclass)); //NSArray
    // __NSArrayI是NSArray的子类
    // my_multiArrayObjectAtIndex:是NSArray的方法,self是__NSArrayI的实例，子类调用父类的方法，没问题
    return [self my_multiArrayObjectAtIndex:index];
}

//解决array[index] 字面量语法超出界限的bug
- (id)my_emptyArrayObjectAtIndexedSubscript:(NSUInteger)index
{
    if (index >= self.count) return nil;
    return [self my_emptyArrayObjectAtIndexedSubscript:index];
}

- (id)my_singleArrayObjectAtIndexedSubscript:(NSUInteger)index
{
    if (index >= self.count) return nil;
    return [self my_singleArrayObjectAtIndexedSubscript:index];
}

- (id)my_multiArrayObjectAtIndexedSubscript:(NSUInteger)index
{
    if (index >= self.count) return nil;
    return [self my_multiArrayObjectAtIndexedSubscript:index];
}

- (NSArray*)my_emptyArrayArrayByAddingObject:(id)anObject
{
    if(!anObject) return self;
    return [self my_emptyArrayArrayByAddingObject:anObject];
}

- (NSArray*)my_singleArrayArrayByAddingObject:(id)anObject
{
    if(!anObject) return self;
    return [self my_singleArrayArrayByAddingObject:anObject];
}

- (NSArray*)my_multiArrayArrayByAddingObject:(id)anObject
{
    if(!anObject) return self;
    return [self my_multiArrayArrayByAddingObject:anObject];
}

@end


