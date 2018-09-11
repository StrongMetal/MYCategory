//
//  UITableView+MYNoData.h
//  MYSafe
//
//  Created by MY on 2018/7/5.
//  Copyright © 2018年 oh. All rights reserved.
//  自动添加tableView空页面

#import <UIKit/UIKit.h>

@interface UITableView (MYNoData)

/** 无数据时是否显示空页面，默认为NO*/
@property (nonatomic,assign) BOOL my_showEmpty;

/** 空页面显示的文字，默认为”暂无数据“*/
@property (nonatomic,  copy) NSString *my_emptyText;

/** 空页面显示的图片，默认为空 */
@property (nonatomic,strong) UIImage *my_emptyImage;

@end
