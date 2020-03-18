//
//  LLAVPlayerItem.h
//  LLplayer
//
//  Created by WangZhaomeng on 2017/4/18.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

extern NSString *const WZMPlayerStatus;
extern NSString *const WZMPlayerLoadedTimeRanges;
extern NSString *const WZMPlayerPlaybackBufferEmpty;
extern NSString *const WZMPlayerPlaybackLikelyToKeepUp;
@interface WZMPlayerItem : AVPlayerItem

- (void)addItemObserver:(id)observer;

@end
