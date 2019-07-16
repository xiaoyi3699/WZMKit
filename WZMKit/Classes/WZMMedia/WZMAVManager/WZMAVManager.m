//
//  WZMAVManager.m
//  WZMKit
//
//  Created by WangZhaomeng on 2017/11/10.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMAVManager.h"
#import "WZMLog.h"

@implementation WZMAVManager

//震动
+ (void)shake{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

//播放默认音效
+ (void)playDefaultSoundID:(SystemSoundID)soundID {
    if (soundID <= 0) {
        soundID = 1007;
    }
    AudioServicesPlaySystemSound(soundID);
}

//播放自定义音效
+ (void)playCustomSoundPath:(NSString *)path {
    //组装并播放音效
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
    //声音停止
    //AudioServicesDisposeSystemSoundID(soundID);
}

///提示音
+ (void)playStartSound {
    NSURL *url = [NSURL URLWithString:@"/System/Library/Audio/UISounds/begin_record.caf"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

///提示音
+ (void)playEndSound {
    NSURL *url = [NSURL URLWithString:@"/System/Library/Audio/UISounds/end_record.caf"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

@end
