//
//  LLAVPlayerItem.h
//  LLAudioPlayer
//
//  Created by WangZhaomeng on 2017/4/18.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface WZMAudioPlayerItem : AVPlayerItem

@property (nonatomic, weak) id observer;

@end
