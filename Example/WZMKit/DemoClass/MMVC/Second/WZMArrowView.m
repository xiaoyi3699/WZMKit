//
//  WZMArrowView.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2021/3/8.
//  Copyright © 2021 wangzhaomeng. All rights reserved.
//

#import "WZMArrowView.h"

@interface WZMArrowView ()

@property (nonatomic, strong) CAShapeLayer *startLayer;
@property (nonatomic, strong) CAShapeLayer *endLayer;
@property (nonatomic, assign) BOOL allowDrawArrow;
@property (nonatomic, assign) CGFloat touchDistance;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation WZMArrowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.selected = NO;
        self.touchDistance = 20.0;
        self.allowDrawArrow = YES;
        self.startPoint = CGPointZero;
        self.endPoint = CGPointZero;
        self.normalColor = [UIColor blackColor];
        self.selectedColor = [UIColor redColor];
        self.shapeLayer = [[CAShapeLayer alloc] init];
        self.shapeLayer.frame = self.bounds;
        self.shapeLayer.lineWidth = 3.0;
        self.shapeLayer.lineJoin = kCALineJoinRound;
        self.shapeLayer.lineCap = kCALineCapRound;
        self.shapeLayer.fillColor = [UIColor blackColor].CGColor;
        self.shapeLayer.strokeColor = [UIColor blackColor].CGColor;
        self.clipsToBounds = YES;
        [self.layer addSublayer:self.shapeLayer];
        
        CGRect pathRect = CGRectMake(0.0, 0.0, 20.0, 20.0);
        UIBezierPath *startPath = [UIBezierPath bezierPathWithRoundedRect:pathRect cornerRadius:pathRect.size.width/2.0];
        self.startLayer = [[CAShapeLayer alloc] init];
        self.startLayer.bounds = pathRect;
        self.startLayer.wzm_center = self.startPoint;
        self.startLayer.path = startPath.CGPath;
        self.startLayer.lineWidth = 1.0;
        self.startLayer.fillColor = [UIColor clearColor].CGColor;
        self.startLayer.strokeColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:self.startLayer];
        
        UIBezierPath *endPath = [UIBezierPath bezierPathWithRoundedRect:pathRect cornerRadius:pathRect.size.width/2.0];
        self.endLayer = [[CAShapeLayer alloc] init];
        self.endLayer.bounds = pathRect;
        self.endLayer.wzm_center = self.endPoint;
        self.endLayer.path = endPath.CGPath;
        self.endLayer.lineWidth = 1.0;
        self.endLayer.fillColor = [UIColor clearColor].CGColor;
        self.endLayer.strokeColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:self.endLayer];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector((tapGesture:))];
        [self addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    WZMArrowViewTouchType type = [self caculateLocationWithPoint:point];
    if (type == WZMArrowViewTouchTypeNone) return;
    self.selected = !self.selected;
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    if (self.selected == NO) return;
    static WZMArrowViewTouchType type;
    static CGPoint startPoint, endPoint;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gesture locationInView:self];
        type = [self caculateLocationWithPoint:point];
        startPoint = self.startPoint;
        endPoint = self.endPoint;
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        if (type == WZMArrowViewTouchTypeNone) return;
        if (type == WZMArrowViewTouchTypeMid) {
            CGPoint point = [gesture translationInView:self];
            if (startPoint.x + point.x < 0.0) {
                point.x = -startPoint.x;
            }
            if (startPoint.y + point.y < 0.0) {
                point.y = -startPoint.y;
            }
            if (endPoint.x + point.x > self.bounds.size.width) {
                point.x = self.bounds.size.width - endPoint.x;
            }
            if (endPoint.y + point.y > self.bounds.size.height) {
                point.y = self.bounds.size.height - endPoint.y;
            }
            CGPoint sPoint = CGPointMake(startPoint.x+point.x, startPoint.y+point.y);
            self.allowDrawArrow = NO;
            self.startPoint = sPoint;
            CGPoint ePoint = CGPointMake(endPoint.x+point.x, endPoint.y+point.y);
            self.allowDrawArrow = YES;
            self.endPoint = ePoint;
        }
        else {
            CGPoint point = [gesture locationInView:self];
            if (CGRectContainsPoint(self.bounds, point) == NO) {
                if (point.x < 0.0) {
                    point.x = 0.0;
                }
                if (point.y < 0.0) {
                    point.y = 0.0;
                }
                if (point.x > self.bounds.size.width) {
                    point.x = self.bounds.size.width;
                }
                if (point.y > self.bounds.size.height) {
                    point.y = self.bounds.size.height;
                }
            }
            if (type == WZMArrowViewTouchTypeStart) {
                self.startPoint = point;
            }
            else {
                self.endPoint = point;
            }
        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded ||
             gesture.state == UIGestureRecognizerStateCancelled) {
        
    }
}

