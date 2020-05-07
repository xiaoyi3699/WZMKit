//
//  WZMNavigationPopProtocol.h
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2017/12/14.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WZMNavigationPopProtocol <NSObject>

@optional
//拦截导航栏返回按钮的点击事件
- (BOOL)wzm_navigationShouldPop;
//拦截自定义的滑动返回事件
- (BOOL)wzm_navigationShouldDrag;

@end
