//
//  UIScrollView+wzmcate.m
//  WZMKit
//
//  Created by WangZhaomeng on 2018/3/15.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "UIScrollView+wzmcate.h"
#import <objc/runtime.h>

@implementation UIScrollView (wzmcate)
static NSString *_header = @"wzm_header";
static NSString *_footer = @"wzm_footer";

//自定义header和footer
- (void)setWzm_headerView:(UIView *)wzm_headerView {
    if (wzm_headerView != self.wzm_headerView) {
        //移除旧的
        [self.wzm_headerView removeFromSuperview];
        //添加新的
        [self insertSubview:wzm_headerView atIndex:0];
        //设置frame
        wzm_headerView.frame = CGRectMake(0, -wzm_headerView.bounds.size.height, wzm_headerView.bounds.size.width, wzm_headerView.bounds.size.height);
        // 存储新的
        [self willChangeValueForKey:@"wzm_headerView"]; // KVO
        objc_setAssociatedObject(self, &_header, wzm_headerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"wzm_headerView"];  // KVO
        
        self.contentInset = UIEdgeInsetsMake(wzm_headerView.bounds.size.height, 0, 0.0, 0);
        self.contentSize = CGSizeMake(MAX(self.contentSize.width, self.bounds.size.width), MAX(self.contentSize.height, self.bounds.size.height));
    }
}

- (UIView *)wzm_headerView {
    return objc_getAssociatedObject(self, &_header);
}

- (void)setWzm_footerView:(UIView *)wzm_footerView {
    if (wzm_footerView != self.wzm_footerView) {
        //移除旧的
        [self.wzm_footerView removeFromSuperview];
        //添加新的
        [self insertSubview:wzm_footerView atIndex:0];
        //设置frame
        wzm_footerView.frame = CGRectMake(0, -wzm_footerView.bounds.size.height, wzm_footerView.bounds.size.width, wzm_footerView.bounds.size.height);
        // 存储新的
        [self willChangeValueForKey:@"wzm_footerView"]; // KVO
        objc_setAssociatedObject(self, &_footer, wzm_footerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"wzm_footerView"];  // KVO
        
        self.contentInset = UIEdgeInsetsMake(wzm_footerView.bounds.size.height, 0, 0.0, 0);
        self.contentSize = CGSizeMake(MAX(self.contentSize.width, self.bounds.size.width), MAX(self.contentSize.height, self.bounds.size.height));
    }
}

- (UIView *)wzm_footerView {
    return objc_getAssociatedObject(self, &_footer);
}

//滑动
- (void)wzm_scrollsToTopAnimated:(BOOL)animated {
    [self setContentOffset:CGPointMake(0, 0) animated:animated];
}

- (void)wzm_scrollsToBottomAnimated:(BOOL)animated {
    CGFloat offset = self.contentSize.height - self.bounds.size.height;
    if (offset > 0) {
        [self setContentOffset:CGPointMake(0, offset) animated:animated];
    }
}

@end