- (WZMArrowViewTouchType)caculateLocationWithPoint:(CGPoint)point {
    CGFloat distanceStart = [self distanceBetweenPoint:point otherPoint:self.startPoint];
    CGFloat distanceEnd = [self distanceBetweenPoint:point otherPoint:self.endPoint];
    CGFloat distance = [self distanceBetweenPoint:self.startPoint otherPoint:self.endPoint];
    CGFloat diffrence = distanceStart + distanceEnd - distance;
    if (diffrence <= self.touchDistance || distanceStart <= self.touchDistance || distanceEnd <= self.touchDistance) {
        CGFloat min = MIN(distanceStart, distanceEnd);
        if (MIN(min, 2*self.touchDistance) == min) {
            if (min == distanceStart) return WZMArrowViewTouchTypeStart;
            if (min == distanceEnd) return WZMArrowViewTouchTypeEnd;
        }
        else {
            return WZMArrowViewTouchTypeMid;
        }
    }
    return WZMArrowViewTouchTypeNone;
}

- (void)createArrow {
    if (self.allowDrawArrow == NO) return;
    if (CGPointEqualToPoint(self.startPoint, self.endPoint)) return;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.startPoint];
    [path addLineToPoint:self.endPoint];
    [path appendPath:[self createArrowPath]];
    
    if (self.selected) {
        self.shapeLayer.fillColor = self.selectedColor.CGColor;
        self.shapeLayer.strokeColor = self.selectedColor.CGColor;
        
        self.startLayer.hidden = NO;
        self.endLayer.hidden = NO;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.startLayer.wzm_center = self.startPoint;
        self.endLayer.wzm_center = self.endPoint;
        [CATransaction setDisableActions:NO];
        [CATransaction commit];
    }
    else {
        self.shapeLayer.fillColor = self.normalColor.CGColor;
        self.shapeLayer.strokeColor = self.normalColor.CGColor;
        
        self.startLayer.hidden = YES;
        self.endLayer.hidden = YES;
    }
    self.shapeLayer.path = path.CGPath;
}

- (UIBezierPath *)createArrowPath {
    CGPoint controllPoint = CGPointZero;
    CGPoint pointUp = CGPointZero;
    CGPoint pointDown = CGPointZero;
    CGFloat distance = [self distanceBetweenPoint:self.startPoint otherPoint:self.endPoint];
    CGFloat distanceX = 10.0 * (ABS(self.endPoint.x - self.startPoint.x) / distance);
    CGFloat distanceY = 10.0 * (ABS(self.endPoint.y - self.startPoint.y) / distance);
    CGFloat distX = 5.0 * (ABS(self.endPoint.y - self.startPoint.y) / distance);
    CGFloat distY = 5.0 * (ABS(self.endPoint.x - self.startPoint.x) / distance);
    if (self.endPoint.x >= self.startPoint.x)
    {
        if (self.endPoint.y >= self.startPoint.y)
        {
            controllPoint = CGPointMake(self.endPoint.x - distanceX, self.endPoint.y - distanceY);
            pointUp = CGPointMake(controllPoint.x + distX, controllPoint.y - distY);
            pointDown = CGPointMake(controllPoint.x - distX, controllPoint.y + distY);
        }
        else
        {
            controllPoint = CGPointMake(self.endPoint.x - distanceX, self.endPoint.y + distanceY);
            pointUp = CGPointMake(controllPoint.x - distX, controllPoint.y - distY);
            pointDown = CGPointMake(controllPoint.x + distX, controllPoint.y + distY);
        }
    }
    else
    {
        if (self.endPoint.y >= self.startPoint.y)
        {
            controllPoint = CGPointMake(self.endPoint.x + distanceX, self.endPoint.y - distanceY);
            pointUp = CGPointMake(controllPoint.x - distX, controllPoint.y - distY);
            pointDown = CGPointMake(controllPoint.x + distX, controllPoint.y + distY);
        }
        else
        {
            controllPoint = CGPointMake(self.endPoint.x + distanceX, self.endPoint.y + distanceY);
            pointUp = CGPointMake(controllPoint.x + distX, controllPoint.y - distY);
            pointDown = CGPointMake(controllPoint.x - distX, controllPoint.y + distY);
        }
    }
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:self.endPoint];
    [arrowPath addLineToPoint:pointDown];
    [arrowPath addLineToPoint:pointUp];
    [arrowPath addLineToPoint:self.endPoint];
    return arrowPath;
}

- (CGFloat)distanceBetweenPoint:(CGPoint)point otherPoint:(CGPoint)otherPoint {
    CGFloat xDist = (otherPoint.x - point.x);
    CGFloat yDist = (otherPoint.y - point.y);
    return sqrt((xDist * xDist) + (yDist * yDist));
}

- (void)setStartPoint:(CGPoint)startPoint {
    if (CGPointEqualToPoint(_startPoint, startPoint)) return;
    _startPoint = startPoint;
    [self createArrow];
}

- (void)setEndPoint:(CGPoint)endPoint {
    if (CGPointEqualToPoint(_endPoint, endPoint)) return;
    _endPoint = endPoint;
    [self createArrow];
}

- (void)setSelected:(BOOL)selected {
    if (_selected == selected) return;
    _selected = selected;
    [self createArrow];
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    if (_shapeLayer) {
        [self createArrow];
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    if (_shapeLayer) {
        [self createArrow];
    }
}

@end
