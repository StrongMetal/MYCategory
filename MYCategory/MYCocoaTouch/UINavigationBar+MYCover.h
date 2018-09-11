//
//  UINavigationBar+MYCover.h
//  MYSafe
//
//  Created by MY on 2018/7/6.
//  Copyright © 2018年 oh. All rights reserved.
//  设置NavigationBar透明+位移

#import <UIKit/UIKit.h>

@interface UINavigationBar (MYCover)

- (void)my_setBackgroundColor:(UIColor *)backgroundColor;

- (void)my_setTranslationY:(CGFloat)translationY;

- (void)my_setElementAlpha:(CGFloat)alpha;

- (void)my_reset;

@end
