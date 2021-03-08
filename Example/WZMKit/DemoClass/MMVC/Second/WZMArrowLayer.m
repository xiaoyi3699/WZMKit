//
//  WZMArrowLayer.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2021/3/8.
//  Copyright © 2021 wangzhaomeng. All rights reserved.
//

#import "WZMArrowLayer.h"

@interface WZMArrowLayer ()

//@property (nonatomic, strong) CAShapeLayer *startLayer;
//@property (nonatomic, strong) CAShapeLayer *endLayer;
@property (nonatomic, assign) CGFloat touchDistance;
@property (nonatomic, assign) NSInteger startCount;
@property (nonatomic, assign) NSInteger endCount;

@end

@implementation WZMArrowLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.lineWidth = 3.0;
        self.lineJoin = kCALineJoinRound;
        self.lineCap = kCALineCapRound;
        _startCount = 0;
        _endCount = 0;
        _selected = NO;
        _touchDistance = 20.0;
        _allowDrawArrow = YES;
        _startPoint = CGPointZero;
        _endPoint = CGPointZero;
        _type = WZMArrowViewTypeArrow;
        _normalColor = [UIColor blackColor];
        _selectedColor = [UIColor redColor];
        self.fillColor = _normalColor.CGColor;
        self.strokeColor = _normalColor.CGColor;
        
//        CGRect pathRect = CGRectMake(0.0, 0.0, 20.0, 20.0);
//        UIBezierPath *startPath = [UIBezierPath bezierPathWithRoundedRect:pathRect cornerRadius:pathRect.size.width/2.0];
//        self.startLayer = [[CAShapeLayer alloc] init];
//        self.startLayer.bounds = pathRect;
//        self.startLayer.wzm_center = self.startPoint;
//        self.startLayer.path = startPath.CGPath;
//        self.startLayer.lineWidth = 1.0;
//        self.startLayer.fillColor = [UIColor clearColor].CGColor;
//        self.startLayer.strokeColor = [UIColor whiteColor].CGColor;
//        [self addSublayer:self.startLayer];
//
//        UIBezierPath *endPath = [UIBezierPath bezierPathWithRoundedRect:pathRect cornerRadius:pathRect.size.width/2.0];
//        self.endLayer = [[CAShapeLayer alloc] init];
//        self.endLayer.bounds = pathRect;
//        self.endLayer.wzm_center = self.endPoint;
//        self.endLayer.path = endPath.CGPath;
//        self.endLayer.lineWidth = 1.0;
//        self.endLayer.fillColor = [UIColor clearColor].CGColor;
//        self.endLayer.strokeColor = [UIColor whiteColor].CGColor;
//        [self addSublayer:self.endLayer];
    }
    return self;
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

- (void)createLineWithPath:(UIBezierPath *)path {
    if (self.selected) {
        self.fillColor = self.selectedColor.CGColor;
        self.strokeColor = self.selectedColor.CGColor;
        
//        self.startLayer.hidden = NO;
//        self.endLayer.hidden = NO;
//        [CATransaction begin];
//        [CATransaction setDisableActions:YES];
//        self.startLayer.wzm_center = self.startPoint;
//        self.endLayer.wzm_center = self.endPoint;
//        [CATransaction setDisableActions:NO];
//        [CATransaction commit];
    }
    else {
        self.fillColor = self.normalColor.CGColor;
        self.strokeColor = self.normalColor.CGColor;
        
//        self.startLayer.hidden = YES;
//        self.endLayer.hidden = YES;
    }
    self.path = path.CGPath;
}

//箭头
- (void)createArrow {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.startPoint];
    [path addLineToPoint:self.endPoint];
    [path appendPath:[self createArrowPath]];
    [self createLineWithPath:path];
}

- (UIBezierPath *)createArrowPath {
    CGPoint controllPoint = CGPointZero;
    CGPoint pointUp = CGPointZero;
    CGPoint pointDown = CGPointZero;
    CGFloat distance = [self distanceBetweenPoint:self.startPoint otherPoint:self.endPoint];
    CGFloat distanceX = self.lineWidth*3.0 * (ABS(self.endPoint.x - self.startPoint.x) / distance);
    CGFloat distanceY = self.lineWidth*3.0 * (ABS(self.endPoint.y - self.startPoint.y) / distance);
    CGFloat distX = self.lineWidth*1.5 * (ABS(self.endPoint.y - self.startPoint.y) / distance);
    CGFloat distY = self.lineWidth*1.5 * (ABS(self.endPoint.x - self.startPoint.x) / distance);
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

//直线
- (void)createLine {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.startPoint];
    [path addLineToPoint:self.endPoint];
    [self createLineWithPath:path];
}

