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
        && !lastVC.my_interactivePopDisabled)
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
        [self my_swizzleInstanceMethodWithSrcClass:[self class] srcSel:@selector(viewWillAppear:) swizzledSel:@selector(my_viewWillAppear:)];
    });
}

#pragma mark -- swizzling methods
- (void)my_viewWillAppear:(BOOL)animated
{
    if(![self.navigationController.my_ignoreVCs containsObject:NSStringFromClass([self class])]
       && self.navigationController.my_barAppearaceEnabled)
    {
        [self.navigationController setNavigationBarHidden:self.my_navigationBarHidden animated:animated];
    }
    [self my_viewWillAppear:animated];
}

#pragma mark -- getter && setter
- (BOOL)my_navigationBarHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setmy_navigationBarHidden:(BOOL)my_navigationBarHidden
{
    objc_setAssociatedObject(self, @selector(my_navigationBarHidden), @(my_navigationBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)my_interactivePopDisabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setmy_interactivePopDisabled:(BOOL)my_interactivePopDisabled
{
    objc_setAssociatedObject(self, @selector(my_interactivePopDisabled), @(my_interactivePopDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@implementation UINavigationController (MYBarHide)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self my_swizzleInstanceMethodWithSrcClass:[self class] srcSel:@selector(viewDidLoad) swizzledSel:@selector(my_viewDidLoad)];
    });
}

#pragma mark -- swizzling methods
- (void)my_viewDidLoad
{
    self.interactivePopGestureRecognizer.delegate = self.my_popGestureRecognizerDelegate;
    [self my_viewDidLoad];
}

#pragma mark -- getter && setter
- (NSMutableSet <__kindof NSString *> *)my_ignoreVCs
{
    NSMutableSet *mSet = objc_getAssociatedObject(self, _cmd);
    if (!mSet)
    {
        mSet = [NSMutableSet set];
        self.my_ignoreVCs = mSet;
    }
    return mSet;
}

- (void)setmy_ignoreVCs:(NSMutableSet<__kindof NSString *> *)my_ignoreVCs
{
    objc_setAssociatedObject(self, @selector(my_ignoreVCs), my_ignoreVCs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)my_barAppearaceEnabled
{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if(number){
      return number.boolValue;
    }
    self.my_barAppearaceEnabled = YES;
    return YES;
}

- (void)setmy_barAppearaceEnabled:(BOOL)my_barAppearaceEnabled
{
    objc_setAssociatedObject(self, @selector(my_barAppearaceEnabled), @(my_barAppearaceEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MYPopGestureRecognizerDelegate *)my_popGestureRecognizerDelegate
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

