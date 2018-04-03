//
//  NTVBaseRefreshControl.h
//  NTVRefresh
//
//  Created by 乔冬 on 17/5/26.
//  Copyright © 2017年 XinHuaTV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "NTVRefreshConfig.h"
#import "UIView+NTVFrame.h"
typedef enum{
     NTVRefreshStatePullCanRefresh = 1, // 拖拽可以刷新状态
     NTVRefreshStateReleaseCanRefresh = 2, // 松开即可刷新状态
     NTVRefreshStateRefreshing = 3, // 正在刷新状态
     NTVRefreshStateNoMoreData = 4, // 没有更多数据状态
}NTVRefreshState;

static NSString *const kContentOffsetKey = @"contentOffset";
static NSString *const kContentSizeKey = @"contentSize";

/// 刷新控件的宽度，在这里调整
static CGFloat const kNTVRefreshControlWidth = 44.0;
static CGFloat const kNTVRefreshFastAnimationDuration = 0.25;
static CGFloat const kNTVRefreshSlowAnimationDuration = 0.4;
@interface NTVBaseRefreshControl : UIView
/// 基础控件
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

/**
 * 状态显示文字
 */
// 拉动可以（刷新/加载）
@property (nonatomic, copy) NSString *pullCanRefreshText;
// 松开可以（刷新/加载）
@property (nonatomic, copy) NSString *releaseCanRefreshText;
// 正在（刷新/加载）
@property (nonatomic, copy) NSString *refreshingText;
// 没有更多数据
@property (nonatomic, copy) NSString *noMoreDataText;

/// 基本属性
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;

/// 状态
@property (nonatomic, assign) NTVRefreshState state;
/// 父视图（scrollView）
@property (nonatomic, weak) UIScrollView *scrollView;

/// 设置状态相应文字
- (void)setTitle:(NSString *)title forState:(NTVRefreshState)state;

/// 拖拽的比例
@property (nonatomic, assign) CGFloat pullingPercent;
/// 原边距
@property (nonatomic, assign) UIEdgeInsets originInsets;

- (void)endRefreshing;

/// 是否隐藏状态label，注意：如果要隐藏状态label，要先设置这个属性
@property (nonatomic, assign) BOOL stateLabelHidden;


@end


@interface NSString (NTVRefresh)
- (NSString *)insertLinefeeds;
@end








