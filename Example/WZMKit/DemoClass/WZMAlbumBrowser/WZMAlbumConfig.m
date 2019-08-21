//
//  WZMAlbumConfig.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/13.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMAlbumConfig.h"
#import "WZMAlbumHelper.h"
#import <AVFoundation/AVFoundation.h>

@implementation WZMAlbumConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.column = 4;
        self.minCount = 0;
        self.maxCount = 9;
        self.autoDismiss = YES;
        self.allowPreview = YES;
        self.allowShowIndex = YES;
        self.allowShowGIF = NO;
        self.allowShowImage = YES;
        self.allowShowVideo = YES;
        self.originalImage = YES;
        self.originalVideo = YES;
        self.imagePreset = 600;
        self.videoPreset = AVAssetExportPreset640x480;
//        self.videoPath = [WZMAlbumHelper video];
    }
    return self;
}

- (void)setColumn:(NSInteger)column {
    if (_column == column) return;
    if (column < 1 || column > 5) {
        _column = 4;
        return;
    }
    _column = column;
}

- (void)setMaxCount:(NSInteger)maxCount {
    if (maxCount < 0) return;
    if (_maxCount == maxCount) return;
    _maxCount = maxCount;
}

@end
