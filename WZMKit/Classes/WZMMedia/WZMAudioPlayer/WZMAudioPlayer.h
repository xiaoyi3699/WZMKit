//
//  WZMAudioPlayer.h
//  LLFoundation
//
//  Created by WangZhaomeng on 2017/4/16.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WZMAudioPlayerDelegate;

@interface WZMAudioPlayer : NSObject

@property (nonatomic, readonly, assign) CGFloat   playProgress; //播放进度
@property (nonatomic, readonly, assign) CGFloat   loadProgress; //缓冲进度
@property (nonatomic, readonly, assign) CGFloat   duration;     //音频总时长
@property (nonatomic, readonly, assign) NSInteger currentTime;  //当前播放时间
@property (nonatomic, readonly, assign) NSInteger totalTime;    //播放总时长

@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign, getter=isPlaying) BOOL playing;
@property (nonatomic, assign, getter=isBackground) BOOL background;
@property (nonatomic, weak) id<WZMAudioPlayerDelegate> delegate;

@end

@protocol WZMAudioPlayerDelegate <NSObject>

@optional
- (void)audioPlayerLoadSuccess:(WZMAudioPlayer *)audioPlayer;
- (void)audioPlayerLoadFailed:(WZMAudioPlayer *)audioPlayer error:(NSString *)error;
- (void)audioPlayerLoadProgress:(WZMAudioPlayer *)audioPlayer;
- (void)audioPlayerBeginPlaying:(WZMAudioPlayer *)audioPlayer;
- (void)audioPlayerPlaying:(WZMAudioPlayer *)audioPlayer;
- (void)audioPlayerEndPlaying:(WZMAudioPlayer *)audioPlayer;
- (void)audioPlayerChangeStatus:(WZMAudioPlayer *)audioPlayer;

@end