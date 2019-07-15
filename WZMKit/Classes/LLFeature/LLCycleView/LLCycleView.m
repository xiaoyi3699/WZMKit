//
//  LLCycleView.m
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2018/3/21.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "LLCycleView.h"
#import "UIView+LLAddPart.h"
#import "LLMacro.h"

@implementation LLCycleView {
    NSTimer *_timer;
    UIView  *_aniView;  //动画View
    CGFloat _start;     //公转开始角度
    CGFloat _speed;     //公转速度(角度)
    CGFloat _rate;      //自转速率倍数
    CGFloat _rStart;    //自转开始角度的余角(自转开始角度=90-_rStart)
    CGFloat _rSpeed;    //自转速度(角度)
    CGFloat _centerX;   //中心点x
    CGFloat _centerY;   //中心点y
    CGFloat _radiusX;   //x轴半径
    CGFloat _radiusY;   //y轴半径
    LLBezierView *_bezierView;
}

/**
 初始化

 @param center 圆心坐标
 @param x      x轴半径
 @param y      y轴半径
 @param start  初始角度
 @param speed  公转速度
 @param rate   自转速率倍数(自转速率=speed*rate 0表示不自转, 1表示自转速度与公转速度一致, 负数表示自转角度与公转角度相反)
 @param line   是否显示圆心到视图中心的连线
 @return 本类对象
 */
- (instancetype)initWithCenter:(CGPoint)center radiusX:(CGFloat)x radiusY:(CGFloat)y start:(CGFloat)start speed:(CGFloat)speed rate:(CGFloat)rate line:(BOOL)line {
    
    self = [super initWithFrame:CGRectMake(center.x-x, center.y-y, 2*x, 2*y)];
    if (self) {
        
        _start = start;
        _speed = speed;
        _rate = rate;
        _rStart = start;
        _rSpeed = rate*speed;
        _radiusX = x;
        _radiusY = y;
        _centerX = self.LLWidth/2;
        _centerY = self.LLHeight/2;
        if (line) {
            CGFloat radian = ANGLE_TO_RADIAN(start);
            _bezierView = [[LLBezierView alloc] initWithFrame:self.bounds];
            _bezierView.backgroundColor = [UIColor clearColor];
            _bezierView.start = CGPointMake(_centerX, _centerY);
            _bezierView.end   = CGPointMake(_centerX+x*cos(radian), _centerY-y*sin(radian));
            [self addSubview:_bezierView];
        }
    }
    return self;
}

#pragma mark - public method
- (void)showInView:(UIView *)superView animationView:(UIView *)animationView {
    _aniView = animationView;
    CGFloat radian = ANGLE_TO_RADIAN(_start);
    _aniView.center = CGPointMake(_centerX+_radiusX*cos(radian), _centerY-_radiusY*sin(radian));
    [self insertSubview:animationView atIndex:0];
    [superView addSubview:self];
    [self timerFire];
}

#pragma mark - private method
- (void)timerFire {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    }
}

- (void)timerInvalidate {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)timerRun {
    CGFloat radian = ANGLE_TO_RADIAN(_start);
    _aniView.center = CGPointMake(_centerX+_radiusX*cos(radian), _centerY-_radiusY*sin(radian));
    if (_bezierView) {
        _bezierView.end = _aniView.center;
        [_bezierView setNeedsDisplay];
    }
    if (_rate != 0) {
        [_aniView transform3DMakeRotationX:0 Y:0 Z:(90-_rStart)];
        _rStart += _rSpeed;
    }
    _start += _speed;
}

#pragma mark - super method
- (void)removeFromSuperview {
    [self timerInvalidate];
    [super removeFromSuperview];
}

@end
