//
//  UIScrollView+LLRefresh_0.m
//  LLFeature
//
//  Created by WangZhaomeng on 2017/11/25.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "UIScrollView+LLRefresh_0.h"
#import <objc/runtime.h>

@implementation UIScrollView (LLRefresh_0)

static NSString *_aRefreshHeaderKey = @"header";
static NSString *_aRefreshFooterKey = @"footer";

- (void)setLLRefreshHeader_0:(LLHeaderView_0 *)aRefreshHeader {
    if (aRefreshHeader != self.LLRefreshHeader_0) {
        //移除旧的
        [self.LLRefreshHeader_0 removeFromSuperview];
        //添加新的
        [self insertSubview:aRefreshHeader atIndex:0];
        //设置frame
        aRefreshHeader.frame = CGRectMake(0, -LLRefreshHeaderHeight, self.bounds.size.width, LLRefreshHeaderHeight);
        if ([aRefreshHeader respondsToSelector:@selector(createViews)]) {
            [aRefreshHeader createViews];
        }
        // 存储新的
        [self willChangeValueForKey:@"LLRefreshHeader_0"]; // KVO
        objc_setAssociatedObject(self, &_aRefreshHeaderKey, aRefreshHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"LLRefreshHeader_0"];  // KVO
    }
}

- (LLHeaderView_0 *)LLRefreshHeader_0 {
    return objc_getAssociatedObject(self, &_aRefreshHeaderKey);
}

- (void)setLLRefreshFooter_0:(LLFooterView_0 *)aRefreshFooter {
    if (aRefreshFooter != self.LLRefreshFooter_0) {
        //移除旧的
        [self.LLRefreshFooter_0 removeFromSuperview];
        //添加新的
        [self insertSubview:aRefreshFooter atIndex:0];
        //设置frame
        aRefreshFooter.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, LLRefreshFooterHeight);
        if ([aRefreshFooter respondsToSelector:@selector(createViews)]) {
            [aRefreshFooter createViews];
        }
        
        // 存储新的
        [self willChangeValueForKey:@"LLRefreshFooter_0"]; // KVO
        objc_setAssociatedObject(self, &_aRefreshFooterKey, aRefreshFooter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"LLRefreshFooter_0"];  // KVO
    }
}

- (LLFooterView_0 *)LLRefreshFooter_0 {
    return objc_getAssociatedObject(self, &_aRefreshFooterKey);
}

@end
