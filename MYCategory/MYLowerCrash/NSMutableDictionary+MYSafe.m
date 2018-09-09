//
//  NSMutableDictionary+MYSafe.m
//  SwizzleProject
//
//  Created by oh on 2017/4/26.
//  Copyright © 2017年 oh. All rights reserved.
//

#import "NSMutableDictionary+MYSafe.h"
#import "NSObject+Swizzle.h"

@implementation NSMutableDictionary (MYSafe)
static NSString *KMDictionaryClass = @"__NSDictionaryM";

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self MY_swizzleInstanceMethodWithSrcClass:NSClassFromString(KMDictionaryClass)
                                            srcSel:@selector(setObject:forKey:)
                                       swizzledSel:@selector(MY_safeSetObject:forKey:)];
    });
}
- (void)MY_safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if(!anObject || !aKey) return;
    [self MY_safeSetObject:anObject forKey:aKey];
}

@end
