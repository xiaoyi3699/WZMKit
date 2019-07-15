//
//  LLDispatch.m
//  LLFoundation
//
//  Created by wangzhaomeng on 16/10/8.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLDispatch.h"

@implementation LLDispatch

NSMutableDictionary *LLDispatch_timerContainer(){
    static NSMutableDictionary *timerContainer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timerContainer = [[NSMutableDictionary alloc] initWithCapacity:0];
    });
    return timerContainer;
}

void LLDispatch_after(float delay,dispatch_block_t action){
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay*NSEC_PER_SEC)),
                   dispatch_get_main_queue(),
                   action);
}

void LLDispatch_execute_global_queue(dispatch_block_t action){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), action);
}

void LLDispatch_execute_main_queue(dispatch_block_t block){
    dispatch_async(dispatch_get_main_queue(), block);
}

#pragma mark - GCD_Timer
void LLDispatch_create_main_queue_timer(NSString *timerName, NSTimeInterval timeInterval, dispatch_block_t action){
    if (timerName) {
        dispatch_source_t timer = [LLDispatch_timerContainer() objectForKey:timerName];
        if (timer) {
            dispatch_source_cancel(timer);
        }
        dispatch_queue_t queue = dispatch_get_main_queue();
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        [LLDispatch_timerContainer() setValue:timer forKey:timerName];
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 0), timeInterval*NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(timer, action);
        dispatch_resume(timer);
    }
}

void LLDispatch_create_global_queue_timer(NSString *timerName, NSTimeInterval timeInterval, dispatch_block_t action){
    if (timerName) {
        dispatch_source_t timer = [LLDispatch_timerContainer() objectForKey:timerName];
        if (timer) {
            dispatch_source_cancel(timer);
        }
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        [LLDispatch_timerContainer() setValue:timer forKey:timerName];
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 0), timeInterval*NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(timer, action);
        dispatch_resume(timer);
    }
}

void LLDispatch_cancelTimer(NSString *timerName){
    dispatch_source_t timer = [LLDispatch_timerContainer() valueForKey:timerName];
    if (timer) {
        [LLDispatch_timerContainer() removeObjectForKey:timerName];
        dispatch_source_cancel(timer);
    }
}
#pragma mark

@end
