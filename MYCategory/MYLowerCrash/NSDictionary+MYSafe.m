//
//  NSDictionary+MYSafe.m
//  SwizzleProject
//
//  Created by oh on 2017/4/25.
//  Copyright © 2017年 oh. All rights reserved.
//

#import "NSDictionary+MYSafe.h"
#import "NSObject+Swizzle.h"

@implementation NSDictionary (MYSafe)
static NSString *KDictionaryClass = @"__NSPlaceholderDictionary";

+(void)load
{
    NSLog(@"NSDictionary + load");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self my_swizzleInstanceMethodWithSrcClass:NSClassFromString(KDictionaryClass)
                                            srcSel:@selector(initWithObjects:forKeys:count:)
                                       swizzledSel:@selector(my_safeInitWithObjects:forKeys:count:)];
    });
}

- (instancetype)my_safeInitWithObjects:(id*)objects forKeys:(id*)keys count:(NSUInteger)cnt
{
    for (NSUInteger i = 0; i < cnt; i++)
    {
        if(!keys[i]) keys[i] = @"";

        if(!objects[i]) objects[i] = @"";
    }
    return [self my_safeInitWithObjects:objects forKeys:keys count:cnt];
}

@end
