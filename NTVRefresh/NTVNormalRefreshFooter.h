//
//  NTVNormalRefreshFooter.h
//  NTVRefresh
//
//  Created by 乔冬 on 17/5/26.
//  Copyright © 2017年 XinHuaTV. All rights reserved.
//

#import "NTVBaseRefreshControl.h"

@interface NTVNormalRefreshFooter : NTVBaseRefreshControl
+ (instancetype)footer;

// 如果是最后一页，则禁止刷新动作
@property (nonatomic, assign) BOOL isLastPage;

- (void)addRefreshFooterWithClosure:(NTVRefreshClosure)closure;
@end
