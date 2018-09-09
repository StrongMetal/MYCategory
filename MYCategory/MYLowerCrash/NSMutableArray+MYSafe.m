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
            [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMArrayClass)
                                                srcSel:@selector(addObject:)
                                           swizzledSel:@selector(MY_safeAddObject:)];
            
            [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMArrayClass)
                                                srcSel:@selector(insertObject:atIndex:)
                                           swizzledSel:@selector(MY_safeInsertObject:atIndex:)];
            
            [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMArrayClass)
                                                srcSel:@selector(removeObjectAtIndex:)
                                           swizzledSel:@selector(MY_safeRemoveObjectAtIndex:)];
            
            [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMArrayClass)
                                                srcSel:@selector(replaceObjectAtIndex:withObject:)
                                           swizzledSel:@selector(MY_safeReplaceObjectAtIndex:withObject:)];
            
            [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMArrayClass)
                                                srcSel:@selector(objectAtIndex:)
                                           swizzledSel:@selector(MY_safeObjectAtIndex:)];
            
            if (iOS11)
            {
                [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMArrayClass)
                                                    srcSel:@selector(objectAtIndexedSubscript:)
                                               swizzledSel:@selector(MY_safeObjectAtIndexedSubscript:)];
            }
        }
        
    });
}

- (void)MY_safeAddObject:(id)anObject
{
    @autoreleasepool
    {
        if(!anObject)return;
        
        [self MY_safeAddObject:anObject];
    }
    
}

- (void)MY_safeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    @autoreleasepool
    {
        if(!anObject || index > self.count)return;
        [self MY_safeInsertObject:anObject atIndex:index];
    }
}

- (void)MY_safeRemoveObjectAtIndex:(NSUInteger)index
{
    @autoreleasepool
    {
        if(index >= self.count) return;
        [self MY_safeRemoveObjectAtIndex:index];
    }
}

- (void)MY_safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    @autoreleasepool
    {
        if(index >= self.count || !anObject) return;
        [self MY_safeReplaceObjectAtIndex:index withObject:anObject];
    }
}

- (id)MY_safeObjectAtIndex:(NSUInteger)index
{
    @autoreleasepool
    {
        if (index >= self.count) return nil;
        return [self MY_safeObjectAtIndex:index];
    }
}

- (id)MY_safeObjectAtIndexedSubscript:(NSUInteger)index
{
    @autoreleasepool
    {
        if (index >= self.count) return nil;
        return [self MY_safeObjectAtIndexedSubscript:index];
    }
}


@end



