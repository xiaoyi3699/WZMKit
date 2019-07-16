//
//  UITableView+WZMRefresh.h
//  refresh
//
//  Created by zhaomengWang on 17/3/16.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMRefreshHeaderView.h"
#import "WZMRefreshFooterView.h"

@interface UIScrollView (WZMRefresh)

- (void)setWZMRefreshHeader:(WZMRefreshHeaderView *)aRefreshHeader;
- (WZMRefreshHeaderView *)WZMRefreshHeader;

- (void)setWZMRefreshFooter:(WZMRefreshFooterView *)aRefreshFooter;
- (WZMRefreshFooterView *)WZMRefreshFooter;

@end
