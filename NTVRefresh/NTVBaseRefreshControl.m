//
//  NTVBaseRefreshControl.m
//  NTVRefresh
//
//  Created by 乔冬 on 17/5/26.
//  Copyright © 2017年 XinHuaTV. All rights reserved.
//

#import "NTVBaseRefreshControl.h"

@implementation NTVBaseRefreshControl
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.state = NTVRefreshStatePullCanRefresh;
        self.stateLabelHidden = NO;
        
        [self addSubview:_statusLabel];
        [self addSubview:_imageView];
        [self addSubview:_activityView];
        
   
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_statusLabel.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake( 40 ,40));
            make.centerX.equalTo(self);
        }];
        [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_imageView);
        }];
   
    }
    return self;
}


- (void)setTitle:(NSString *)title forState:(NTVRefreshState)state{
    if (title.length == 0) {
        return;
    }
    NSString *linefeedsTitle = [[title copy] insertLinefeeds];
    switch (state) {
        case NTVRefreshStatePullCanRefresh: {
            self.pullCanRefreshText = linefeedsTitle;
            break;
        }
        case NTVRefreshStateReleaseCanRefresh: {
            self.releaseCanRefreshText = linefeedsTitle;
            break;
        }
        case NTVRefreshStateRefreshing: {
             self.refreshingText = linefeedsTitle;
            break;
        }
        case NTVRefreshStateNoMoreData: {
            self.noMoreDataText = linefeedsTitle;
            break;
        }
    }
}
- (void)reloadDataWithState {
    switch (self.state) {
        case NTVRefreshStatePullCanRefresh: {
            self.statusLabel.text = self.pullCanRefreshText;
            break;
        }
        case NTVRefreshStateReleaseCanRefresh: {
            self.statusLabel.text = self.releaseCanRefreshText;
            break;
        }
        case NTVRefreshStateRefreshing: {
            self.statusLabel.text = self.refreshingText;
            break;
        }
        case NTVRefreshStateNoMoreData: {
            self.statusLabel.text = self.noMoreDataText;
            break;
        }
    }
}
-(void)endRefreshing{
    
}
#pragma mark -- setter
-(void)setState:(NTVRefreshState)state{
    _state = state;
    [self reloadDataWithState];
}
- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.statusLabel.textColor = _textColor;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.statusLabel.font = font;
}

- (void)setStateLabelHidden:(BOOL)stateLabelHidden {
    _stateLabelHidden = stateLabelHidden;
    self.statusLabel.hidden = stateLabelHidden;
}
#pragma mark -
#pragma mark - getter methods
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont boldSystemFontOfSize:13];
        _statusLabel.textColor = [UIColor blackColor];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.numberOfLines = 0;
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeCenter;
    }
    return _imageView;
}

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityView;
}




@end
@implementation NSString (NTVRefresh)

- (NSString *)insertLinefeeds {
    NSMutableString *string = [NSMutableString string];
    for (int i = 0; i < self.length; i ++) {
        NSString *str = [self substringWithRange:NSMakeRange(i, 1)];
        [string appendString:str];
        if (i != self.length - 1) { // 最后一位不加 '\n'
            [string appendString:@"\n"];
        }
    }
    return string;
}

@end
