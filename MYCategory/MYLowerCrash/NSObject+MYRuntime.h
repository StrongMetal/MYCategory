//
//  NSObject+MYRuntime.h
//  MYSafe
//
//  Created by MY on 2018/7/4.
//  Copyright © 2018年 oh. All rights reserved.
//  获取类所有的属性、成员变量、方法、协议

#import <Foundation/Foundation.h>

@interface NSObject (MYRuntime)

/**
 返回当前类所有的属性

 @return 属性数组
 */
+ (NSArray *)my_propertyList;

/**
 返回当前类所有的成员变量

 @return 成员变量数组
 */
+ (NSArray *)my_ivarList;

/**
 放回当前类所有的方法

 @return 方法数组
 */
+ (NSArray *)my_methodList;

/**
 返回当前类所有的协议

 @return 协议列表
 */
+ (NSArray *)my_protocolList;


@end
