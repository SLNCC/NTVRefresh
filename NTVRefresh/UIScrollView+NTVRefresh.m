//
//  UIScrollView+NTVRefresh.m
//  NTVRefresh
//
//  Created by 乔冬 on 17/5/26.
//  Copyright © 2017年 XinHuaTV. All rights reserved.
//

#import "UIScrollView+NTVRefresh.h"
#import <objc/runtime.h>

@interface UIScrollView()
@property (nonatomic, strong) NTVNormalRefreshHeader *header;
@property (nonatomic, strong) NTVNormalRefreshFooter *footer;
@end
@implementation UIScrollView (NTVRefresh)
YYSYNTH_DYNAMIC_PROPERTY_OBJECT(header, setHeader, RETAIN_NONATOMIC, NTVNormalRefreshHeader *)
YYSYNTH_DYNAMIC_PROPERTY_OBJECT(footer, setFooter, RETAIN_NONATOMIC, NTVNormalRefreshFooter *)

- (void)addRefreshHeaderWithClosure:(NTVRefreshClosure)closure{
    if (!self.header ) {
        self.header = [NTVNormalRefreshHeader header];
        [self.header setTitle:@"右拉即可刷新" forState:NTVRefreshStatePullCanRefresh];
        [self.header setTitle:@"松开即可刷新" forState:NTVRefreshStateReleaseCanRefresh];
        [self.header setTitle:@"正在为您刷新" forState:NTVRefreshStateRefreshing];
        [self addSubview:self.header];
        [self.header addRefreshHeaderWithClosure:closure];
    }
}

- (void)addRefreshFooterWithClosure:(NTVRefreshClosure)closure{
    if (!self.footer ) {
        self.footer = [NTVNormalRefreshFooter footer];
        [self.footer setTitle:@"左拉即可加载" forState:NTVRefreshStatePullCanRefresh];
        [self.footer setTitle:@"松开即可加载" forState:NTVRefreshStateReleaseCanRefresh];
        [self.footer setTitle:@"正在为您加载" forState:NTVRefreshStateRefreshing];
        [self.footer setTitle:@"已经是最后一页" forState:NTVRefreshStateNoMoreData];
        [self addSubview:self.footer];
        [self.footer addRefreshFooterWithClosure:closure];
    }
}
- (void)endRefreshing {
    if (self.header) { [self.header endRefreshing]; }
    if (self.footer) { [self.footer endRefreshing]; }

}

- (void)setIsLastPage:(BOOL)isLastPage {
    if (self.footer) {
        self.footer.isLastPage = isLastPage;
        return;
    }
}
- (BOOL)isLastPage {

    return self.footer.isLastPage;
}

- (void)setRefreshHeaderFont:(UIFont *)refreshHeaderFont {
    if (self.header) {
        self.header.font = refreshHeaderFont;
    }
}

- (UIFont *)refreshHeaderFont {
    if (self.header) {
        return self.header.font;
    }

    return [UIFont systemFontOfSize:13];
}

- (void)setRefreshHeaderTextColor:(UIColor *)refreshHeaderTextColor {
    if (self.header) {
        self.header.textColor = refreshHeaderTextColor;
    }

}

- (UIColor *)refreshHeaderTextColor {
    if (self.header) {
        return self.header.textColor;
    }

    return [UIColor clearColor];
}
- (void)setRefreshHeaderBackgroundColor:(UIColor *)refreshHeaderBackgroundColor {
    if (self.header) {
        self.header.backgroundColor = refreshHeaderBackgroundColor;
    }

}

- (UIColor *)refreshHeaderBackgroundColor {
    if (self.header) {
        return self.header.backgroundColor;
    }
    return [UIColor clearColor];
}

- (void)setRefreshFooterBackgroundColor:(UIColor *)refreshFooterBackgroundColor {
    if (self.footer) {
        self.footer.backgroundColor = refreshFooterBackgroundColor;
    }
}
- (UIColor *)refreshFooterBackgroundColor {
    if (self.footer) {
        return self.footer.backgroundColor;
    }

    return [UIColor clearColor];
}

- (void)setRefreshFooterFont:(UIFont *)refreshFooterFont {
    if (self.footer) {
        self.footer.font = refreshFooterFont;
    }

}
- (UIFont *)refreshFooterFont {
    if (self.footer) {
        return self.footer.font;
    }
    return [UIFont systemFontOfSize:13];
}

- (void)setRefreshFooterTextColor:(UIColor *)refreshFooterTextColor {
    if (self.footer) {
        self.footer.textColor = refreshFooterTextColor;
    }
}
- (UIColor *)refreshFooterTextColor {
    if (self.footer) {
        return self.footer.textColor;
    }
    return [UIColor clearColor];
}
@end
