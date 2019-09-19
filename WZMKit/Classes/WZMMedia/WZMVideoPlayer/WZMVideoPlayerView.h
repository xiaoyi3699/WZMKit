//
//  PlayView.h
//  WZMAVPlayer
//
//  Created by zhaomengWang on 2017/4/13.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZMAlbumModel;

@interface WZMVideoPlayerView : UIView

@property (nonatomic, assign) CGFloat volume;
@property (nonatomic, assign, getter=isAllowPlay) BOOL allowPlay;
@property (nonatomic, assign, getter=isAllowTouch) BOOL allowTouch;

/**
 播放视屏
 */
- (void)playWithUrl:(NSURL *)url;
- (void)playWithAlbumModel:(WZMAlbumModel *)model;

///播放
- (void)play;
///暂停
- (void)pause;
///停止
- (void)stop;

@end
