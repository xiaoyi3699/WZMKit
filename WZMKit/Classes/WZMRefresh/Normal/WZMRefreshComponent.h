//
//  WZMRefreshComponent.h
//  refresh
//
//  Created by zhaomengWang on 17/3/24.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMRefreshHelper.h"

@interface WZMRefreshComponent : UIView{
    WZMRefreshState _refreshState;
    UILabel *_messageLabel;
    UILabel *_laseTimeLabel;
}

/** 是否处于刷新状态 */
@property (nonatomic, assign, getter=isRefreshing) BOOL refreshing;
/** 回调对象 */
@property (nonatomic, weak) id refreshingTarget;
/** 回调方法 */
@property (nonatomic, assign) SEL refreshingAction;
/** 父控件 */
@property (weak,   nonatomic, readonly) UIScrollView *scrollView;
/** 加载中视图 */
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

/** 开始刷新 */
- (void)beginRefresh;
/** 结束刷新 */
- (void)endRefresh;

/** 普通状态 */
- (void)refreshNormal;
/** 松开就刷新的状态 */
- (void)willRefresh;
/** 没有更多的数据 */
- (void)noMoreData;
/** 刷新结束 */
- (void)endRefresh:(BOOL)more;
/** 初始化 */
- (void)prepare;
/** 创建子视图 */
- (void)createViews;
/** 当scrollView的contentOffset发生改变的时候调用 */
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change;
/** 当scrollView的contentSize发生改变的时候调用 */
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change;
/** 当scrollView的拖拽状态发生改变的时候调用 */
- (void)scrollViewPanStateDidChange:(NSDictionary *)change;
/** 更新刷新控件的状态 */
- (void)updateRefreshState:(WZMRefreshState)refreshState;
/** 移除kvo监听 */
- (void)removeObservers;

@end
