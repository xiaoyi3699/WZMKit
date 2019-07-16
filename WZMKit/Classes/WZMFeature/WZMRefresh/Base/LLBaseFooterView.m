//
//  LLBaseFooterView.m
//  LLFeature
//
//  Created by WangZhaomeng on 2017/11/25.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "LLBaseFooterView.h"
#import <objc/message.h>

// 运行时objc_msgSend
#define LLRefreshMsgSend(...)       ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define LLRefreshMsgTarget(target)  (__bridge void *)(target)
@implementation LLBaseFooterView {
    CGFloat _contentOffsetY;
    CGFloat _lastContentHeight;
}

+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    LLBaseFooterView *refreshFooter = [[self alloc] init];
    refreshFooter.refreshingTarget = target;
    refreshFooter.refreshingAction = action;
    [[NSNotificationCenter defaultCenter] addObserver:refreshFooter selector:@selector(refreshMoreData:) name:LLRefreshMoreData object:nil];
    return refreshFooter;
}

- (void)refreshMoreData:(NSNotification *)notification {
    
    BOOL moreData = [notification.object boolValue];
    if (moreData) {
        [self LL_RefreshNormal];
    }
    else {
        [self LL_NoMoreData];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.scrollView.contentSize.height > self.scrollView.bounds.size.height) {
        _contentOffsetY = self.scrollView.contentSize.height-self.scrollView.bounds.size.height;
    }
    else {
        _contentOffsetY = 0.0;
    }
    CGRect frame = self.frame;
    frame.origin.y = self.scrollView.bounds.size.height+_contentOffsetY;
    self.frame = frame;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    if (self.scrollView.contentOffset.y <= 0) return;
    
    if (_refreshState == LLRefreshStateNoMoreData) {
        //没有更多数据
    }
    else {
        if (self.scrollView.contentOffset.y < LLRefreshFooterHeight+_contentOffsetY) {
            [self LL_RefreshNormal];
        }
        else {
            [self LL_WillRefresh];
        }
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
    
    if (self.scrollView.contentSize.height > self.scrollView.bounds.size.height) {
        _contentOffsetY = self.scrollView.contentSize.height-self.scrollView.bounds.size.height;
    }
    else {
        _contentOffsetY = 0.0;
    }
    CGRect frame = self.frame;
    frame.origin.y = self.scrollView.bounds.size.height+_contentOffsetY;
    self.frame = frame;
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
    [super scrollViewPanStateDidChange:change];
    if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (self.scrollView.contentOffset.y >= LLRefreshFooterHeight+_contentOffsetY) {
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
                self.scrollView.contentInset = UIEdgeInsetsMake(-LLRefreshFooterHeight-_contentOffsetY, 0, 0, 0);
                _lastContentHeight = self.scrollView.contentSize.height;
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
        dispatch_async(dispatch_get_main_queue(), ^{
            if (more == NO) {
                [UIView animateWithDuration:.35 animations:^{
                    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                }];
            }
            else if (_contentOffsetY == 0) {
                
                if (self.scrollView.contentSize.height >= self.scrollView.bounds.size.height) {
                    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                }
                else {
                    [UIView animateWithDuration:.35 animations:^{
                        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                    }];
                }
            }
            else {
                //[UIView animateWithDuration:.35 animations:^{
                self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                self.scrollView.contentOffset = CGPointMake(0, _lastContentHeight-self.scrollView.bounds.size.height+LLRefreshFooterHeight);
                //}];
            }
        });
    }
}

- (void)LL_EndRefresh {
    if (self.isRefreshing) {
        BOOL more = !(_lastContentHeight == self.scrollView.contentSize.height);
        [super LL_EndRefresh:more];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (more == NO) {
                [UIView animateWithDuration:.35 animations:^{
                    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                }];
            }
            else if (_contentOffsetY == 0) {
                
                if (self.scrollView.contentSize.height >= self.scrollView.bounds.size.height) {
                    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                }
                else {
                    [UIView animateWithDuration:.35 animations:^{
                        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                    }];
                }
            }
            else {
                //[UIView animateWithDuration:.35 animations:^{
                self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                self.scrollView.contentOffset = CGPointMake(0, _lastContentHeight-self.scrollView.bounds.size.height+LLRefreshFooterHeight);
                //}];
            }
        });
    }
}

@end
