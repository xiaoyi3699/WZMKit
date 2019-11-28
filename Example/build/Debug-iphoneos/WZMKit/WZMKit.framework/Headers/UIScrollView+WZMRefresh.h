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

- (void)setWzm_header:(WZMRefreshHeaderView *)wzm_header;
- (WZMRefreshHeaderView *)wzm_header;

- (void)setWzm_footer:(WZMRefreshFooterView *)wzm_footer;
- (WZMRefreshFooterView *)wzm_footer;

@end
