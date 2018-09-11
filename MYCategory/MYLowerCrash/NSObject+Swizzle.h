//
//  NSObject+Swizzle.h
//  SwizzleProject
//
//  Created by oh on 2017/4/25.
//  Copyright © 2017年 oh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (Swizzle)

/**
 交换两个对象方法的实现

 @param srcClass 被替换方法的类
 @param srcSel 被替换的方法编号
 @param swizzledSel 用于替换的方法编号
 */
- (void)my_swizzleInstanceMethodWithSrcClass:(Class)srcClass
                                      srcSel:(SEL)srcSel
                                 swizzledSel:(SEL)swizzledSel;


/**
 交换两个类方法的实现
 
 @param srcClass 被替换方法的类
 @param srcSel 被替换的方法编号
 @param swizzledSel 用于替换的方法编号
 */
- (void)my_swizzleClassMethodWithSrcClass:(Class)srcClass
                                   srcSel:(SEL)srcSel
                              swizzledSel:(SEL)swizzledSel;

@end
