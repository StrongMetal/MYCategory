//
//  NSMutableArray+MYSafe.m
//  SwizzleProject
//
//  Created by oh on 2017/4/25.
//  Copyright © 2017年 oh. All rights reserved.
//  这里使用MRC，为了修复[UIKeyboardLayoutStar release]: message sent to deallocated instance的Bug，该文件需要添加-fno-objc-arc

#import "NSMutableArray+MYSafe.h"
#import "NSObject+Swizzle.h"

@implementation NSMutableArray (MYSafe)
static NSString *KMArrayClass = @"__NSArrayM";

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool
        {
            [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMArrayClass)
                                                srcSel:@selector(addObject:)
                                           swizzledSel:@selector(my_safeAddObject:)];
            
            [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMArrayClass)
                                                srcSel:@selector(insertObject:atIndex:)
                                           swizzledSel:@selector(my_safeInsertObject:atIndex:)];
            
            [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMArrayClass)
                                                srcSel:@selector(removeObjectAtIndex:)
                                           swizzledSel:@selector(my_safeRemoveObjectAtIndex:)];
            
            [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMArrayClass)
                                                srcSel:@selector(replaceObjectAtIndex:withObject:)
                                           swizzledSel:@selector(my_safeReplaceObjectAtIndex:withObject:)];
            
            [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMArrayClass)
                                                srcSel:@selector(objectAtIndex:)
                                           swizzledSel:@selector(my_safeObjectAtIndex:)];
            
            if (iOS11)
            {
                [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMArrayClass)
                                                    srcSel:@selector(objectAtIndexedSubscript:)
                                               swizzledSel:@selector(my_safeObjectAtIndexedSubscript:)];
            }
        }
        
    });
}

- (void)my_safeAddObject:(id)anObject
{
    @autoreleasepool
    {
        if(!anObject)return;
        
        [self my_safeAddObject:anObject];
    }
    
}

- (void)my_safeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    @autoreleasepool
    {
        if(!anObject || index > self.count)return;
        [self my_safeInsertObject:anObject atIndex:index];
    }
}

- (void)my_safeRemoveObjectAtIndex:(NSUInteger)index
{
    @autoreleasepool
    {
        if(index >= self.count) return;
        [self my_safeRemoveObjectAtIndex:index];
    }
}

- (void)my_safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    @autoreleasepool
    {
        if(index >= self.count || !anObject) return;
        [self my_safeReplaceObjectAtIndex:index withObject:anObject];
    }
}

- (id)my_safeObjectAtIndex:(NSUInteger)index
{
    @autoreleasepool
    {
        if (index >= self.count) return nil;
        return [self my_safeObjectAtIndex:index];
    }
}

- (id)my_safeObjectAtIndexedSubscript:(NSUInteger)index
{
    @autoreleasepool
    {
        if (index >= self.count) return nil;
        return [self my_safeObjectAtIndexedSubscript:index];
    }
}


@end



