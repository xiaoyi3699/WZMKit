//
//  WZMRefreshFooterView.h
//  refresh
//
//  Created by zhaomengWang on 17/3/16.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMRefreshComponent.h"

@interface WZMRefreshFooterView : WZMRefreshComponent

+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@end
