//
//  UILabel+MYMargin.h
//  MYSafe
//
//  Created by MY on 2018/7/5.
//  Copyright © 2018年 oh. All rights reserved.
//  设置label文字边距

#import <UIKit/UIKit.h>

@interface UILabel (MYMargin)

/** 文字边缘间距 {上，左，下，右}*/
@property (nonatomic,assign) UIEdgeInsets my_textEdgeInset;

@end
