//
//  WZMNoteConfig.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/12/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMNoteConfig.h"

@implementation WZMNoteConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.text = @"我是一个字幕";
        self.textFrame = CGRectZero;
        self.textFont = (__bridge CFTypeRef)(@"Helvetica");
        self.textFontSize = 15;
        self.textColor = [UIColor redColor];
        self.backgroundColor = [UIColor clearColor];
        self.noteImage = [UIImage wzm_getRoundImageByColor:[UIColor redColor] size:CGSizeMake(5, 5)];
        self.startTime = 0.0;
        self.duration = 0.0;
    }
    return self;
}

@end
