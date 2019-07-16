//
//  LLBaseHeaderView.m
//  LLFeature
//
//  Created by WangZhaomeng on 2017/11/25.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "LLBaseHeaderView.h"
#import <objc/message.h>

// 运行时objc_msgSend
#define LLRefreshMsgSend(...)       ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define LLRefreshMsgTarget(target)  (__bridge void *)(target)
@implementation LLBaseHeaderView

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    LLBaseHeaderView *refreshHeader = [[self alloc] init];
    refreshHeader.refreshingTarget = target;
    refreshHeader.refreshingAction = action;
    return refreshHeader;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGRect rect = self.frame;
    rect.origin.y = -LLRefreshHeaderHeight;
    self.frame = rect;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    if (self.scrollView.contentOffset.y >= 0) return;
    
    if (self.scrollView.contentOffset.y > -LLRefreshHeaderHeight) {
        [self LL_RefreshNormal];
    }
    else {
        [self LL_WillRefresh];
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
    [super scrollViewPanStateDidChange:change];
    if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (self.scrollView.contentOffset.y <= -LLRefreshHeaderHeight) {
            [self LL_BeginRefresh];
        }
    }
    else if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
    }
}

- (void)LL_BeginRefresh {
    if (self.isRefreshing == NO) {
        [super LL_BeginRefresh];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.35 animations:^{
                self.scrollView.contentInset = UIEdgeInsetsMake(LLRefreshHeaderHeight, 0, 0, 0);
            } completion:^(BOOL finished) {
                if ([self.refreshingTarget respondsToSelector:self.refreshingAction]) {
                    LLRefreshMsgSend(LLRefreshMsgTarget(self.refreshingTarget), self.refreshingAction, self);
                }
            }];
        });
    }
}

- (void)LL_EndRefresh:(BOOL)more {
    if (self.isRefreshing) {
        [super LL_EndRefresh:more];
        [[NSNotificationCenter defaultCenter] postNotificationName:LLRefreshMoreData object:@(more)];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.35 animations:^{
                self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }];
        });
    }
}

- (void)LL_EndRefresh {
    if (self.isRefreshing) {
        [super LL_EndRefresh:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:LLRefreshMoreData object:@(YES)];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.35 animations:^{
                self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }];
        });
    }
}

@end
