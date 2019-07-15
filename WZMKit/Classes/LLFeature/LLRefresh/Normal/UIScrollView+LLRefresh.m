//
//  UITableView+LLRefresh.m
//  refresh
//
//  Created by zhaomengWang on 17/3/16.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "UIScrollView+LLRefresh.h"
#import <objc/runtime.h>

@implementation UIScrollView (LLRefresh)
static NSString *_aRefreshHeaderKey = @"header";
static NSString *_aRefreshFooterKey = @"footer";

- (void)setLLRefreshHeader:(LLRefreshHeaderView *)aRefreshHeader {
    if (aRefreshHeader != self.LLRefreshHeader) {
        //移除旧的
        [self.LLRefreshHeader removeFromSuperview];
        //添加新的
        [self insertSubview:aRefreshHeader atIndex:0];
        //设置frame
        aRefreshHeader.frame = CGRectMake(0, -LLRefreshHeaderHeight, self.bounds.size.width, LLRefreshHeaderHeight);
        if ([aRefreshHeader respondsToSelector:@selector(createViews)]) {
            [aRefreshHeader createViews];
        }
        // 存储新的
        [self willChangeValueForKey:@"LLRefreshHeader"]; // KVO
        objc_setAssociatedObject(self, &_aRefreshHeaderKey, aRefreshHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"LLRefreshHeader"];  // KVO
    }
}

- (LLRefreshHeaderView *)LLRefreshHeader {
    return objc_getAssociatedObject(self, &_aRefreshHeaderKey);
}

- (void)setLLRefreshFooter:(LLRefreshFooterView *)aRefreshFooter {
    if (aRefreshFooter != self.LLRefreshFooter) {
        //移除旧的
        [self.LLRefreshFooter removeFromSuperview];
        //添加新的
        [self insertSubview:aRefreshFooter atIndex:0];
        //设置frame
        aRefreshFooter.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, LLRefreshFooterHeight);
        if ([aRefreshFooter respondsToSelector:@selector(createViews)]) {
            [aRefreshFooter createViews];
        }
        
        // 存储新的
        [self willChangeValueForKey:@"LLRefreshFooter"]; // KVO
        objc_setAssociatedObject(self, &_aRefreshFooterKey, aRefreshFooter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"LLRefreshFooter"];  // KVO
    }
}

- (LLRefreshFooterView *)LLRefreshFooter {
    return objc_getAssociatedObject(self, &_aRefreshFooterKey);
}

@end
