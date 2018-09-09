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
        [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMStringClass)
                                            srcSel:@selector(replaceCharactersInRange:withString:)
                                       swizzledSel:@selector(MY_safeReplaceCharactersInRange:withString:)];
        
        [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMStringClass)
                                            srcSel:@selector(insertString:atIndex:)
                                       swizzledSel:@selector(MY_safeInsertString:atIndex:)];

        [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMStringClass)
                                            srcSel:@selector(deleteCharactersInRange:)
                                       swizzledSel:@selector(MY_safeDeleteCharactersInRange:)];

        [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMStringClass)
                                            srcSel:@selector(appendString:)
                                       swizzledSel:@selector(MY_safeAppendString:)];
        
        [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMStringClass)
                                            srcSel:@selector(setString:)
                                       swizzledSel:@selector(MY_safeSetString:)];
    });
}

- (void)MY_safeReplaceCharactersInRange:(NSRange)range withString:(NSString *)aString
{
    if(range.location + range.length > self.length || !aString) return;
    [self MY_safeReplaceCharactersInRange:range withString:aString];
}

- (void)MY_safeInsertString:(NSString *)aString atIndex:(NSUInteger)loc
{
    if (!aString || loc > self.length) return;
    [self MY_safeInsertString:aString atIndex:loc];
}

- (void)MY_safeDeleteCharactersInRange:(NSRange)range
{
    if(range.location + range.length > self.length) return;
    [self MY_safeDeleteCharactersInRange:range];
}

- (void)MY_safeAppendString:(NSString *)aString
{
    if(!aString) return;
    [self MY_safeAppendString:aString];
}

- (void)MY_safeSetString:(NSString *)aString
{
    if(!aString) return;
    [self MY_safeSetString:aString];
}

@end
