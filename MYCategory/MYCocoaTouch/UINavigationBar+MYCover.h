//
//  UINavigationBar+MYCover.h
//  MYSafe
//
//  Created by MY on 2018/7/6.
//  Copyright © 2018年 oh. All rights reserved.
//  设置NavigationBar透明+位移

#import <UIKit/UIKit.h>

@interface UINavigationBar (MYCover)

- (void)MY_setBackgroundColor:(UIColor *)backgroundColor;

- (void)MY_setTranslationY:(CGFloat)translationY;

- (void)MY_setElementAlpha:(CGFloat)alpha;

- (void)MY_reset;

@end
