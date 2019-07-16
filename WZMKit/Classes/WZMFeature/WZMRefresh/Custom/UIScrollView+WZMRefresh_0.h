//
//  UIScrollView+WZMRefresh_0.h
//  WZMFeature
//
//  Created by WangZhaomeng on 2017/11/25.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMHeaderView_0.h"
#import "WZMFooterView_0.h"

@interface UIScrollView (WZMRefresh_0)

- (void)setWZMRefreshHeader_0:(WZMHeaderView_0 *)aRefreshHeader;
- (WZMHeaderView_0 *)WZMRefreshHeader_0;

- (void)setWZMRefreshFooter_0:(WZMFooterView_0 *)aRefreshFooter;
- (WZMFooterView_0 *)WZMRefreshFooter_0;

@end
