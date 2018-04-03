//
//  NTVNormalRefreshHeader.h
//  NTVRefresh
//
//  Created by 乔冬 on 17/5/26.
//  Copyright © 2017年 XinHuaTV. All rights reserved.
//

#import "NTVBaseRefreshControl.h"

@interface NTVNormalRefreshHeader : NTVBaseRefreshControl
+ (instancetype)header;
- (void)addRefreshHeaderWithClosure:(NTVRefreshClosure)closure;
@end
