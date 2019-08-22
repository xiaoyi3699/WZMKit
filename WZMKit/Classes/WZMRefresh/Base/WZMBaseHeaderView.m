//
//  WZMBaseHeaderView.m
//  WZMKit
//
//  Created by WangZhaomeng on 2017/11/25.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMBaseHeaderView.h"
#import <objc/message.h>

// 运行时objc_msgSend
#define WZMRefreshMsgSend(...)       ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define WZMRefreshMsgTarget(target)  (__bridge void *)(target)
@implementation WZMBaseHeaderView

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    WZMBaseHeaderView *refreshHeader = [[self alloc] init];
    refreshHeader.refreshingTarget = target;
    refreshHeader.refreshingAction = action;
    return refreshHeader;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGRect rect = self.frame;
    rect.origin.y = -WZMRefreshHeaderHeight;
    self.frame = rect;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    if (self.scrollView.contentOffset.y >= 0) return;
    
    if (self.scrollView.contentOffset.y > -WZMRefreshHeaderHeight) {
        [self refreshNormal];
    }
    else {
        [self willRefresh];
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
    [super scrollViewPanStateDidChange:change];
    if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (self.scrollView.contentOffset.y <= -WZMRefreshHeaderHeight) {
            [self beginRefresh];
        }
    }
    else if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
    }
}

- (void)beginRefresh {
    if (self.isRefreshing == NO) {
        [super beginRefresh];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.scrollView.contentInset = UIEdgeInsetsMake(WZMRefreshHeaderHeight, 0, 0, 0);
            } completion:^(BOOL finished) {
                if ([self.refreshingTarget respondsToSelector:self.refreshingAction]) {
                    WZMRefreshMsgSend(WZMRefreshMsgTarget(self.refreshingTarget), self.refreshingAction, self);
                }
            }];
        });
    }
}

- (void)endRefresh:(BOOL)more {
    if (self.isRefreshing) {
        [super endRefresh:more];
        [[NSNotificationCenter defaultCenter] postNotificationName:WZMRefreshMoreData object:@(more)];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }];
        });
    }
}

- (void)endRefresh {
    if (self.isRefreshing) {
        [super endRefresh:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:WZMRefreshMoreData object:@(YES)];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }];
        });
    }
}

@end
