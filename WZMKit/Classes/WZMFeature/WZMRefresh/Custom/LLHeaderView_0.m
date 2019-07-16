//
//  LLHeaderView_0.m
//  LLFeature
//
//  Created by WangZhaomeng on 2017/11/25.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "LLHeaderView_0.h"

@implementation LLHeaderView_0

- (void)updateRefreshState:(LLRefreshState)refreshState {
    if (refreshState == _refreshState) return;
    
    NSString *refreshText;
    if (refreshState == LLRefreshStateNormal) {
        refreshText = @"下拉可以刷新";
    }
    else if (refreshState == LLRefreshStateWillRefresh) {
        refreshText = @"松开立即刷新";
    }
    else if (refreshState == LLRefreshStateRefreshing) {
        refreshText = @"正在刷新数据...";
    }
    else {
        refreshText = @"没有更多数据了";
    }
    _refreshState = refreshState;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    if (self.scrollView.contentOffset.y >= 0) return;
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
    [super scrollViewPanStateDidChange:change];
    if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
    }
    else if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
    }
}

@end
