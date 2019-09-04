//
//  WZMGifImageView.m
//  WZMGifView
//
//  Created by WangZhaomeng on 2017/6/14.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMGifImageView.h"
#import <ImageIO/ImageIO.h>
#import "WZMLogPrinter.h"

@interface WZMGifImageView ()

@property (nonatomic, assign) NSInteger imageIndex;
@property (nonatomic, assign) NSUInteger lastCount;
@property (nonatomic, assign, getter=isPlaying) BOOL playing;
@property (nonatomic, assign, getter=isSourceChange) BOOL sourceChange;

@end

@implementation WZMGifImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configSelf];
    }
    return self;
}

- (void)configSelf {
    _playing = NO;
    _loopCount = NSUIntegerMax;
    _imageIndex = 0;
    _speed = 1.0;
    _frameCacheInterval = 0;
}

#pragma mark - 属性
- (void)setGifData:(NSData *)gifData {
    if (_gifData == gifData) {
        return;
    }
    _gifData = gifData;
    _sourceChange = YES;
    _imageIndex = 0;
    if (gifData) {
        self.image = [UIImage imageWithData:_gifData];
    }
}

#pragma mark - 操作
- (void)startGif {
    _lastCount = self.loopCount;
    [self playGifAnimation];
}

- (void)startGifLoopCount:(NSUInteger)loopCount {
    self.loopCount = loopCount;
    [self startGif];
}

- (void)pauseGif {
    if (self.isPlaying == NO) return;
    _playing = NO;
}

- (void)stopGif {
    if (self.isPlaying == NO) return;
    _playing = NO;
    _imageIndex = 0;
    if (self.gifData == nil) return;
    self.image = [UIImage imageWithData:_gifData];
}

#pragma mark - gif播发代码
- (void)playGifAnimation {
    if (self.gifData == nil) return;
    if (self.isPlaying) return;
    _playing = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGImageSourceRef src = nil;
        size_t frameCount = 0;
        size_t frameCacheInterval = NSUIntegerMax;
        NSArray<NSNumber*> *frameDelayArray = nil;
        NSMutableDictionary<NSNumber*, UIImage*> *imageCache = nil;
        while (self.isPlaying && self.lastCount > 0) {
            if ([NSRunLoop mainRunLoop].currentMode == UITrackingRunLoopMode) {
                [NSThread sleepForTimeInterval:0.5];
                continue;
            }
            NSDate *beginTime = [NSDate date];
            // gifData改变或者线程刚开始src为nil，并且要gifData有数据
            if ((self.isSourceChange || src == nil) && self.gifData != nil) {
                self.sourceChange = NO;
                if (src) {
                    CFRelease(src);
                }
                src = CGImageSourceCreateWithData((__bridge CFDataRef)self.gifData, NULL);
                if (src) {
                    frameCount = CGImageSourceGetCount(src);
                    frameDelayArray = [WZMGifImageView durationArrayWithSource:src];
                    imageCache = [NSMutableDictionary dictionary];
                    if (self.frameCacheInterval != NSUIntegerMax) {
                        frameCacheInterval = self.frameCacheInterval + 1;
                    }
                }
                else {
                    break;
                }
            }
            
            NSTimeInterval frameDelay = 0.0;
            if (self.imageIndex < frameDelayArray.count) {
                frameDelay = frameDelayArray[self.imageIndex].floatValue * self.speed;
            }
            self.imageIndex ++;
            if (self.imageIndex == frameCount) {
                self.imageIndex = 0;
                if (self.lastCount != NSUIntegerMax) {
                    self.lastCount --;
                }
            }
            
//            [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSRunLoopCommonModes];
//            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:frameDelay]];
            [NSThread sleepUntilDate:[beginTime dateByAddingTimeInterval:frameDelay]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                UIImage *image = imageCache[@(self.imageIndex)];
                if (image == nil && src) {
                    image = [WZMGifImageView imageWithSource:src andIndex:self.imageIndex];
                    if (frameCacheInterval < frameCount
                        && self.imageIndex % frameCacheInterval == 0) {
                        imageCache[@(self.imageIndex)] = image;
                    }
                }
                if (self.isPlaying && !self.isSourceChange) {
                    self.image = image;
                }
            });
        }
        if (src) {
            CFRelease(src);
        }
        self.playing = NO;
    });
}

+ (UIImage *)imageWithSource:(CGImageSourceRef)src andIndex:(size_t)index {
    CGImageRef cgImg = CGImageSourceCreateImageAtIndex(src, index, NULL);
    UIImage *image = [UIImage imageWithCGImage:cgImg];
    CGImageRelease(cgImg);
    return image;
}

+ (NSTimeInterval)durationTimeWithSource:(CGImageSourceRef)src andIndex:(size_t)index {
    NSDictionary *properties    = (__bridge_transfer NSDictionary *)CGImageSourceCopyPropertiesAtIndex(src, index, NULL);
    NSDictionary *gifProperties = [properties valueForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
    NSString *gifDelayTime      = [gifProperties valueForKey:(__bridge NSString*)kCGImagePropertyGIFDelayTime];
    
    return [gifDelayTime floatValue];
}

+ (NSArray<NSNumber*> *)durationArrayWithSource:(CGImageSourceRef)src {
    NSMutableArray *array = [NSMutableArray array];
    size_t frameCount = CGImageSourceGetCount(src);
    for (size_t i = 0; i < frameCount; i++) {
        NSTimeInterval delay = [WZMGifImageView durationTimeWithSource:src andIndex:i];
        [array addObject:@(delay)];
    }
    return array;
}

#pragma mark - 公开的类方法
+ (NSTimeInterval)durationTimeWithGifData:(NSData *)gifData andIndex:(size_t)index {
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)gifData, NULL);
    if (src) {
        NSTimeInterval delay = [WZMGifImageView durationTimeWithSource:src andIndex:index];
        CFRelease(src);
        return delay;
    }
    else {
        return 0.0;
    }
}

+ (NSArray<NSNumber*> *)durationArrayWithGifData:(NSData *)gifData {
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)gifData, NULL);
    if (src) {
        NSArray *array = [WZMGifImageView durationArrayWithSource:src];
        CFRelease(src);
        return array;
    }
    else {
        return nil;
    }
}

+ (UIImage *)imageWithGifData:(NSData *)gifData andIndex:(size_t)index {
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)gifData, NULL);
    if (src) {
        UIImage *image = [WZMGifImageView imageWithSource:src andIndex:index];
        CFRelease(src);
        return image;
    }
    else {
        return nil;
    }
}

+ (NSArray<UIImage*> *)imageArrayWithGifData:(NSData *)gifData {
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)gifData, NULL);
    if (src) {
        NSMutableArray *array = [NSMutableArray array];
        size_t frameCount = CGImageSourceGetCount(src);
        for (size_t i = 0; i < frameCount; i++) {
            UIImage *image = [WZMGifImageView imageWithSource:src andIndex:i];
            [array addObject:image];
        }
        CFRelease(src);
        return array;
    }
    else {
        return nil;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self stopGif];
        [self startGif];
    }
    [super willMoveToSuperview:newSuperview];
}

- (void)removeFromSuperview {
    [self stopGif];
    [super removeFromSuperview];
}

- (void)dealloc {
    WZMLog(@"%@释放了",NSStringFromClass(self.class));
}

@end
