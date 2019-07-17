//
//  WZMRefreshHeaderView.m
//  refresh
//
//  Created by zhaomengWang on 17/3/16.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMRefreshHeaderView.h"
#import <objc/message.h>

// 运行时objc_msgSend
#define WZMRefreshMsgSend(...)       ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define WZMRefreshMsgTarget(target)  (__bridge void *)(target)
@implementation WZMRefreshHeaderView

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    WZMRefreshHeaderView *refreshHeader = [[self alloc] init];
    refreshHeader.refreshingTarget = target;
    refreshHeader.refreshingAction = action;
    return refreshHeader;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.frame;
    rect.origin.y = -WZMRefreshHeaderHeight;
    self.frame = rect;
    
    NSInteger w = ceil([_laseTimeLabel.text sizeWithAttributes:@{NSFontAttributeName:WZM_TIME_FONT}].width);
    self.arrowView.frame = CGRectMake((self.bounds.size.width-w)/2-35, (WZMRefreshHeaderHeight-40)/2.0, 15, 40);
    
    self.loadingView.center = self.arrowView.center;
    self.loadingView.color = WZM_REFRESH_COLOR;
}

- (void)createViews {
    [super createViews];
    CGFloat labelH = (WZMRefreshHeaderHeight-10)/2;
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.bounds.size.width, labelH)];
    _messageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _messageLabel.font = WZM_REFRESH_FONT;
    _messageLabel.text = @"下拉可以刷新";
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.textColor = WZM_REFRESH_COLOR;
    [self addSubview:_messageLabel];
    
    NSString *lastTime = [WZMRefreshHelper getRefreshTime:WZMRefreshHeaderTime];
    _laseTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_messageLabel.frame), self.bounds.size.width, labelH)];
    _laseTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _laseTimeLabel.font = WZM_TIME_FONT;
    _laseTimeLabel.text = lastTime;
    _laseTimeLabel.textAlignment = NSTextAlignmentCenter;
    _laseTimeLabel.textColor = WZM_TIME_COLOR;
    [self addSubview:_laseTimeLabel];
}

- (void)updateRefreshState:(WZMRefreshState)refreshState {
    if (refreshState == _refreshState) return;
    
    NSString *refreshText;
    if (refreshState == WZMRefreshStateNormal) {
        refreshText = @"下拉可以刷新";
    }
    else if (refreshState == WZMRefreshStateWillRefresh) {
        refreshText = @"松开立即刷新";
    }
    else if (refreshState == WZMRefreshStateRefreshing) {
        refreshText = @"正在刷新数据...";
    }
    else {
        refreshText = @"没有更多数据了";
    }
    _messageLabel.text = refreshText;
    _refreshState = refreshState;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    if (self.scrollView.contentOffset.y >= 0) return;
    
    CATransform3D transform3D = CATransform3DIdentity;
    
    if (self.scrollView.contentOffset.y > -WZMRefreshHeaderHeight) {
        [self refreshNormal];
    }
    else {
        [self willRefresh];
        transform3D = WZM_TRANS_FORM;
    }
    [UIView animateWithDuration:.3 animations:^{
        self.arrowView.layer.transform = transform3D;
    }];
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
    [super scrollViewPanStateDidChange:change];
    if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (self.scrollView.contentOffset.y <= -WZMRefreshHeaderHeight) {
            [self beginRefresh];
        }
    }
    else if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.arrowView.hidden = NO;
    }
}

- (void)beginRefresh {
    if (self.isRefreshing == NO) {
        [super beginRefresh];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.35 animations:^{
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
            [UIView animateWithDuration:.35 animations:^{
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
            [UIView animateWithDuration:.35 animations:^{
                self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }];
        });
    }
}

@end
