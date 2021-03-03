//
//  WZMDrawView2.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2021/3/3.
//  Copyright © 2021 wangzhaomeng. All rights reserved.
//

#import "WZMDrawView2.h"

@interface WZMDrawView2 ()

@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, strong) UIBezierPath *shapePath;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation WZMDrawView2

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lineWidth = 12.0;
        self.lineColor = [UIColor redColor];
        self.lines = [[NSMutableArray alloc] init];
        self.layer.masksToBounds = YES;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gesture locationInView:gesture.view];
        
        UIBezierPath *path = [[UIBezierPath alloc] init];
        path.lineWidth = self.lineWidth;
        //线条拐角
        path.lineCapStyle = kCGLineCapRound;
        //终点处理
        path.lineJoinStyle = kCGLineCapRound;
        [path moveToPoint:point];
        self.shapePath = path;
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
        layer.lineCap = kCALineCapRound;
        layer.lineJoin = kCALineJoinRound;
        layer.lineWidth = path.lineWidth;
        layer.strokeColor = self.lineColor.CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:layer];
        self.shapeLayer = layer;
        
        [self.lines addObject:self.shapeLayer];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [gesture locationInView:gesture.view];
        [self.shapePath addLineToPoint:point];
        self.shapeLayer.path = self.shapePath.CGPath;
    }
}

- (void)recover {
    if (self.lines.count == 0) return;
    [self.lines makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.lines removeAllObjects];
}

- (void)backforward {
    if (self.lines.count == 0) return;
    [self.lines.lastObject removeFromSuperlayer];
    [self.lines removeLastObject];
}

@end
