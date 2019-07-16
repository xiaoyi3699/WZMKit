//
//  WZMHeaderView_0.m
//  LLFeature
//
//  Created by WangZhaomeng on 2017/11/25.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMHeaderView_0.h"

@implementation WZMHeaderView_0

- (void)updateRefreshState:(WZMRefreshState)refreshState {
    if (refreshState == _refreshState) return;
    
    NSString *refreshText;
    if (refreshState == WZMRefreshStateNormal) {
        refreshText = @"下拉可以刷新";
    }
    else if (refreshState == WZMRefreshStateWiWZMRefresh) {
        refreshText = @"松开立即刷新";
    }
    else if (refreshState == WZMRefreshStateRefreshing) {
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