//双向箭头
- (void)createRulerArrow {
    UIBezierPath *path = [self createRulerArrowPath];
    [self createLineWithPath:path];
}

- (UIBezierPath *)createRulerArrowPath {
    CGFloat angle = [self angleWithFirstPoint:self.startPoint andSecondPoint:self.endPoint];
    CGPoint pointMiddle = CGPointMake((self.startPoint.x+self.endPoint.x)/2, (self.startPoint.y+self.endPoint.y)/2);
    CGFloat offsetX = 0.0*cos(angle);
    CGFloat offsetY = 0.0*sin(angle);
    CGPoint pointMiddle1 = CGPointMake(pointMiddle.x-offsetX, pointMiddle.y-offsetY);
    CGPoint pointMiddle2 = CGPointMake(pointMiddle.x+offsetX, pointMiddle.y+offsetY);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.startPoint];
    [path addLineToPoint:pointMiddle1];
    [path moveToPoint:pointMiddle2];
    [path addLineToPoint:self.endPoint];
    [path appendPath:[self createArrowWithStartPoint:pointMiddle1 endPoint:self.startPoint]];
    [path appendPath:[self createArrowWithStartPoint:pointMiddle2 endPoint:self.endPoint]];
    return path;
}

- (UIBezierPath *)createArrowWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    CGPoint controllPoint = CGPointZero;
    CGPoint pointUp = CGPointZero;
    CGPoint pointDown = CGPointZero;
    CGFloat distance = [self distanceBetweenPoint:startPoint otherPoint:endPoint];
    CGFloat distanceX = self.lineWidth*3.0 * (ABS(endPoint.x - startPoint.x) / distance);
    CGFloat distanceY = self.lineWidth*3.0 * (ABS(endPoint.y - startPoint.y) / distance);
    CGFloat distX = self.lineWidth*1.5 * (ABS(endPoint.y - startPoint.y) / distance);
    CGFloat distY = self.lineWidth*1.5 * (ABS(endPoint.x - startPoint.x) / distance);
    if (endPoint.x >= startPoint.x)
    {
        if (endPoint.y >= startPoint.y)
        {
            controllPoint = CGPointMake(endPoint.x - distanceX, endPoint.y - distanceY);
            pointUp = CGPointMake(controllPoint.x + distX, controllPoint.y - distY);
            pointDown = CGPointMake(controllPoint.x - distX, controllPoint.y + distY);
        }
        else
        {
            controllPoint = CGPointMake(endPoint.x - distanceX, endPoint.y + distanceY);
            pointUp = CGPointMake(controllPoint.x - distX, controllPoint.y - distY);
            pointDown = CGPointMake(controllPoint.x + distX, controllPoint.y + distY);
        }
    }
    else
    {
        if (endPoint.y >= startPoint.y)
        {
            controllPoint = CGPointMake(endPoint.x + distanceX, endPoint.y - distanceY);
            pointUp = CGPointMake(controllPoint.x - distX, controllPoint.y - distY);
            pointDown = CGPointMake(controllPoint.x + distX, controllPoint.y + distY);
        }
        else
        {
            controllPoint = CGPointMake(endPoint.x + distanceX, endPoint.y + distanceY);
            pointUp = CGPointMake(controllPoint.x + distX, controllPoint.y - distY);
            pointDown = CGPointMake(controllPoint.x - distX, controllPoint.y + distY);
        }
    }
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:endPoint];
    [arrowPath addLineToPoint:pointDown];
    [arrowPath addLineToPoint:pointUp];
    [arrowPath addLineToPoint:endPoint];
    return arrowPath;
}

//双向直线
- (void)createRulerLine {
    UIBezierPath *path = [self createRulerLinePath];
    [self createLineWithPath:path];
}

