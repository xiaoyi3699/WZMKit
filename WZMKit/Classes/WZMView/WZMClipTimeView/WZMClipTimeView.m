//
//  WZMClipTimeView.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/7.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMClipTimeView.h"
#import "UIView+wzmcate.h"
#import "UIImage+wzmcate.h"
#import "WZMPublic.h"

@interface WZMClipTimeView ()

@property (nonatomic, assign) CGFloat startValue;
@property (nonatomic, assign) CGFloat endValue;
@property (nonatomic, strong) UIImageView *leftView;
@property (nonatomic, strong) UIImageView *rightView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *foregroundView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *keysView;
@property (nonatomic, strong) UIImageView *keysImageView;
@property (nonatomic, strong) UIView *sliderView;

@end

@implementation WZMClipTimeView {
    CGFloat _sliderX;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect backRect = self.bounds;
        backRect.origin.x = 17;
        backRect.size.width -= 34;
        self.backgroundView = [[UIView alloc] initWithFrame:backRect];
        self.backgroundView.alpha = 0;
        self.backgroundView.wzm_borderWidth = 3;
        [self addSubview:self.backgroundView];
        
        CGRect contentRect = self.bounds;
        contentRect.origin.x = 20;
        contentRect.origin.y = 3;
        contentRect.size.width -= 40;
        contentRect.size.height -= 6;
        self.contentView = [[UIView alloc] initWithFrame:contentRect];
        [self addSubview:self.contentView];
        
        CGRect foreRect = self.bounds;
        foreRect.origin.y = 3;
        foreRect.size.height -= 6;
        self.foregroundView = [[UIView alloc] initWithFrame:foreRect];
        self.foregroundView.wzm_borderWidth = 5;
        [self addSubview:self.foregroundView];
        
        self.leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 20, self.bounds.size.height-6)];
        self.leftView.userInteractionEnabled = YES;
        self.leftView.image = [WZMPublic imageWithFolder:@"clip" imageName:@"clip_left.png"];
        [self addSubview:self.leftView];
        
        UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftPanRecognizer:)];
        [self.leftView addGestureRecognizer:leftPan];
        
        self.rightView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width-20, 3, 20, self.bounds.size.height-6)];
        self.rightView.userInteractionEnabled = YES;
        self.rightView.image = [WZMPublic imageWithFolder:@"clip" imageName:@"clip_right.png"];
        [self addSubview:self.rightView];
        
        UIPanGestureRecognizer *rightPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightPanRecognizer:)];
        [self.rightView addGestureRecognizer:rightPan];
        
        //绘制关键帧
        CGRect rect = foreRect;
        rect.origin.x = self.leftView.wzm_maxX;
        rect.origin.y += 3.0;
        rect.size.width -= (self.leftView.wzm_width+self.rightView.wzm_width);
        rect.size.height -= 6.0;
        self.keysView = [[UIView alloc] initWithFrame:rect];
        [self insertSubview:self.keysView atIndex:0];
        
        self.keysImageView = [[UIImageView alloc] initWithFrame:self.keysView.bounds];
        self.keysImageView.clipsToBounds = YES;
        self.keysImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.keysView addSubview:self.keysImageView];
        
        self.sliderColor = [UIColor blueColor];
        self.sliderView = [[UIView alloc] initWithFrame:CGRectMake(self.keysView.wzm_minX, -3.0, 2.0, self.wzm_height+6.0)];
        self.sliderView.backgroundColor = self.sliderColor;
        self.sliderView.wzm_cornerRadius = 1.0;
        [self addSubview:self.sliderView];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [self addGestureRecognizer:panGesture];
        
        //其他设置
        self.startValue = 0.0;
        self.endValue = 1.0;
        self.foregroundBorderColor = [UIColor whiteColor];
        self.backgroundBorderColor = [UIColor clearColor];
    }
    return self;
}

//进度改变
- (void)panGesture:(UIPanGestureRecognizer *)recognizer {
    CGFloat tx = [recognizer translationInView:self].x;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _sliderX = self.sliderView.wzm_minX - self.keysView.wzm_minX;
        [self valueChanged:WZMCommonStateBegan];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat x = _sliderX+tx;
        self.value = (x/self.keysView.wzm_width);
        [self valueChanged:WZMCommonStateChanged];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded ||
             recognizer.state == UIGestureRecognizerStateCancelled) {
        [self valueChanged:WZMCommonStateEnded];
    }
}

- (void)leftPanRecognizer:(UIPanGestureRecognizer *)recognizer {
    static CGFloat startX;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        startX = self.leftView.wzm_minX;
        [self clipChanged:WZMCommonStateBegan];
        [self valueChanged:WZMCommonStateBegan];
    }
    else {
        CGFloat tx = [recognizer translationInView:self.leftView].x;
        BOOL end = (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled);
        [self setLeftViewMinX:(startX+tx) recognizerState:(end ? WZMCommonStateEnded : WZMCommonStateChanged)];
        [self valueChanged:(end ? WZMCommonStateEnded : WZMCommonStateChanged)];
    }
}

