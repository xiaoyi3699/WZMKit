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
static NSString *_headerKey = @"header";
static NSString *_footerKey = @"footer";

- (void)setWzm_header:(WZMRefreshHeaderView *)wzm_header {
    if (wzm_header != self.wzm_header) {
        //移除旧的
        [self.wzm_header removeFromSuperview];
        //添加新的
        [self insertSubview:wzm_header atIndex:0];
        //设置frame
        wzm_header.frame = CGRectMake(0, -WZMRefreshHeaderHeight, self.bounds.size.width, WZMRefreshHeaderHeight);
        if ([wzm_header respondsToSelector:@selector(createViews)]) {
            [wzm_header createViews];
        }
        // 存储新的
        [self willChangeValueForKey:@"WZMRefreshHeader"]; // KVO
        objc_setAssociatedObject(self, &_headerKey, wzm_header, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"WZMRefreshHeader"];  // KVO
    }
}

- (WZMRefreshHeaderView *)wzm_header {
    return objc_getAssociatedObject(self, &_headerKey);
}

- (void)setWzm_footer:(WZMRefreshFooterView *)wzm_footer {
    if (wzm_footer != self.wzm_footer) {
        //移除旧的
        [self.wzm_footer removeFromSuperview];
        //添加新的
        [self insertSubview:wzm_footer atIndex:0];
        //设置frame
        wzm_footer.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, WZMRefreshFooterHeight);
        if ([wzm_footer respondsToSelector:@selector(createViews)]) {
            [wzm_footer createViews];
        }
        
        // 存储新的
        [self willChangeValueForKey:@"WZMRefreshFooter"]; // KVO
        objc_setAssociatedObject(self, &_footerKey, wzm_footer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"WZMRefreshFooter"];  // KVO
    }
}

- (WZMRefreshFooterView *)wzm_footer {
    return objc_getAssociatedObject(self, &_footerKey);
}

@end
