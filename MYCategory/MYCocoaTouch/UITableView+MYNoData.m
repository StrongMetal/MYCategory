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
        [self MY_swizzleInstanceMethodWithSrcClass:[self class] srcSel:@selector(reloadData) swizzledSel:@selector(MY_reloadData)];
    });
}

#pragma mark -- swizzling methods
- (void)MY_reloadData
{
    //需要显示空页面 && 已经跳过第一次加载(设置datasource的时候会自动执行一次reloadData,需要跳过)
    if(self.MY_showEmpty && self.MY_firstSkiped) [self MY_checkEmpty];
    self.MY_firstSkiped = YES;
    [self MY_reloadData];
}

/** 检查是否为空页面 */
- (void)MY_checkEmpty
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
        if(!self.MY_emptyView)
        {
            self.MY_emptyView = [[MYEmptyView alloc]initWithFrame:self.bounds text:self.MY_emptyText image:self.MY_emptyImage];
            [self addSubview:self.MY_emptyView];
        }
        self.MY_emptyView.hidden = NO;
        
    }else
    {
        self.MY_emptyView.hidden = YES;
    }
}

#pragma mark -- getter && setter
- (BOOL)MY_showEmpty
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setMY_showEmpty:(BOOL)MY_showEmpty
{
    objc_setAssociatedObject(self, @selector(MY_showEmpty), @(MY_showEmpty), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)MY_firstSkiped
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setMY_firstSkiped:(BOOL)MY_firstSkiped
{
    objc_setAssociatedObject(self, @selector(MY_firstSkiped), @(MY_firstSkiped), OBJC_ASSOCIATION_ASSIGN);
}

- (NSString *)MY_emptyText
{
    NSString *text = objc_getAssociatedObject(self, _cmd);
    if(!text) text = @"暂无数据";
    return text;
}

- (void)setMY_emptyText:(NSString *)MY_emptyText
{
    objc_setAssociatedObject(self, @selector(MY_emptyText), MY_emptyText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)MY_emptyImage
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setMY_emptyImage:(UIImage *)MY_emptyImage
{
    objc_setAssociatedObject(self, @selector(MY_emptyImage), MY_emptyImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MYEmptyView *)MY_emptyView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setMY_emptyView:(MYEmptyView *)MY_emptyView
{
    objc_setAssociatedObject(self, @selector(MY_emptyView), MY_emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


