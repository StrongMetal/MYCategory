//
//  UITableView+MYNoData.m
//  MYSafe
//
//  Created by MY on 2018/7/5.
//  Copyright © 2018年 oh. All rights reserved.
//

#import "UITableView+MYNoData.h"
#import "NSObject+Swizzle.h"

#define Left(view)   CGRectGetMinX(view.frame)
#define Top(view)    CGRectGetMinY(view.frame)
#define Bottom(view) CGRectGetMaxY(view.frame)
#define Width(view)  CGRectGetWidth(view.frame)
#define Height(view) CGRectGetHeight(view.frame)

@interface MYEmptyView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                         text:(NSString *)text
                        image:(UIImage *)image;

@end

@implementation MYEmptyView

- (instancetype)initWithFrame:(CGRect)frame
                         text:(NSString *)text
                        image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        UILabel * label = [UILabel new];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithRed:33/255.f green:33/255.f blue:33/255.f alpha:1.0];
        label.text = text;
        label.textAlignment = 1;
        [label sizeToFit];
        CGPoint centerPoint = CGPointMake(CGRectGetMaxX(frame)/2.f, CGRectGetMaxY(frame)/2.f);
        label.center = centerPoint;
        [self addSubview:label];
        
        if(image)
        {
            CGFloat margin = 10;
            UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
            [imageView sizeToFit];
            [self addSubview:imageView];
            imageView.center = centerPoint;
            imageView.frame = CGRectMake(Left(imageView), Top(imageView) - (Height(label) + margin)/2.f, Width(imageView), Height(imageView));
            label.frame = CGRectMake(Left(label), Bottom(imageView) + margin, Width(label), Height(label));
        }
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end;

@implementation UITableView (MYNoData)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self my_swizzleInstanceMethodWithSrcClass:[self class] srcSel:@selector(reloadData) swizzledSel:@selector(my_reloadData)];
    });
}

#pragma mark -- swizzling methods
- (void)my_reloadData
{
    //需要显示空页面 && 已经跳过第一次加载(设置datasource的时候会自动执行一次reloadData,需要跳过)
    if(self.my_showEmpty && self.my_firstSkiped) [self my_checkEmpty];
    self.my_firstSkiped = YES;
    [self my_reloadData];
}

/** 检查是否为空页面 */
- (void)my_checkEmpty
{
    BOOL isEmpty = YES;
    id<UITableViewDataSource> dataSource = self.dataSource;
    NSInteger sections = 1;
    if([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)])
    {
        sections = [dataSource numberOfSectionsInTableView:self];
    }
    //遍历组，判断是否有row
    for (int i = 0; i < sections; i++){
        if([dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)])
        {
            if([dataSource tableView:self numberOfRowsInSection:i] > 0)
            {
                isEmpty = NO;
                break;
            }
        }
    }
    //显示隐藏空页面
    if(isEmpty)
    {
        if(!self.my_emptyView)
        {
            self.my_emptyView = [[MYEmptyView alloc]initWithFrame:self.bounds text:self.my_emptyText image:self.my_emptyImage];
            [self addSubview:self.my_emptyView];
        }
        self.my_emptyView.hidden = NO;
        
    }else
    {
        self.my_emptyView.hidden = YES;
    }
}

#pragma mark -- getter && setter
- (BOOL)my_showEmpty
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setmy_showEmpty:(BOOL)my_showEmpty
{
    objc_setAssociatedObject(self, @selector(my_showEmpty), @(my_showEmpty), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)my_firstSkiped
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setmy_firstSkiped:(BOOL)my_firstSkiped
{
    objc_setAssociatedObject(self, @selector(my_firstSkiped), @(my_firstSkiped), OBJC_ASSOCIATION_ASSIGN);
}

- (NSString *)my_emptyText
{
    NSString *text = objc_getAssociatedObject(self, _cmd);
    if(!text) text = @"暂无数据";
    return text;
}

- (void)setmy_emptyText:(NSString *)my_emptyText
{
    objc_setAssociatedObject(self, @selector(my_emptyText), my_emptyText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)my_emptyImage
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setmy_emptyImage:(UIImage *)my_emptyImage
{
    objc_setAssociatedObject(self, @selector(my_emptyImage), my_emptyImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MYEmptyView *)my_emptyView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setmy_emptyView:(MYEmptyView *)my_emptyView
{
    objc_setAssociatedObject(self, @selector(my_emptyView), my_emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


