//
//  WZMEditerModel.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/8/25.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "WZMEditerModel.h"

@interface WZMEditerModel ()

@end

@implementation WZMEditerModel

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        if (path && [[NSFileManager defaultManager] fileExistsAtPath:path]) {
            //视频源
            NSURL *videoUrl = [NSURL fileURLWithPath:path];
            self.asset = [AVAsset assetWithURL:videoUrl];
            self.video = [self.asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
            self.audio = [self.asset tracksWithMediaType:AVMediaTypeAudio].firstObject;
        }
    }
    return self;
}

@end
