//
//  WZMBaseComponent.m
//  WZMKit
//
//  Created by WangZhaomeng on 2017/11/25.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMBaseComponent.h"
#import "WZMLog.h"

@interface WZMBaseComponent ()

@property (strong, nonatomic) UIPanGestureRecognizer *pan;
@property (nonatomic, assign, getter=isObserving) BOOL observing;

@end

@implementation WZMBaseComponent

#pragma mark - 初始化
- (instancetype)init
{
    if (self = [super init]) {
        [self prepare];
        self.observing = NO;
        // 默认是普通状态
        _refreshState = WZMRefreshStateNormal;
    }
    return self;
}

- (void)prepare
{
    // 基本属性
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor  = [UIColor clearColor];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        
        if ([newSuperview isKindOfClass:[UITableView class]]) {
            //关闭UITableView的高度预估
            ((UITableView *)newSuperview).estimatedRowHeight = 0;
            ((UITableView *)newSuperview).estimatedSectionHeaderHeight = 0;
            ((UITableView *)newSuperview).estimatedSectionFooterHeight = 0;
        }
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        
        // 添加监听
        [self addObservers];
    }
}

- (void)removeFromSuperview {
    [self removeObservers];
    [super removeFromSuperview];
}

#pragma mark - KVO监听
- (void)addObservers
{
    if (self.isObserving) return;
    self.observing = YES;
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:WZMRefreshKeyPathContentOffset options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:WZMRefreshKeyPathContentSize options:options context:nil];
    self.pan = self.scrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:WZMRefreshKeyPathPanState options:options context:nil];
}

- (void)removeObservers
{
    if (self.isObserving == NO) return;
    self.observing = NO;
    [self.superview removeObserver:self forKeyPath:WZMRefreshKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:WZMRefreshKeyPathContentSize];
    [self.pan removeObserver:self forKeyPath:WZMRefreshKeyPathPanState];
    self.pan = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.isRefreshing) return;
    if ([keyPath isEqualToString:WZMRefreshKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    
    if (self.hidden)       return;
    if ([keyPath isEqualToString:WZMRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    }
    else if ([keyPath isEqualToString:WZMRefreshKeyPathPanState]) {
        [self scrollViewPanStateDidChange:change];
    }
}

/** 普通状态 */
- (void)refreshNormal{
    [self updateRefreshState:WZMRefreshStateNormal];
}

/** 松开就刷新的状态 */
- (void)willRefresh {
    [self updateRefreshState:WZMRefreshStateWillRefresh];
}

/** 没有更多的数据 */
- (void)noMoreData {
    [self updateRefreshState:WZMRefreshStateNoMoreData];
}

/** 正在刷新中的状态 */
- (void)beginRefresh{
    self.refreshing = YES;
    [self updateRefreshState:WZMRefreshStateRefreshing];
}

/** 结束刷新 */
- (void)endRefresh:(BOOL)more{
    self.refreshing = NO;
    if (more) {
        [self refreshNormal];
    }
    else {
        [self noMoreData];
    }
}

- (void)endRefresh{};
- (void)createViews{};
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{}
- (void)scrollViewPanStateDidChange:(NSDictionary *)change{}
- (void)updateRefreshState:(WZMRefreshState)refreshState{}

- (void)dealloc {
    [self removeObservers];
    wzm_log(@"%@释放了",NSStringFromClass(self.class));
}

@end
