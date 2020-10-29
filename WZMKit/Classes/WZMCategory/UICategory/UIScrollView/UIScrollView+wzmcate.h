//
//  UIScrollView+wzmcate.h
//  WZMKit
//
//  Created by WangZhaomeng on 2018/3/15.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (wzmcate)

///自定义header和footer
- (void)setWzm_headerView:(UIView *)wzm_headerView;
- (UIView *)wzm_headerView;

- (void)setWzm_footerView:(UIView *)wzm_footerView;
- (UIView *)wzm_footerView;

///滑动
- (void)wzm_scrollsToTopAnimated:(BOOL)animated;
- (void)wzm_scrollsToBottomAnimated:(BOOL)animated;

@end
