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
        
        [self my_swizzleInstanceMethodWithSrcClass:[self class] srcSel:@selector(textRectForBounds:limitedToNumberOfLines:) swizzledSel:@selector(my_textRectForBounds:limitedToNumberOfLines:)];
        
        [self my_swizzleInstanceMethodWithSrcClass:[self class] srcSel:@selector(drawTextInRect:) swizzledSel:@selector(my_drawTextInRect:)];
        
    });
}

#pragma mark -- swizzling methods
- (CGRect)my_textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect rect = [self my_textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.my_textEdgeInset) limitedToNumberOfLines:numberOfLines];
    rect.origin.x -= self.my_textEdgeInset.left;
    rect.origin.y -= self.my_textEdgeInset.top;
    rect.size.width += (self.my_textEdgeInset.left + self.my_textEdgeInset.right);
    rect.size.height += (self.my_textEdgeInset.top + self.my_textEdgeInset.bottom);
    return rect;
}

- (void)my_drawTextInRect:(CGRect)rect
{
    [self my_drawTextInRect:UIEdgeInsetsInsetRect(rect, self.my_textEdgeInset)];
}

#pragma mark -- getter && setter
- (UIEdgeInsets)my_textEdgeInset
{
    NSValue *value = objc_getAssociatedObject(self, _cmd);
    if(value)
    {
        return value.UIEdgeInsetsValue;
    }
    return UIEdgeInsetsZero;
}

- (void)setmy_textEdgeInset:(UIEdgeInsets)textEdgeInset
{
    objc_setAssociatedObject(self, @selector(my_textEdgeInset), [NSValue valueWithUIEdgeInsets:textEdgeInset], OBJC_ASSOCIATION_ASSIGN);
}

@end

