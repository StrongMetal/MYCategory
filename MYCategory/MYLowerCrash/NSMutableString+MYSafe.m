//
//  NSMutableString+MYSafe.m
//  SwizzleProject
//
//  Created by oh on 2017/4/26.
//  Copyright © 2017年 oh. All rights reserved.
//

#import "NSMutableString+MYSafe.h"
#import "NSObject+Swizzle.h"

@implementation NSMutableString (MYSafe)
static NSString *KMStringClass = @"__NSCFConstantString";

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMStringClass)
                                            srcSel:@selector(replaceCharactersInRange:withString:)
                                       swizzledSel:@selector(my_safeReplaceCharactersInRange:withString:)];
        
        [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMStringClass)
                                            srcSel:@selector(insertString:atIndex:)
                                       swizzledSel:@selector(my_safeInsertString:atIndex:)];

        [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMStringClass)
                                            srcSel:@selector(deleteCharactersInRange:)
                                       swizzledSel:@selector(my_safeDeleteCharactersInRange:)];

        [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMStringClass)
                                            srcSel:@selector(appendString:)
                                       swizzledSel:@selector(my_safeAppendString:)];
        
        [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMStringClass)
                                            srcSel:@selector(setString:)
                                       swizzledSel:@selector(my_safeSetString:)];
    });
}

- (void)my_safeReplaceCharactersInRange:(NSRange)range withString:(NSString *)aString
{
    if(range.location + range.length > self.length || !aString) return;
    [self my_safeReplaceCharactersInRange:range withString:aString];
}

- (void)my_safeInsertString:(NSString *)aString atIndex:(NSUInteger)loc
{
    if (!aString || loc > self.length) return;
    [self my_safeInsertString:aString atIndex:loc];
}

- (void)my_safeDeleteCharactersInRange:(NSRange)range
{
    if(range.location + range.length > self.length) return;
    [self my_safeDeleteCharactersInRange:range];
}

- (void)my_safeAppendString:(NSString *)aString
{
    if(!aString) return;
    [self my_safeAppendString:aString];
}

- (void)my_safeSetString:(NSString *)aString
{
    if(!aString) return;
    [self my_safeSetString:aString];
}

@end
