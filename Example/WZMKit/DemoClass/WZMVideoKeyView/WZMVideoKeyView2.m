//
//  WZMVideoKeyView2.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/20.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMVideoKeyView2.h"

@interface WZMVideoKeyView2 ()<UIScrollViewDelegate>

///进度
@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) UIScrollView *scrollView;
///关键帧
@property (nonatomic, strong) UIView *keysView;
@property (nonatomic, strong) UIImageView *keysImageView;
///灰度图
@property (nonatomic, strong) UIView *graysView;
@property (nonatomic, strong) UIImageView *graysImageView;

@end

@implementation WZMVideoKeyView2 {
    CGFloat _sliderX;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = self.bounds;
        rect.origin.y = 5;
        rect.size.height -= 10;
        self.scrollView = [[UIScrollView alloc] initWithFrame:rect];
        if (@available(iOS 11.0, *)) {
            self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        self.scrollView.contentSize = CGSizeMake(rect.size.width*2, rect.size.height);
        self.scrollView.bounces = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        
        CGRect keyRect = self.scrollView.bounds;
        keyRect.origin.x = keyRect.size.width/2;
        self.keysView = [[UIView alloc] initWithFrame:keyRect];
        self.keysView.clipsToBounds = YES;
        self.keysView.userInteractionEnabled = NO;
        [self.scrollView addSubview:self.keysView];
        
        self.keysImageView = [[UIImageView alloc] initWithFrame:self.keysView.bounds];
        self.keysImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.keysView addSubview:self.keysImageView];
        
        self.graysView = [[UIView alloc] initWithFrame:keyRect];
        self.graysView.clipsToBounds = YES;
        self.graysView.userInteractionEnabled = NO;
        [self.scrollView addSubview:self.graysView];
        
        self.graysImageView = [[UIImageView alloc] initWithFrame:self.graysView.bounds];
        self.graysImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.graysView addSubview:self.graysImageView];
        
        self.sliderView = [[UIView alloc] initWithFrame:CGRectMake((self.wzm_width-2)/2, 0, 2, self.wzm_height)];
        self.sliderView.backgroundColor = [UIColor whiteColor];
        self.sliderView.wzm_cornerRadius = 1;
        [self addSubview:self.sliderView];
    }
    return self;
}

- (void)didChangeType:(WZMCommonState)type {
    if ([self.delegate respondsToSelector:@selector(videoKeyView2:changeType:)]) {
        [self.delegate videoKeyView2:self changeType:type];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self didChangeType:WZMCommonStateWillChanged];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat value = scrollView.contentOffset.x/scrollView.wzm_width;
    [self didChangeValue:value scroll:NO];
    [self didChangeType:WZMCommonStateDidChanged];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self didChangeType:WZMCommonStateEndChanged];
}

- (void)didChangeValue:(CGFloat)value scroll:(BOOL)scroll {
    if (value < 0 || value > 1) return;
    _value = value;
    CGFloat x = value*self.wzm_width;
    CGFloat w = (1-value)*self.wzm_width;
    self.graysView.frame = CGRectMake(self.keysView.wzm_minX+x, self.graysView.wzm_minY, w, self.wzm_height);
    self.graysImageView.wzm_minX = -x;
    if (scroll) {
        self.scrollView.contentOffset = CGPointMake(x, 0);
    }
}

- (void)setValue:(CGFloat)value {
    if (value < 0 || value > 1) return;
    if (_value == value) return;
    [self didChangeValue:value scroll:YES];
}

- (void)setVideoUrl:(NSURL *)videoUrl {
    if ([_videoUrl.path isEqualToString:videoUrl.path]) return;
    _videoUrl = videoUrl;
    UIImage *fImage = [[UIImage wzm_getImagesByUrl:_videoUrl count:1] firstObject];
    CGFloat imageViewH = self.keysView.wzm_height;
    CGFloat imageViewW = fImage.size.width*imageViewH/fImage.size.height;
    CGFloat c = self.keysView.wzm_width/imageViewW;
    NSInteger count = (NSInteger)c;
    if (c > count) {
        count ++;
    }
    NSArray *images = [UIImage wzm_getImagesByUrl:self.videoUrl count:count];
    UIImage *keysImage = [UIImage wzm_getImageByImages:images type:WZMAddImageTypeHorizontal];
    UIImage *graysImage = [keysImage wzm_getGrayImage];
    
    self.keysImageView.image = keysImage;
    self.graysImageView.image = graysImage;
}

@end
