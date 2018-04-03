//
//  NTVNormalRefreshFooter.m
//  NTVRefresh
//
//  Created by 乔冬 on 17/5/26.
//  Copyright © 2017年 XinHuaTV. All rights reserved.
//

#import "NTVNormalRefreshFooter.h"

@interface NTVNormalRefreshFooter ()
@property (nonatomic, copy) NTVRefreshClosure closure;
@end

@implementation NTVNormalRefreshFooter
+ (instancetype)footer {
    return [[NTVNormalRefreshFooter alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.isLastPage = NO;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    [self.superview removeObserver:self forKeyPath:kContentSizeKey context:nil];
    [self.superview removeObserver:self forKeyPath:kContentOffsetKey context:nil];
    
    if (newSuperview) {
        [newSuperview addObserver:self forKeyPath:kContentSizeKey options:NSKeyValueObservingOptionNew context:nil];
        [newSuperview addObserver:self forKeyPath:kContentOffsetKey options:NSKeyValueObservingOptionNew context:nil];
        
        self.scrollView = (UIScrollView *)newSuperview;
        self.size = CGSizeMake(kNTVRefreshControlWidth, newSuperview.height);
        if (self.scrollView.contentSize.width >= self.scrollView.width) {
            self.left = self.scrollView.contentSize.width;
        } else {
            self.left = self.scrollView.width;
        }
        self.top = 0;
        self.originInsets = self.scrollView.contentInset;
        self.state = NTVRefreshStatePullCanRefresh;
        self.statusLabel.text = self.pullCanRefreshText;
    }
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:kContentSizeKey]) {
        // 刷新完成后调整控件位置
        if (self.scrollView.contentSize.width >= self.scrollView.width) {
            self.left = self.scrollView.contentSize.width;
        } else {
            self.left = self.scrollView.width;
        }
    } else if ([keyPath isEqualToString:kContentOffsetKey]) {
        if (self.state == NTVRefreshStateRefreshing || self.state == NTVRefreshStateNoMoreData) {
            return;
        }
        // 调整控件状态
        [self reloadStateWithContentOffsetX];
    }
}
- (void)reloadStateWithContentOffsetX {
    // 当前偏移量
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    // 刚好出现刷新footer的偏移量
    CGFloat appearOffsetX = self.scrollView.contentSize.width - self.scrollView.width;
    // 松开即可刷新的偏移量
    CGFloat releaseToRefreshOffsetX = appearOffsetX + self.width;
    
    // 如果是向右滚动，看不到尾部footer，直接return
    if (contentOffsetX <= appearOffsetX) {
        return;
    }
    
    if (self.scrollView.isDragging) {
        // 拖拽的百分比
        self.pullingPercent = (contentOffsetX - appearOffsetX) / self.width;
        
        if (self.state == NTVRefreshStatePullCanRefresh && contentOffsetX > releaseToRefreshOffsetX) {
            // 转为松开即可刷新状态
            self.state = NTVRefreshStateReleaseCanRefresh;
        } else if (self.state == NTVRefreshStateReleaseCanRefresh && contentOffsetX <= releaseToRefreshOffsetX) {
            // 转为拖拽可以刷新状态
            self.state = NTVRefreshStatePullCanRefresh;
        }
    } else if (self.state == NTVRefreshStateReleaseCanRefresh && !self.scrollView.isDragging) {
        // 开始刷新
        self.state = NTVRefreshStateRefreshing;
        self.pullingPercent = 1.f;
        
        UIEdgeInsets insets = self.scrollView.contentInset;
        insets.right += self.width;
        self.scrollView.contentInset = insets;
        
        // 回调
        BLOCK_EXE(_closure)
    } else {
        self.pullingPercent = (contentOffsetX - appearOffsetX) / self.width;
    }
}


- (void)setState:(NTVRefreshState)state {
    [super setState:state];
    
    switch (state) {
        case NTVRefreshStatePullCanRefresh: {
            self.imageView.hidden = NO;
            self.activityView.hidden = YES;
            self.imageView.image = [UIImage imageNamed:@"arrow.png"];
            [UIView animateWithDuration:kNTVRefreshFastAnimationDuration animations:^{
                self.imageView.transform = CGAffineTransformMakeRotation(0);
            }];
            break;
        }
        case NTVRefreshStateReleaseCanRefresh: {
            self.imageView.hidden = NO;
            self.activityView.hidden = YES;
            [UIView animateWithDuration:kNTVRefreshFastAnimationDuration animations:^{
                self.imageView.transform = CGAffineTransformMakeRotation(M_PI);
            }];
            break;
        }
        case NTVRefreshStateRefreshing: {
            self.imageView.hidden = YES;
            self.activityView.hidden = NO;
            [self.activityView startAnimating];
            break;
        }
        case NTVRefreshStateNoMoreData: {
            self.imageView.hidden = YES;
            self.activityView.hidden = YES;
            [self.activityView stopAnimating];
            break;
        }
    }
}
- (void)endRefreshing {
    [UIView animateWithDuration:kNTVRefreshFastAnimationDuration animations:^{
        self.scrollView.contentInset = self.originInsets;
    }];
    if (self.state == NTVRefreshStateNoMoreData) {
        return;
    }
    self.state = NTVRefreshStatePullCanRefresh;
}

- (void)addRefreshFooterWithClosure:(NTVRefreshClosure)closure {
    self.closure = closure;
}

- (void)setIsLastPage:(BOOL)isLastPage {
    _isLastPage = isLastPage;
    if (_isLastPage) {
        self.state = NTVRefreshStateNoMoreData;
    } else {
        self.state = NTVRefreshStatePullCanRefresh;
    }
}




@end
