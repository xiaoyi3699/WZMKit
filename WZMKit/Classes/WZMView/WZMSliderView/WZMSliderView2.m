//
//  WZMSliderView2.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/22.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMSliderView2.h"

@interface WZMSliderView2 ()

@property (nonatomic, strong) CAShapeLayer *shaperLayer;

@end

@implementation WZMSliderView2

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //方形进度条
        _radius = -1;
        _animation = NO;
        _strokeStart = 0.0;
        _strokeEnd = 0.0;
        _lineWidth = 2;
        self.shaperLayer = [[CAShapeLayer alloc] init];
        self.shaperLayer.frame = self.bounds;
        self.shaperLayer.strokeStart = _strokeStart;
        self.shaperLayer.strokeEnd = _strokeEnd;
        //线端点
        self.shaperLayer.lineCap = kCALineCapRound;
        //线连接处
        self.shaperLayer.lineJoin = kCALineJoinRound;
        
        self.radius = 0;
        self.lineWidth = 2;
        self.fillColor = [UIColor clearColor];
        self.strokeColor = [UIColor redColor];
        self.bgColor = [UIColor clearColor];
        [self.layer addSublayer:self.shaperLayer];
    }
    return self;
}

//无动画
- (void)setStrokeStart:(CGFloat)strokeStart {
    if (strokeStart < 0) strokeStart = 0;
    if (strokeStart > 1) strokeStart = 1;
    if (_strokeStart == strokeStart) return;
    _strokeStart = strokeStart;
    if (self.isAnimation) {
        self.shaperLayer.strokeStart = strokeStart;
    }
    else {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.shaperLayer.strokeStart = strokeStart;
        [CATransaction setDisableActions:NO];
        [CATransaction commit];
    }
}

- (void)setStrokeEnd:(CGFloat)strokeEnd {
    if (strokeEnd < 0) strokeEnd = 0;
    if (strokeEnd > 1) strokeEnd = 1;
    if (_strokeEnd == strokeEnd) return;
    _strokeEnd = strokeEnd;
    if (self.isAnimation) {
        self.shaperLayer.strokeEnd = strokeEnd;
    }
    else {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.shaperLayer.strokeEnd = strokeEnd;
        [CATransaction setDisableActions:NO];
        [CATransaction commit];
    }
}

- (void)setFillColor:(UIColor *)fillColor {
    if (_fillColor == fillColor) return;
    _fillColor = fillColor;
    self.shaperLayer.fillColor = fillColor.CGColor;
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    if (_strokeColor == strokeColor) return;
    _strokeColor = strokeColor;
    self.shaperLayer.strokeColor = strokeColor.CGColor;
}

- (void)setBgColor:(UIColor *)bgColor {
    if (_bgColor == bgColor) return;
    _bgColor = bgColor;
    self.shaperLayer.backgroundColor = bgColor.CGColor;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    if (lineWidth < 0) lineWidth = 0;
    if (_lineWidth == lineWidth) return;
    _lineWidth = lineWidth;
    
    self.shaperLayer.lineWidth = _lineWidth;
}

- (void)setRadius:(CGFloat)radius {
    if (radius < 0) radius = 0;
    if (_radius == radius) return;
    _radius = radius;
    
    UIBezierPath *path;
    if (self.radius == 0) {
        path = [UIBezierPath bezierPathWithRect:self.shaperLayer.bounds];
    }
    else {
        path = [UIBezierPath bezierPathWithRoundedRect:self.shaperLayer.bounds
                                          cornerRadius:_radius];
    }
    self.shaperLayer.path = path.CGPath;
}

@end
