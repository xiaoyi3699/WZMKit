//
//  WZMRefreshComponent.m
//  refresh
//
//  Created by zhaomengWang on 17/3/24.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMRefreshComponent.h"
#import "WZMRefreshHeaderView.h"
#import "WZMRefreshFooterView.h"

@interface WZMRefreshComponent ()

@property (strong, nonatomic) UIPanGestureRecognizer *pan;

@end

@implementation WZMRefreshComponent

#pragma mark - 初始化
- (instancetype)init
{
    if (self = [super init]) {
        // 准备工作
        [self prepare];
        
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

- (UIImageView *)arrowView {
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] init];
        _arrowView.image = [WZMRefreshHelper arrowImage];
        _arrowView.tintColor = WZM_REFRESH_COLOR;
        if ([self isKindOfClass:[WZMRefreshFooterView class]]) {
            _arrowView.layer.transform = WZM_TRANS_FORM;
        }
        [self addSubview:_arrowView];
    }
    return _arrowView;
}

- (UIActivityIndicatorView *)loadingView {
    if (_loadingView == nil) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView];
    }
    return _loadingView;
}

#pragma mark - KVO监听
- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:WZMRefreshKeyPathContentOffset options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:WZMRefreshKeyPathContentSize options:options context:nil];
    self.pan = self.scrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:WZMRefreshKeyPathPanState options:options context:nil];
}

- (void)removeObservers
{
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
- (void)WZM_RefreshNormal{
    [self updateRefreshState:WZMRefreshStateNormal];
}

/** 松开就刷新的状态 */
- (void)WZM_WiWZMRefresh {
    [self updateRefreshState:WZMRefreshStateWiWZMRefresh];
}

/** 没有更多的数据 */
- (void)WZM_NoMoreData {
    [self updateRefreshState:WZMRefreshStateNoMoreData];
}

/** 正在刷新中的状态 */
- (void)WZM_BeginRefresh{
    self.refreshing = YES;
    [self refreshUI:YES];
    [self updateRefreshState:WZMRefreshStateRefreshing];
}

/** 结束刷新 */
- (void)WZM_EndRefresh:(BOOL)more{
    self.refreshing = NO;
    if (more) {
        [self WZM_RefreshNormal];
    }
    else {
        [self WZM_NoMoreData];
    }
    [self refreshUI:NO];
}

//重置刷新箭头与刷新动画
- (void)refreshUI:(BOOL)begin {
    if (begin) {
        self.arrowView.hidden = YES;
        [self.loadingView startAnimating];
    }
    else {
        if ([self isKindOfClass:[WZMRefreshHeaderView class]]) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [WZMRefreshHelper setRefreshTime:WZMRefreshHeaderTime];
                NSString *value = [WZMRefreshHelper getRefreshTime:WZMRefreshHeaderTime];
                NSInteger w = ceil([value sizeWithAttributes:@{NSFontAttributeName:WZM_TIME_FONT}].width);
                dispatch_async(dispatch_get_main_queue(), ^{
                    _laseTimeLabel.text = value;
                    self.arrowView.frame = CGRectMake((self.bounds.size.width-w)/2-35, (WZMRefreshHeaderHeight-40)/2.0, 15, 40);
                    self.arrowView.layer.transform = CATransform3DIdentity;
                    [self.loadingView stopAnimating];
                    self.loadingView.center = self.arrowView.center;
                });
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSInteger w = ceil([_messageLabel.text sizeWithAttributes:@{NSFontAttributeName:WZM_TIME_FONT}].width);
                self.arrowView.frame = CGRectMake((self.bounds.size.width-w)/2-35, (WZMRefreshFooterHeight-40)/2.0, 15, 40);
                self.arrowView.layer.transform = WZM_TRANS_FORM;
                [self.loadingView stopAnimating];
                self.loadingView.center = self.arrowView.center;
            });
        }
    }
}

- (void)WZM_EndRefresh{};
- (void)createViews{};
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{}
- (void)scrollViewPanStateDidChange:(NSDictionary *)change{}
- (void)updateRefreshState:(WZMRefreshState)refreshState{}

@end
