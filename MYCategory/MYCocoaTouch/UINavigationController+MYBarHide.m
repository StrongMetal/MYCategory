//
//  UINavigationController+MYBarHide.m
//  MYSafe
//
//  Created by MY on 2018/7/10.
//  Copyright © 2018年 oh. All rights reserved.
//

#import "UINavigationController+MYBarHide.h"
#import "NSObject+Swizzle.h"

@interface MYPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *nav;

@end

@implementation MYPopGestureRecognizerDelegate

#pragma mark -- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UIViewController *lastVC = self.nav.viewControllers.lastObject;
    //不是跟视图控制器 && pop跟push动画没有正在执行 && 手势有效
    if (self.nav.childViewControllers.count > 1
        && ![[self.nav valueForKey:@"_isTransitioning"] boolValue]
        && !lastVC.MY_interactivePopDisabled)
    {
        return YES;
    }
    return NO;
}

@end


@implementation UIViewController (MYBarHide)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self MY_swizzleInstanceMethodWithSrcClass:[self class] srcSel:@selector(viewWillAppear:) swizzledSel:@selector(MY_viewWillAppear:)];
    });
}

#pragma mark -- swizzling methods
- (void)MY_viewWillAppear:(BOOL)animated
{
    if(![self.navigationController.MY_ignoreVCs containsObject:NSStringFromClass([self class])]
       && self.navigationController.MY_barAppearaceEnabled)
    {
        [self.navigationController setNavigationBarHidden:self.MY_navigationBarHidden animated:animated];
    }
    [self MY_viewWillAppear:animated];
}

#pragma mark -- getter && setter
- (BOOL)MY_navigationBarHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setMY_navigationBarHidden:(BOOL)MY_navigationBarHidden
{
    objc_setAssociatedObject(self, @selector(MY_navigationBarHidden), @(MY_navigationBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)MY_interactivePopDisabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setMY_interactivePopDisabled:(BOOL)MY_interactivePopDisabled
{
    objc_setAssociatedObject(self, @selector(MY_interactivePopDisabled), @(MY_interactivePopDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@implementation UINavigationController (MYBarHide)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self MY_swizzleInstanceMethodWithSrcClass:[self class] srcSel:@selector(viewDidLoad) swizzledSel:@selector(MY_viewDidLoad)];
    });
}

#pragma mark -- swizzling methods
- (void)MY_viewDidLoad
{
    self.interactivePopGestureRecognizer.delegate = self.MY_popGestureRecognizerDelegate;
    [self MY_viewDidLoad];
}

#pragma mark -- getter && setter
- (NSMutableSet <__kindof NSString *> *)MY_ignoreVCs
{
    NSMutableSet *mSet = objc_getAssociatedObject(self, _cmd);
    if (!mSet)
    {
        mSet = [NSMutableSet set];
        self.MY_ignoreVCs = mSet;
    }
    return mSet;
}

- (void)setMY_ignoreVCs:(NSMutableSet<__kindof NSString *> *)MY_ignoreVCs
{
    objc_setAssociatedObject(self, @selector(MY_ignoreVCs), MY_ignoreVCs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)MY_barAppearaceEnabled
{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if(number){
      return number.boolValue;
    }
    self.MY_barAppearaceEnabled = YES;
    return YES;
}

- (void)setMY_barAppearaceEnabled:(BOOL)MY_barAppearaceEnabled
{
    objc_setAssociatedObject(self, @selector(MY_barAppearaceEnabled), @(MY_barAppearaceEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MYPopGestureRecognizerDelegate *)MY_popGestureRecognizerDelegate
{
    MYPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (!delegate)
    {
        delegate = [[MYPopGestureRecognizerDelegate alloc] init];
        delegate.nav = self;
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

@end