- (UIBezierPath *)createRulerLinePath {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:self.startPoint];
    CGFloat angle = [self angleWithFirstPoint:self.startPoint andSecondPoint:self.endPoint];
    CGPoint pointMiddle = CGPointMake((self.startPoint.x+self.endPoint.x)/2, (self.startPoint.y+self.endPoint.y)/2);
    CGFloat offsetX = 0.0*cos(angle);
    CGFloat offsetY = 0.0*sin(angle);
    CGPoint pointMiddle1 = CGPointMake(pointMiddle.x-offsetX, pointMiddle.y-offsetY);
    CGPoint pointMiddle2 = CGPointMake(pointMiddle.x+offsetX, pointMiddle.y+offsetY);
    [bezierPath addLineToPoint:pointMiddle1];
    [bezierPath moveToPoint:pointMiddle2];
    [bezierPath addLineToPoint:self.endPoint];
    [bezierPath moveToPoint:self.endPoint];
    angle = [self angleEndWithFirstPoint:self.startPoint andSecondPoint:self.endPoint];
    CGPoint point1 = CGPointMake(self.endPoint.x+10*sin(angle), self.endPoint.y+10*cos(angle));
    CGPoint point2 = CGPointMake(self.endPoint.x-10*sin(angle), self.endPoint.y-10*cos(angle));
    [bezierPath addLineToPoint:point1];
    [bezierPath addLineToPoint:point2];
    CGPoint point3 = CGPointMake(point1.x-(self.endPoint.x-self.startPoint.x), point1.y-(self.endPoint.y-self.startPoint.y));
    CGPoint point4 = CGPointMake(point2.x-(self.endPoint.x-self.startPoint.x), point2.y-(self.endPoint.y-self.startPoint.y));
    [bezierPath moveToPoint:point3];
    [bezierPath addLineToPoint:point4];
    [bezierPath setLineWidth:4];
    
    return bezierPath;
}

//tool
- (CGFloat)distanceBetweenPoint:(CGPoint)point otherPoint:(CGPoint)otherPoint {
    CGFloat xDist = (otherPoint.x - point.x);
    CGFloat yDist = (otherPoint.y - point.y);
    return sqrt((xDist * xDist) + (yDist * yDist));
}

- (CGFloat)angleWithFirstPoint:(CGPoint)firstPoint andSecondPoint:(CGPoint)secondPoint {
    CGFloat dx = secondPoint.x - firstPoint.x;
    CGFloat dy = secondPoint.y - firstPoint.y;
    CGFloat angle = atan2f(dy, dx);
    return angle;
}

- (CGFloat)angleEndWithFirstPoint:(CGPoint)firstPoint andSecondPoint:(CGPoint)secondPoint {
    CGFloat dx = secondPoint.x - firstPoint.x;
    CGFloat dy = secondPoint.y - firstPoint.y;
    CGFloat angle = atan2f(fabs(dy), fabs(dx));
    if (dx*dy>0) {
        return M_PI-angle;
    }
    return angle;
}

//setter
- (void)setStartPoint:(CGPoint)startPoint {
    if (CGPointEqualToPoint(_startPoint, startPoint)) return;
    _startPoint = startPoint;
    if (_startCount == 0) {
        _startCount = 1;
    }
    [self drawLine];
}

- (void)setEndPoint:(CGPoint)endPoint {
    if (CGPointEqualToPoint(_endPoint, endPoint)) return;
    _endPoint = endPoint;
    if (_endCount == 0) {
        _endCount = 1;
    }
    [self drawLine];
}

- (void)setSelected:(BOOL)selected {
    if (_selected == selected) return;
    _selected = selected;
    [self drawLine];
}

- (void)setNormalColor:(UIColor *)normalColor {
    _normalColor = normalColor;
    [self drawLine];
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    [self drawLine];
}

- (void)drawLine {
    if (self.allowDrawArrow == NO) return;
    if (_startCount == 0 || _endCount == 0) return;
    if (CGPointEqualToPoint(self.startPoint, self.endPoint)) return;
    if (self.type == WZMArrowViewTypeArrow) {
        [self createArrow];
    }
    else if (self.type == WZMArrowViewTypeLine) {
        [self createLine];
    }
    else if (self.type == WZMArrowViewTypeRulerArrow) {
        [self createRulerArrow];
    }
    else {
        [self createRulerLine];
    }
}

@end
