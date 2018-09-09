//
//  UINavigationController+MYBarHide.h
//  MYSafe
//
//  Created by MY on 2018/7/10.
//  Copyright © 2018年 oh. All rights reserved.
//  解决导航栏隐藏的控制器手势返回动画过渡问题，关闭导航穿透 + 关闭动画 = 滑动返回顶部黑条，动画关闭过渡不自然
//  解决修改导航栏导致滑动返回手势失效问题、跟控制器滑动页面假死

#import <UIKit/UIKit.h>

@interface UINavigationController (MYBarHide)<UIGestureRecognizerDelegate>

/** 忽略navigationbar自动显示的控制器集合，默认为空，相当于一个黑名单
    当控制器在viewDidLoad中隐藏了navigationbar，则把该控制器添加至该集合
 */
@property (nonatomic,strong) NSMutableSet<__kindof NSString *> *MY_ignoreVCs;

/** 是否自动控制navigationbar显示隐藏，默认为YES */
@property (nonatomic,assign) BOOL MY_barAppearaceEnabled;

@end

@interface UIViewController (MYBarHide)

/** 导航栏是否隐藏，默认为NO */
@property (nonatomic,assign) BOOL MY_navigationBarHidden;

/** 滑动返回手势失效，默认为NO */
@property (nonatomic,assign) BOOL MY_interactivePopDisabled;

@end
