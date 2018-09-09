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
        [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(KStringClass)
                                            srcSel:@selector(characterAtIndex:)
                                       swizzledSel:@selector(MY_safeCharacterAtIndex:)];
        
        [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(KStringClass)
                                            srcSel:@selector(substringWithRange:)
                                       swizzledSel:@selector(MY_safeSubstringWithRange:)];
        
        [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(KStringClass)
                                            srcSel:@selector(substringFromIndex:)
                                       swizzledSel:@selector(MY_safeSubstringFromIndex:)];
        
        [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(KStringClass)
                                            srcSel:@selector(substringToIndex:)
                                       swizzledSel:@selector(MY_safeSubstringToIndex:)];
        
        [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(KStringClass)
                                            srcSel:@selector(rangeOfString:)
                                       swizzledSel:@selector(MY_safeRangeOfString:)];
        
        [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(KStringClass)
                                            srcSel:@selector(doubleValue)
                                       swizzledSel:@selector(MY_doubleValue)];
        
        [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(KStringClass)
                                            srcSel:@selector(floatValue)
                                       swizzledSel:@selector(MY_floatValue)];
        
    });
}

- (unichar)MY_safeCharacterAtIndex:(NSUInteger)index
{
    if(index >= self.length) return 0;
    return [self MY_safeCharacterAtIndex:index];
}

- (NSString *)MY_safeSubstringFromIndex:(NSUInteger)from
{
    if(from > self.length) return @"";
    return [self MY_safeSubstringFromIndex:from];
}

- (NSString *)MY_safeSubstringToIndex:(NSUInteger)to
{
    if(to > self.length) return self;
    return [self MY_safeSubstringToIndex:to];
}

- (NSString *)MY_safeSubstringWithRange:(NSRange)range
{
    if(range.location + range.length > self.length) return @"";
    return [self MY_safeSubstringWithRange:range];
}

- (NSRange)MY_safeRangeOfString:(NSString *)searchString
{
    if(!searchString) return NSMakeRange(0, 0);
    return [self MY_safeRangeOfString:searchString];
}

- (double)MY_doubleValue
{
    if ([self rangeOfString:@","].location != NSNotFound)
    {
       return [[[self class] stringDeleteString:self] MY_doubleValue];
    }
    return [self MY_doubleValue];
}

- (float)MY_floatValue
{
    if ([self rangeOfString:@","].location != NSNotFound)
    {
        return [[[self class] stringDeleteString:self] MY_floatValue];
    }
    return [self MY_floatValue];
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
