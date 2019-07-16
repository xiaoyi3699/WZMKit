//
//  WZMBaseHeaderView.h
//  WZMKit
//
//  Created by WangZhaomeng on 2017/11/25.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMBaseComponent.h"

@interface WZMBaseHeaderView : WZMBaseComponent

+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

@end
