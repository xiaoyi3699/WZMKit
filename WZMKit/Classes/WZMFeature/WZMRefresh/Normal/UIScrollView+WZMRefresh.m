//
//  UITableView+WZMRefresh.m
//  refresh
//
//  Created by zhaomengWang on 17/3/16.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "UIScrollView+WZMRefresh.h"
#import <objc/runtime.h>

@implementation UIScrollView (WZMRefresh)
static NSString *_aRefreshHeaderKey = @"header";
static NSString *_aRefreshFooterKey = @"footer";

- (void)setWZMRefreshHeader:(WZMRefreshHeaderView *)aRefreshHeader {
    if (aRefreshHeader != self.WZMRefreshHeader) {
        //移除旧的
        [self.WZMRefreshHeader removeFromSuperview];
        //添加新的
        [self insertSubview:aRefreshHeader atIndex:0];
        //设置frame
        aRefreshHeader.frame = CGRectMake(0, -WZMRefreshHeaderHeight, self.bounds.size.width, WZMRefreshHeaderHeight);
        if ([aRefreshHeader respondsToSelector:@selector(createViews)]) {
            [aRefreshHeader createViews];
        }
        // 存储新的
        [self willChangeValueForKey:@"WZMRefreshHeader"]; // KVO
        objc_setAssociatedObject(self, &_aRefreshHeaderKey, aRefreshHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"WZMRefreshHeader"];  // KVO
    }
}

- (WZMRefreshHeaderView *)WZMRefreshHeader {
    return objc_getAssociatedObject(self, &_aRefreshHeaderKey);
}

- (void)setWZMRefreshFooter:(WZMRefreshFooterView *)aRefreshFooter {
    if (aRefreshFooter != self.WZMRefreshFooter) {
        //移除旧的
        [self.WZMRefreshFooter removeFromSuperview];
        //添加新的
        [self insertSubview:aRefreshFooter atIndex:0];
        //设置frame
        aRefreshFooter.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, WZMRefreshFooterHeight);
        if ([aRefreshFooter respondsToSelector:@selector(createViews)]) {
            [aRefreshFooter createViews];
        }
        
        // 存储新的
        [self willChangeValueForKey:@"WZMRefreshFooter"]; // KVO
        objc_setAssociatedObject(self, &_aRefreshFooterKey, aRefreshFooter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"WZMRefreshFooter"];  // KVO
    }
}

- (WZMRefreshFooterView *)WZMRefreshFooter {
    return objc_getAssociatedObject(self, &_aRefreshFooterKey);
}

@end
