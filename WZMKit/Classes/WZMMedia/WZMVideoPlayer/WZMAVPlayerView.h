//
//  PlayView.h
//  WZMAVPlayer
//
//  Created by zhaomengWang on 2017/4/13.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZMAVPlayerView : UIView

/**
 播放视屏
 */
- (void)playWith:(NSURL *)url;

/**
 暂停视屏
 */
- (void)pause;

@end
