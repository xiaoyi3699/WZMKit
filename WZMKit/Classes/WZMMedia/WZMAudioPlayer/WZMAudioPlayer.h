//
//  WZMAudioPlayer.h
//  LLFoundation
//
//  Created by WangZhaomeng on 2017/4/16.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZMAudioPlayer : NSObject


@property (nonatomic, readonly, assign) CGFloat   progress;                //播放进度
@property (nonatomic, readonly, assign) CGFloat   duration;                //音频总时长
@property (nonatomic, readonly, assign) NSInteger currentTime;             //当前播放时间
@property (nonatomic, readonly, assign) NSInteger totalTime;               //播放总时长

@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign, getter=isPlaying) BOOL playing;
@property (nonatomic, assign, getter=isBackground) BOOL background;

@end
