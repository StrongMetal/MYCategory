//
//  UIButton+TapHandle.h
//  MYSafe
//
//  Created by MY on 2018/7/3.
//  Copyright © 2018年 oh. All rights reserved.
//  控制按钮点击范围、防止按钮暴力点击

#import <UIKit/UIKit.h>

@interface UIButton (MYTap)

/** 控制按钮的点击范围 {上，左，下，右}*/
@property (nonatomic,assign) UIEdgeInsets my_hitEdgeInsets;

@end
