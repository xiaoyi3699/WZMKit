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

@interface WZMAlbumConfig ()

@property (nonatomic, assign, getter=isOnlyOne) BOOL onlyOne;

@end

@implementation WZMAlbumConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.column = 3;
        self.minCount = 0;
        self.maxCount = 9;
        self.allowEdit = NO;
        self.autoDismiss = YES;
        self.allowPreview = YES;
        self.allowShowIndex = YES;
        self.allowShowLocation = YES;
        self.allowShowGIF = YES;
        self.allowShowImage = YES;
        self.allowShowVideo = YES;
        self.allowDragSelect = YES;
        self.allowUseThumbnail = YES;
        self.originalImage = YES;
        self.originalVideo = YES;
        self.imageSize = CGSizeMake(600, 600);
        self.videoPreset = AVAssetExportPreset1280x720;
        self.videoFolder = NSTemporaryDirectory();
    }
    return self;
}

- (BOOL)isOnlyOne {
    return (self.allowPreview == NO && self.maxCount == 1);
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
