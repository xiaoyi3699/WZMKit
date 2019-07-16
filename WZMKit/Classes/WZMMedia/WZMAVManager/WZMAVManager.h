//
//  WZMAVManager.h
//  WZMKit
//
//  Created by WangZhaomeng on 2017/11/10.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface WZMAVManager : NSObject

///震动
+ (void)shake;

///播放默认音效
+ (void)playDefaultSoundID:(SystemSoundID)soundID;

///播放自定义音效
+ (void)playCustomSoundPath:(NSString *)path;

///提示音
+ (void)playStartSound;

///提示音
+ (void)playEndSound;

@end
