//
//  UIView+NTVFrame.h
//  NTVRefresh
//
//  Created by 乔冬 on 17/5/26.
//  Copyright © 2017年 XinHuaTV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NTVFrame)
@property (nonatomic, assign) CGFloat top;

@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) CGFloat left;

@property (nonatomic, assign) CGFloat right;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGPoint origin;
@end
