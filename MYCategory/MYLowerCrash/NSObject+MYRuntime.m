//
//  NSObject+MYRuntime.m
//  MYSafe
//
//  Created by MY on 2018/7/4.
//  Copyright © 2018年 oh. All rights reserved.
//

#import "NSObject+MYRuntime.h"
#import <objc/runtime.h>

@implementation NSObject (MYRuntime)

/**
 返回当前类所有的属性
 
 @return 属性数组
 */
+ (NSArray *)MY_propertyList
{
    NSArray *array = objc_getAssociatedObject(self, @selector(MY_propertyList));
    if (array) return array;
    
    NSMutableArray *mArray = @[].mutableCopy;
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i ++)
    {
        objc_property_t propety = propertys[i];
        const char *propetyName = property_getName(propety);
        [mArray addObject:[NSString stringWithUTF8String:propetyName]];
    }
    free(propertys);
    
    objc_setAssociatedObject(self, @selector(MY_propertyList), mArray, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return objc_getAssociatedObject(self, @selector(MY_propertyList));
}

/**
 返回当前类所有的成员变量
 
 @return 成员变量数组
 */
+ (NSArray *)MY_ivarList
{
    NSArray *array = objc_getAssociatedObject(self, @selector(MY_ivarList));
    if (array) return array;
    
    NSMutableArray *mArray = @[].mutableCopy;
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i ++)
    {
        Ivar ivar = ivars[i];
        const char *ivarName = ivar_getName(ivar);
        [mArray addObject:[NSString stringWithUTF8String:ivarName]];
    }
    free(ivars);
    
    objc_setAssociatedObject(self, @selector(MY_ivarList), mArray, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return objc_getAssociatedObject(self, @selector(MY_ivarList));
}

/**
 放回当前类所有的方法
 
 @return 方法数组
 */
+ (NSArray *)MY_methodList
{
    NSArray *array = objc_getAssociatedObject(self, @selector(MY_methodList));
    if (array) return array;
    
    NSMutableArray *mArray = @[].mutableCopy;
    unsigned int count = 0;
    Method *methods = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; i ++)
    {
        Method method = methods[i];
        SEL sel = method_getName(method);
        [mArray addObject:NSStringFromSelector(sel)];
    }
    free(methods);
    
    objc_setAssociatedObject(self, @selector(MY_methodList), mArray, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return objc_getAssociatedObject(self, @selector(MY_methodList));
}

/**
 返回当前类所有的协议
 
 @return 协议列表
 */
+ (NSArray *)MY_protocolList;
{
    NSArray *array = objc_getAssociatedObject(self, @selector(MY_protocolList));
    if (array) return array;
    
    NSMutableArray *mArray = @[].mutableCopy;
    unsigned int count = 0;
    Protocol * __unsafe_unretained *protocols = class_copyProtocolList([self class], &count);
    for (int i = 0; i < count; i ++)
    {
        Protocol *protocol = protocols[i];
        const char *protocolName = protocol_getName(protocol);
        [mArray addObject:[NSString stringWithUTF8String:protocolName]];
    }
    free(protocols);
    
    objc_setAssociatedObject(self, @selector(MY_protocolList), mArray, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return objc_getAssociatedObject(self, @selector(MY_protocolList));
}

@end