- (void)rightPanRecognizer:(UIPanGestureRecognizer *)recognizer {
    static CGFloat startX;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        startX = self.rightView.wzm_minX;
        [self clipChanged:WZMCommonStateBegan];
        [self valueChanged:WZMCommonStateBegan];
    }
    else {
        CGFloat tx = [recognizer translationInView:self.rightView].x;
        BOOL end = (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled);
        [self setRightViewMinX:(startX+tx) recognizerState:(end ? WZMCommonStateEnded : WZMCommonStateChanged)];
        [self valueChanged:(end ? WZMCommonStateEnded : WZMCommonStateChanged)];
    }
}

- (void)setLeftViewMinX:(CGFloat)minX recognizerState:(WZMCommonState)state {
    if (minX < 0) {
        minX = 0;
    }
    else if (minX+self.leftView.wzm_width > self.rightView.wzm_minX) {
        minX = self.rightView.wzm_minX-self.leftView.wzm_width;
    }
    self.startValue = [self loadStartValue:minX];
    [self clipChanged:state];
//    if (self.startValue > self.value) {
        self.value = self.startValue;
//    }
}

- (void)setRightViewMinX:(CGFloat)minX recognizerState:(WZMCommonState)state {
    if (minX+self.rightView.wzm_width > self.bounds.size.width) {
        minX = (self.bounds.size.width-self.rightView.wzm_width);
    }
    else if (minX < self.leftView.wzm_maxX) {
        minX = self.leftView.wzm_maxX;
    }
    self.endValue = [self loadEndValue:minX];
    [self clipChanged:state];
//    if (self.endValue < self.value) {
        self.value = self.endValue;
//    }
}

- (void)clipChanged:(WZMCommonState)state {
    if (state == WZMCommonStateBegan) {
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundView.alpha = 0.5;
        }];
    }
    else if (state == WZMCommonStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundView.alpha = 0.0;
        }];
    }
    if ([self.delegate respondsToSelector:@selector(clipView:clipChanged:)]) {
        [self.delegate clipView:self clipChanged:state];
    }
}

- (void)valueChanged:(WZMCommonState)state {
    if ([self.delegate respondsToSelector:@selector(clipView:valueChanged:)]) {
        [self.delegate clipView:self valueChanged:state];
    }
}

- (CGFloat)loadStartValue:(CGFloat)minX {
    self.leftView.wzm_minX = minX;
    self.foregroundView.wzm_mutableMinX = minX;
    return (self.leftView.wzm_maxX-self.leftView.wzm_width)/self.contentView.wzm_width;
}

- (CGFloat)loadEndValue:(CGFloat)minX {
    self.rightView.wzm_minX = minX;
    self.foregroundView.wzm_mutableMaxX = minX+self.rightView.wzm_width;
    return (self.rightView.wzm_minX-self.leftView.wzm_width)/self.contentView.wzm_width;
}

- (void)setForegroundBorderColor:(UIColor *)foregroundBorderColor {
    if (_foregroundBorderColor == foregroundBorderColor) return;
    _foregroundBorderColor = foregroundBorderColor;
    self.foregroundView.wzm_borderColor = foregroundBorderColor;
}

- (void)setBackgroundBorderColor:(UIColor *)backgroundBorderColor {
    if (_backgroundBorderColor == backgroundBorderColor) return;
    _backgroundBorderColor = backgroundBorderColor;
    self.backgroundView.wzm_borderColor = backgroundBorderColor;
}

- (void)setValue:(CGFloat)value {
    if (value < 0) {
        value = 0;
    }
    else if (value > 1) {
        value = 1;
    }
    if (_value == value) return;
    if (value < self.startValue) {
        value = self.startValue;
    }
    else if (value > self.endValue) {
        value = self.endValue;
    }
    _value = value;
    CGFloat x = self.keysView.wzm_minX + value*self.keysView.wzm_width;
    self.sliderView.wzm_minX = x;
}

- (void)setVideoUrl:(NSURL *)videoUrl {
    if ([_videoUrl.path isEqualToString:videoUrl.path]) return;
    _videoUrl = videoUrl;
    CGSize size = self.keysView.bounds.size;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *fImage = [[UIImage wzm_getImagesByUrl:_videoUrl count:1 original:NO] firstObject];
        CGFloat imageViewH = size.height;
        CGFloat imageViewW = fImage.size.width*imageViewH/fImage.size.height;
        CGFloat c = size.width/imageViewW;
        NSInteger count = (NSInteger)c;
        if (c > count) {
            count ++;
        }
        NSArray *images = [UIImage wzm_getImagesByUrl:self.videoUrl count:count original:NO];
        UIImage *keysImage = [UIImage wzm_getImageByImages:images type:WZMAddImageTypeHorizontal];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.keysImageView.image = keysImage;
        });
    });
}

- (void)setSliderColor:(UIColor *)sliderColor {
    _sliderColor = sliderColor;
    self.sliderView.backgroundColor = sliderColor;
}

@end
