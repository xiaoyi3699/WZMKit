//
//  WZMProgressView.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/20.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMSliderView.h"

@interface WZMSliderView ()

@property (nonatomic, strong) CAShapeLayer *shaperLayer;

@end

@implementation WZMSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _animation = NO;
        _strokeStart = 0.0;
        _strokeEnd = 0.0;
        CGFloat lineW = frame.size.height;
        self.shaperLayer = [[CAShapeLayer alloc] init];
        self.shaperLayer.frame = self.bounds;
        self.shaperLayer.lineWidth = lineW;
        self.shaperLayer.lineCap = kCALineCapRound;
        self.shaperLayer.cornerRadius = lineW/2;
        self.shaperLayer.masksToBounds = YES;
        self.shaperLayer.strokeStart = _strokeStart;
        self.shaperLayer.strokeEnd = _strokeEnd;
        self.normalColor = [UIColor clearColor];
        self.highlightedColor = [UIColor redColor];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(lineW/2, frame.size.height/2)];
        [path addLineToPoint:CGPointMake(frame.size.width-lineW/2, frame.size.height/2)];
        self.shaperLayer.path = path.CGPath;
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

- (void)setNormalColor:(UIColor *)normalColor {
    if (_normalColor == normalColor) return;
    _normalColor = normalColor;
    self.shaperLayer.backgroundColor = _normalColor.CGColor;
}

- (void)setHighlightedColor:(UIColor *)highlightedColor {
    if (_highlightedColor == highlightedColor) return;
    _highlightedColor = highlightedColor;
    self.shaperLayer.strokeColor = _highlightedColor.CGColor;
}

@end
