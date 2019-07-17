//
//  LLAVPlayerItem.m
//  LLplayer
//
//  Created by WangZhaomeng on 2017/4/18.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMPlayerItem.h"
#import "WZMLog.h"

@implementation WZMPlayerItem

//实现kvo自动释放
- (void)dealloc {
    if (self.observer) {
        [self removeObserver:self.observer forKeyPath:@"status"];
        [self removeObserver:self.observer forKeyPath:@"loadedTimeRanges"];
    }
    wzm_log(@"%@释放了",NSStringFromClass(self.class));
}

@end
