//
//  UILabel+MYMargin.m
//  MYSafe
//
//  Created by MY on 2018/7/5.
//  Copyright © 2018年 oh. All rights reserved.
//

#import "UILabel+MYMargin.h"
#import <objc/runtime.h>
#import "NSObject+Swizzle.h"

@implementation UILabel (MYMargin)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self MY_swizzleInstanceMethodWithSrcClass:[self class] srcSel:@selector(textRectForBounds:limitedToNumberOfLines:) swizzledSel:@selector(MY_textRectForBounds:limitedToNumberOfLines:)];
        
        [self MY_swizzleInstanceMethodWithSrcClass:[self class] srcSel:@selector(drawTextInRect:) swizzledSel:@selector(MY_drawTextInRect:)];
        
    });
}

#pragma mark -- swizzling methods
- (CGRect)MY_textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect rect = [self MY_textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.MY_textEdgeInset) limitedToNumberOfLines:numberOfLines];
    rect.origin.x -= self.MY_textEdgeInset.left;
    rect.origin.y -= self.MY_textEdgeInset.top;
    rect.size.width += (self.MY_textEdgeInset.left + self.MY_textEdgeInset.right);
    rect.size.height += (self.MY_textEdgeInset.top + self.MY_textEdgeInset.bottom);
    return rect;
}

- (void)MY_drawTextInRect:(CGRect)rect
{
    [self MY_drawTextInRect:UIEdgeInsetsInsetRect(rect, self.MY_textEdgeInset)];
}

#pragma mark -- getter && setter
- (UIEdgeInsets)MY_textEdgeInset
{
    NSValue *value = objc_getAssociatedObject(self, _cmd);
    if(value)
    {
        return value.UIEdgeInsetsValue;
    }
    return UIEdgeInsetsZero;
}

- (void)setMY_textEdgeInset:(UIEdgeInsets)textEdgeInset
{
    objc_setAssociatedObject(self, @selector(MY_textEdgeInset), [NSValue valueWithUIEdgeInsets:textEdgeInset], OBJC_ASSOCIATION_ASSIGN);
}

@end

