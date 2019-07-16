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

static NSString *_aRefreshHeaderKey = @"header";
static NSString *_aRefreshFooterKey = @"footer";

- (void)setWZMRefreshHeader_0:(WZMHeaderView_0 *)aRefreshHeader {
    if (aRefreshHeader != self.WZMRefreshHeader_0) {
        //移除旧的
        [self.WZMRefreshHeader_0 removeFromSuperview];
        //添加新的
        [self insertSubview:aRefreshHeader atIndex:0];
        //设置frame
        aRefreshHeader.frame = CGRectMake(0, -WZMRefreshHeaderHeight, self.bounds.size.width, WZMRefreshHeaderHeight);
        if ([aRefreshHeader respondsToSelector:@selector(createViews)]) {
            [aRefreshHeader createViews];
        }
        // 存储新的
        [self willChangeValueForKey:@"WZMRefreshHeader_0"]; // KVO
        objc_setAssociatedObject(self, &_aRefreshHeaderKey, aRefreshHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"WZMRefreshHeader_0"];  // KVO
    }
}

- (WZMHeaderView_0 *)WZMRefreshHeader_0 {
    return objc_getAssociatedObject(self, &_aRefreshHeaderKey);
}

- (void)setWZMRefreshFooter_0:(WZMFooterView_0 *)aRefreshFooter {
    if (aRefreshFooter != self.WZMRefreshFooter_0) {
        //移除旧的
        [self.WZMRefreshFooter_0 removeFromSuperview];
        //添加新的
        [self insertSubview:aRefreshFooter atIndex:0];
        //设置frame
        aRefreshFooter.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, WZMRefreshFooterHeight);
        if ([aRefreshFooter respondsToSelector:@selector(createViews)]) {
            [aRefreshFooter createViews];
        }
        
        // 存储新的
        [self willChangeValueForKey:@"WZMRefreshFooter_0"]; // KVO
        objc_setAssociatedObject(self, &_aRefreshFooterKey, aRefreshFooter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"WZMRefreshFooter_0"];  // KVO
    }
}

- (WZMFooterView_0 *)WZMRefreshFooter_0 {
    return objc_getAssociatedObject(self, &_aRefreshFooterKey);
}

@end
