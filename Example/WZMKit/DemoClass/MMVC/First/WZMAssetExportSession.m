//
//  WZMAssetExportSession.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/9/11.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "WZMAssetExportSession.h"

@interface WZMAssetExportSession ()
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation WZMAssetExportSession

- (instancetype)initWithAsset:(AVAsset *)asset presetName:(NSString *)presetName {
    self = [super initWithAsset:asset presetName:presetName];
    if (self) {
        [self addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)startExport {
    [self exportAsynchronouslyWithCompletionHandler:^{}];
}

///ObserveValue && DisplayLinkEvent
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        NSNumber *value = change[NSKeyValueChangeNewKey];
        AVAssetExportSessionStatus status = value.integerValue;
        if (status == AVAssetExportSessionStatusExporting) {
            [self linkFire];
        } else if (status == AVAssetExportSessionStatusCompleted || status == AVAssetExportSessionStatusFailed || status == AVAssetExportSessionStatusCancelled) {
            [self linkInvalidate];
            if (status == AVAssetExportSessionStatusCompleted) {
                if ([self.delegate respondsToSelector:@selector(assetExportSessionExportSuccess:)]) {
                    [self.delegate assetExportSessionExportSuccess:self];
                }
            }
            else {
                if ([self.delegate respondsToSelector:@selector(assetExportSessionExportFail:)]) {
                    [self.delegate assetExportSessionExportFail:self];
                }
            }
        }
    }
}

//开启定时器
- (void)linkFire {
    if (self.displayLink == nil) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(linkRun:)];
        [self.displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
    }
}

//关闭定时器
- (void)linkInvalidate {
    if (self.displayLink) {
        [self.displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)linkRun:(CADisplayLink *)link {
    if (link.isPaused) return;
    if ([self.delegate respondsToSelector:@selector(assetExportSessionExporting:)]) {
        [self.delegate assetExportSessionExporting:self];
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"status"];
    NSLog(@"====shifangle0000");
}

@end
