//
//  NSString+MYSafe.m
//  SwizzleProject
//
//  Created by oh on 2017/4/26.
//  Copyright © 2017年 oh. All rights reserved.
//

#import "NSString+MYSafe.h"
#import "NSObject+Swizzle.h"

@implementation NSString (MYSafe)
static NSString *KStringClass = @"__NSCFString";

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(KStringClass)
                                            srcSel:@selector(characterAtIndex:)
                                       swizzledSel:@selector(my_safeCharacterAtIndex:)];
        
        [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(KStringClass)
                                            srcSel:@selector(substringWithRange:)
                                       swizzledSel:@selector(my_safeSubstringWithRange:)];
        
        [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(KStringClass)
                                            srcSel:@selector(substringFromIndex:)
                                       swizzledSel:@selector(my_safeSubstringFromIndex:)];
        
        [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(KStringClass)
                                            srcSel:@selector(substringToIndex:)
                                       swizzledSel:@selector(my_safeSubstringToIndex:)];
        
        [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(KStringClass)
                                            srcSel:@selector(rangeOfString:)
                                       swizzledSel:@selector(my_safeRangeOfString:)];
        
        [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(KStringClass)
                                            srcSel:@selector(doubleValue)
                                       swizzledSel:@selector(my_doubleValue)];
        
        [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(KStringClass)
                                            srcSel:@selector(floatValue)
                                       swizzledSel:@selector(my_floatValue)];
        
    });
}

- (unichar)my_safeCharacterAtIndex:(NSUInteger)index
{
    if(index >= self.length) return 0;
    return [self my_safeCharacterAtIndex:index];
}

- (NSString *)my_safeSubstringFromIndex:(NSUInteger)from
{
    if(from > self.length) return @"";
    return [self my_safeSubstringFromIndex:from];
}

- (NSString *)my_safeSubstringToIndex:(NSUInteger)to
{
    if(to > self.length) return self;
    return [self my_safeSubstringToIndex:to];
}

- (NSString *)my_safeSubstringWithRange:(NSRange)range
{
    if(range.location + range.length > self.length) return @"";
    return [self my_safeSubstringWithRange:range];
}

- (NSRange)my_safeRangeOfString:(NSString *)searchString
{
    if(!searchString) return NSMakeRange(0, 0);
    return [self my_safeRangeOfString:searchString];
}

- (double)my_doubleValue
{
    if ([self rangeOfString:@","].location != NSNotFound)
    {
       return [[[self class] stringDeleteString:self] my_doubleValue];
    }
    return [self my_doubleValue];
}

- (float)my_floatValue
{
    if ([self rangeOfString:@","].location != NSNotFound)
    {
        return [[[self class] stringDeleteString:self] my_floatValue];
    }
    return [self my_floatValue];
}

//删除中间的，%
+(NSString *)stringDeleteString:(NSString *)str;
{
    NSMutableString *str1 = [NSMutableString stringWithString:str];
    for (int i = 0; i < str1.length; i++) {
        unichar c = [str1 characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        if ( c == ',' || c == '%') { //此处可以是任何字符
            [str1 deleteCharactersInRange:range];
            --i;
        }
    }
    NSString *newstr = [NSString stringWithString:str1];
    return newstr;
}

@end
