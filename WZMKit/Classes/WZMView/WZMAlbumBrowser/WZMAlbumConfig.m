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
        self.column = 3;
        self.minCount = 0;
        self.maxCount = 9;
        self.title = @"所有照片";
        self.autoDismiss = YES;
        self.allowPreview = YES;
        self.allowShowIndex = YES;
        self.allowShowGIF = YES;
        self.allowShowImage = YES;
        self.allowShowVideo = YES;
        self.allowDragSelect = YES;
        self.allowUseThumbnail = YES;
        self.originalImage = YES;
        self.originalVideo = YES;
        self.imageSize = CGSizeMake(600, 600);
        self.videoPreset = AVAssetExportPreset640x480;
        self.videoFolder = NSTemporaryDirectory();
    }
    return self;
}

- (void)setColumn:(NSInteger)column {
    if (_column == column) return;
    if (column < 1) {
        _column = 3;
        return;
    }
    if (column > 5) {
        _column = 5;
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
