//
//  WZMDispatch.h
//  WZMFoundation
//
//  Created by wangzhaomeng on 16/10/8.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZMDispatch : NSObject

/**
 延时调用
 */
void WZMDispatch_after(float delay, dispatch_block_t _Nonnull action);

/**
 异步调用
 */
void WZMDispatch_execute_global_queue(dispatch_block_t _Nonnull action);

/**
 返回主线程
 */
void WZMDispatch_execute_main_queue(dispatch_block_t _Nonnull block);

#pragma mark - GCD_Timer
/**
 在主线程创建timer
 */
void WZMDispatch_create_main_queue_timer(NSString * _Nonnull timerName, NSTimeInterval timeInterval, dispatch_block_t _Nonnull action);

/**
 在分线程创建timer
 */
void WZMDispatch_create_global_queue_timer(NSString * _Nonnull timerName, NSTimeInterval timeInterval, dispatch_block_t _Nonnull action);

/**
 销毁timer
 */
void WZMDispatch_cancelTimer(NSString * _Nonnull timerName);
#pragma mark

@end
