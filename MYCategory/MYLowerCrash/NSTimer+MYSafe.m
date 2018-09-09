//
//  NSTimer+MYSafe.m
//  MYSafe
//
//  Created by MY on 2018/7/5.
//  Copyright © 2018年 oh. All rights reserved.
//

#import "NSTimer+MYSafe.h"
#import "NSObject+Swizzle.h"

@interface MYTimerTarget : NSObject

@property (nonatomic,   weak) id aTarget;    //原始taget
@property (nonatomic, assign) SEL aSelector; //原始selector

@end

@implementation MYTimerTarget

- (void)timerTargetAction:(NSTimer *)timer
{
    if(self.aTarget && [self.aTarget respondsToSelector:self.aSelector])
    {
        [self.aTarget performSelector:self.aSelector withObject:timer afterDelay:0.0];
    }
}

- (void)dealloc
{
    NSLog(@"%@ 释放了",NSStringFromClass([MYTimerTarget class]));
}

@end


@implementation NSTimer (MYSafe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self MY_swizzleClassMethodWithSrcClass:[self class] srcSel:@selector(timerWithTimeInterval:target:selector:userInfo:repeats:) swizzledSel:@selector(MY_timerWithTimeInterval:target:selector:userInfo:repeats:)];
    });
}

#pragma mark -- swizzling methods
+ (NSTimer *)MY_timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo
{
    MYTimerTarget *timeTarget = [MYTimerTarget new];
    timeTarget.aTarget = aTarget;
    timeTarget.aSelector = aSelector;
    
    return [NSTimer MY_timerWithTimeInterval:ti target:timeTarget selector:@selector(timerTargetAction:) userInfo:userInfo repeats:yesOrNo];
}

@end
