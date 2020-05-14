//
//  WZMVideoKeyView.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/20.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMVideoKeyView.h"
#import "UIView+wzmcate.h"
#import "UIImage+wzmcate.h"

@interface WZMVideoKeyView ()

///进度
@property (nonatomic, strong) UIView *sliderView;
///关键帧
@property (nonatomic, strong) UIView *keysView;
@property (nonatomic, strong) UIImageView *keysImageView;
///灰度图
@property (nonatomic, strong) UIView *graysView;
@property (nonatomic, strong) UIImageView *graysImageView;
///视图
@property (nonatomic, strong) UIView *contentView;

@end

@implementation WZMVideoKeyView {
    CGFloat _sliderX;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = self.bounds;
        rect.origin.y = 5;
        rect.size.height -= 10;
        self.contentView = [[UIView alloc] initWithFrame:rect];
        self.contentView.clipsToBounds = YES;
        self.contentView.userInteractionEnabled = NO;
        [self addSubview:self.contentView];
        
        CGRect contentRect = self.contentView.bounds;
        self.keysView = [[UIView alloc] initWithFrame:contentRect];
        self.keysView.clipsToBounds = YES;
        [self.contentView addSubview:self.keysView];
        
        self.keysImageView = [[UIImageView alloc] initWithFrame:self.keysView.bounds];
        self.keysImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.keysView addSubview:self.keysImageView];
        
        self.graysView = [[UIView alloc] initWithFrame:contentRect];
        self.graysView.clipsToBounds = YES;
        [self.contentView addSubview:self.graysView];
        
        self.graysImageView = [[UIImageView alloc] initWithFrame:self.graysView.bounds];
        self.graysImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.graysView addSubview:self.graysImageView];
        
        self.sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, self.wzm_height)];
        self.sliderView.hidden = YES;
        self.sliderView.backgroundColor = [UIColor whiteColor];
        self.sliderView.wzm_cornerRadius = 1;
        [self addSubview:self.sliderView];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [self addGestureRecognizer:panGesture];
    }
    return self;
}

- (void)panGesture:(UIPanGestureRecognizer *)recognizer {
    CGFloat tx = [recognizer translationInView:self].x;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _sliderX = self.sliderView.wzm_minX;
        [self didChangeType:WZMCommonStateBegan];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat x = _sliderX+tx;
        if (x < 0) x = 0;
        if (x > self.wzm_width) x = self.wzm_width;
        self.value = (x/self.wzm_width);
        [self didChangeType:WZMCommonStateChanged];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded ||
             recognizer.state == UIGestureRecognizerStateCancelled) {
        [self didChangeType:WZMCommonStateEnded];
    }
}

- (void)didChangeType:(WZMCommonState)type {
    if ([self.delegate respondsToSelector:@selector(videoKeyView:changeType:)]) {
        [self.delegate videoKeyView:self changeType:type];
    }
}

- (void)setValue:(CGFloat)value {
    if (value < 0 || value > 1) return;
    if (_value == value) return;
    _value = value;
    CGFloat x = value*self.wzm_width;
    CGFloat w = (1-value)*self.wzm_width;
    self.graysView.frame = CGRectMake(self.keysView.wzm_minX+x, self.graysView.wzm_minY, w, self.wzm_height);
    self.graysImageView.wzm_minX = -x;
    self.sliderView.wzm_minX = x;
}

- (void)setRadius:(CGFloat)radius {
    if (radius < 0) return;
    if (_radius == radius) return;
    _radius = radius;
    self.contentView.wzm_cornerRadius = radius;
    self.keysImageView.wzm_cornerRadius = radius;
    self.graysImageView.wzm_cornerRadius = radius;
}

- (void)setVideoUrl:(NSURL *)videoUrl {
    if ([_videoUrl.path isEqualToString:videoUrl.path]) return;
    _videoUrl = videoUrl;
    CGSize size = self.keysView.bounds.size;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *fImage = [[UIImage wzm_getImagesByUrl:_videoUrl count:1] firstObject];
        CGFloat imageViewH = size.height;
        CGFloat imageViewW = fImage.size.width*imageViewH/fImage.size.height;
        CGFloat c = size.width/imageViewW;
        NSInteger count = (NSInteger)c;
        if (c > count) {
            count ++;
        }
        NSArray *images = [UIImage wzm_getImagesByUrl:self.videoUrl count:count];
        UIImage *keysImage = [UIImage wzm_getImageByImages:images type:WZMAddImageTypeHorizontal];
        UIImage *graysImage = [keysImage wzm_getGrayImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.sliderView.hidden = NO;
            self.keysImageView.image = keysImage;
            self.graysImageView.image = graysImage;
        });
    });
}

@end
