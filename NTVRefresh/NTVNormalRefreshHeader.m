//
//  NTVNormalRefreshHeader.m
//  NTVRefresh
//
//  Created by 乔冬 on 17/5/26.
//  Copyright © 2017年 XinHuaTV. All rights reserved.
//

#import "NTVNormalRefreshHeader.h"
@interface NTVNormalRefreshHeader ()
@property (nonatomic, copy) NTVRefreshClosure closure;
@end

@implementation NTVNormalRefreshHeader
+ (instancetype)header {
    return [[NTVNormalRefreshHeader alloc] init];
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self.superview removeObserver:self forKeyPath:kContentOffsetKey context:nil];
    
    if (newSuperview) {
        [newSuperview addObserver:self forKeyPath:kContentOffsetKey options:NSKeyValueObservingOptionNew context:nil];
        self.scrollView = (UIScrollView *)newSuperview;
        self.size = CGSizeMake(kNTVRefreshControlWidth, newSuperview.height);
        self.right = 0;
        self.top = 0;
        
        self.originInsets = self.scrollView.contentInset;
        self.state = NTVRefreshStatePullCanRefresh;
        self.statusLabel.text = self.pullCanRefreshText;
    }
    
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:kContentOffsetKey]) {
        if (self.state == NTVRefreshStateRefreshing) { return; }
        // 调整控件状态
        [self reloadStateWithContentOffsetX];
    }

}
- (void)reloadStateWithContentOffsetX {
    // 当前偏移量
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    // 刚好出现刷新header的偏移量
    CGFloat appearOffsetX = self.scrollView.contentSize.width - self.scrollView.width;
    // 松开即可刷新的偏移量
    CGFloat releaseToRefreshOffsetX = appearOffsetX + self.width;
    
    // 如果是向左滚动，看不到尾部header，直接return
    if (contentOffsetX >= appearOffsetX) {
        NSLog(@"左？");
        return;
    }
    
    if (self.scrollView.isDragging) {
        // 拖拽的百分比
        self.pullingPercent = (appearOffsetX - contentOffsetX) / self.width;
        
        if (self.state == NTVRefreshStatePullCanRefresh && contentOffsetX < releaseToRefreshOffsetX) {
            // 转为松开即可刷新状态
            self.state = NTVRefreshStateReleaseCanRefresh;
        } else if (self.state == NTVRefreshStateReleaseCanRefresh && contentOffsetX >= releaseToRefreshOffsetX) {
            // 转为拖拽可以刷新状态
            self.state = NTVRefreshStatePullCanRefresh;
        }
    } else if (self.state == NTVRefreshStateReleaseCanRefresh && !self.scrollView.isDragging) {
        // 开始刷新
        self.state = NTVRefreshStateRefreshing;
        self.pullingPercent = 1.f;
        
        UIEdgeInsets insets = self.scrollView.contentInset;
        insets.left += self.width;
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
    self.state = NTVRefreshStatePullCanRefresh;
}

- (void)addRefreshHeaderWithClosure:(NTVRefreshClosure)closure {
    self.closure = closure;
}
@end
