//
//  WZMClipTimeView.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/7.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMClipTimeView.h"
#import "UIView+wzmcate.h"
#import "WZMPublic.h"

@interface WZMClipTimeView ()

@property (nonatomic, assign) CGFloat startValue;
@property (nonatomic, assign) CGFloat endValue;
@property (nonatomic, strong) UIImageView *leftView;
@property (nonatomic, strong) UIImageView *rightView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *foregroundView;
@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation WZMClipTimeView

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
        self.leftView.image = [WZMPublic imageNamed:@"clip_left" ofType:@"png"];
        [self addSubview:self.leftView];
        
        UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftPanRecognizer:)];
        [self.leftView addGestureRecognizer:leftPan];
        
        self.rightView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width-20, 3, 20, self.bounds.size.height-6)];
        self.rightView.userInteractionEnabled = YES;
        self.rightView.image = [WZMPublic imageNamed:@"clip_right" ofType:@"png"];
        [self addSubview:self.rightView];
        
        UIPanGestureRecognizer *rightPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightPanRecognizer:)];
        [self.rightView addGestureRecognizer:rightPan];
        
        self.startValue = 0.0;
        self.endValue = 1.0;
        self.foregroundBorderColor = [UIColor whiteColor];
        self.backgroundBorderColor = [UIColor grayColor];
    }
    return self;
}

- (void)leftPanRecognizer:(UIPanGestureRecognizer *)recognizer {
    static CGFloat startX;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        startX = self.leftView.wzm_minX;
        [self valueChanged:WZMCommonStateBegan];
    }
    else {
        CGFloat tx = [recognizer translationInView:self.leftView].x;
        BOOL end = (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled);
        [self setLeftViewMinX:(startX+tx) recognizerState:(end ? WZMCommonStateEnded : WZMCommonStateChanged)];
    }
}

- (void)rightPanRecognizer:(UIPanGestureRecognizer *)recognizer {
    static CGFloat startX;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        startX = self.rightView.wzm_minX;
        [self valueChanged:WZMCommonStateBegan];
    }
    else {
        CGFloat tx = [recognizer translationInView:self.rightView].x;
        BOOL end = (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled);
        [self setRightViewMinX:(startX+tx) recognizerState:(end ? WZMCommonStateEnded : WZMCommonStateChanged)];
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
    [self valueChanged:state];
}

- (void)setRightViewMinX:(CGFloat)minX recognizerState:(WZMCommonState)state {
    if (minX+self.rightView.wzm_width > self.bounds.size.width) {
        minX = (self.bounds.size.width-self.rightView.wzm_width);
    }
    else if (minX < self.leftView.wzm_maxX) {
        minX = self.leftView.wzm_maxX;
    }
    self.endValue = [self loadEndValue:minX];
    [self valueChanged:state];
}

- (void)valueChanged:(WZMCommonState)state {
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
    if ([self.delegate respondsToSelector:@selector(clipView:valueState:)]) {
        [self.delegate clipView:self valueState:state];
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

@end
