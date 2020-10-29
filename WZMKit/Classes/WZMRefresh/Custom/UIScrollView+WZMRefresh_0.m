//
//  UIScrollView+WZMRefresh_0.m
//  WZMKit
//
//  Created by WangZhaomeng on 2017/11/25.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "UIScrollView+WZMRefresh_0.h"
#import <objc/runtime.h>

@implementation UIScrollView (WZMRefresh_0)

static NSString *_headerKey = @"header";
static NSString *_footerKey = @"footer";

- (void)setWzm_header_0:(WZMHeaderView_0 *)wzm_header_0 {
    if (wzm_header_0 != self.wzm_header_0) {
        //移除旧的
        [self.wzm_header_0 removeFromSuperview];
        //添加新的
        [self insertSubview:wzm_header_0 atIndex:0];
        //设置frame
        wzm_header_0.frame = CGRectMake(0, -WZMRefreshHeaderHeight, self.bounds.size.width, WZMRefreshHeaderHeight);
        if ([wzm_header_0 respondsToSelector:@selector(createViews)]) {
            [wzm_header_0 createViews];
        }
        // 存储新的
        [self willChangeValueForKey:@"wzm_header_0"]; // KVO
        objc_setAssociatedObject(self, &_headerKey, wzm_header_0, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"wzm_header_0"];  // KVO
    }
}

- (WZMHeaderView_0 *)wzm_header_0 {
    return objc_getAssociatedObject(self, &_headerKey);
}

- (void)setWzm_footer_0:(WZMFooterView_0 *)wzm_footer_0 {
    if (wzm_footer_0 != self.wzm_footer_0) {
        //移除旧的
        [self.wzm_footer_0 removeFromSuperview];
        //添加新的
        [self insertSubview:wzm_footer_0 atIndex:0];
        //设置frame
        wzm_footer_0.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, WZMRefreshFooterHeight);
        if ([wzm_footer_0 respondsToSelector:@selector(createViews)]) {
            [wzm_footer_0 createViews];
        }
        
        // 存储新的
        [self willChangeValueForKey:@"wzm_footer_0"]; // KVO
        objc_setAssociatedObject(self, &_footerKey, wzm_footer_0, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"wzm_footer_0"];  // KVO
    }
}

- (WZMFooterView_0 *)wzm_footer_0 {
    return objc_getAssociatedObject(self, &_footerKey);
}

@end
