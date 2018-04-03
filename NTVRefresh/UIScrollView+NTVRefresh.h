//
//  UIScrollView+NTVRefresh.h
//  NTVRefresh
//
//  Created by 乔冬 on 17/5/26.
//  Copyright © 2017年 XinHuaTV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTVNormalRefreshFooter.h"
#import "NTVNormalRefreshHeader.h"
@interface UIScrollView (NTVRefresh)
/**
 * 是否是最后一页
 */
@property (nonatomic, assign) BOOL isLastPage;

/**
 * header背景色
 */
@property (nonatomic, strong) UIColor *refreshHeaderBackgroundColor;

/**
 * footer背景色
 */
@property (nonatomic, strong) UIColor *refreshFooterBackgroundColor;

/**
 * header 字体
 */
@property (nonatomic, strong) UIFont *refreshHeaderFont;

/**
 * header 字体颜色
 */
@property (nonatomic, strong) UIColor *refreshHeaderTextColor;

/**
 * footer 字体
 */
@property (nonatomic, strong) UIFont *refreshFooterFont;

/**
 * footer 字体颜色
 */
@property (nonatomic, strong) UIColor *refreshFooterTextColor;

/**
 * ********************** 以下是调用的方法 **********************
 */
/**
 * 普通的刷新及加载
 */
- (void)addRefreshHeaderWithClosure:(NTVRefreshClosure)closure;

- (void)addRefreshFooterWithClosure:(NTVRefreshClosure)closure;


- (void)endRefreshing ;

@end
