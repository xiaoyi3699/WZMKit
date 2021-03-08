//
//  WZMArrowView.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2021/3/8.
//  Copyright © 2021 wangzhaomeng. All rights reserved.
//

#import "WZMArrowView.h"

@interface WZMArrowView ()

@property (nonatomic, strong) WZMArrowLayer *shapeLayer;
@property (nonatomic, strong) WZMArrowLayer *createLayer;
@property (nonatomic, strong) NSMutableArray *shapeLayers;

@end

@implementation WZMArrowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.shapeLayers = [[NSMutableArray alloc] init];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector((tapGesture:))];
        [self addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)recover {
    if (self.shapeLayers.count == 0) return;
    for (WZMArrowLayer *layer in self.shapeLayers) {
        [layer removeFromSuperlayer];
    }
    [self.shapeLayers removeAllObjects];
}

- (void)backforward {
    if (self.shapeLayers.count == 0) return;
    WZMArrowLayer *layer = self.shapeLayers.lastObject;
    if (self.shapeLayer == layer) {
        self.shapeLayer = nil;
    }
    [layer removeFromSuperlayer];
    [self.shapeLayers removeLastObject];
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    for (WZMArrowLayer *layer in self.shapeLayers) {
        WZMArrowViewTouchType type = [layer caculateLocationWithPoint:point];
        if (type != WZMArrowViewTouchTypeNone) {
            if (self.shapeLayer == layer) {
                self.shapeLayer = nil;
                layer.selected = NO;
            }
            else {
                self.shapeLayer.selected = NO;
                self.shapeLayer = layer;
                self.shapeLayer.selected = YES;
            }
            break;
        }
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    static BOOL createLayer = YES;
    static WZMArrowViewTouchType type;
    static CGPoint startPoint, endPoint;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gesture locationInView:self];
        createLayer = YES;
        if (self.shapeLayer && self.shapeLayer.selected) {
            type = [self.shapeLayer caculateLocationWithPoint:point];
            if (type != WZMArrowViewTouchTypeNone) {
                createLayer = NO;
            }
        }
        if (createLayer) {
            self.createLayer = [[WZMArrowLayer alloc] init];
            self.createLayer.frame = self.bounds;
            self.createLayer.startPoint = point;
            [self.layer addSublayer:self.createLayer];
            [self.shapeLayers addObject:self.createLayer];
        }
        else {
            startPoint = self.shapeLayer.startPoint;
            endPoint = self.shapeLayer.endPoint;
        }
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        if (createLayer) {
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
            self.createLayer.endPoint = point;
        }
        else {
            if (type == WZMArrowViewTouchTypeNone) return;
            if (type == WZMArrowViewTouchTypeMid) {
                CGPoint point = [gesture translationInView:self];
                //起点
                if (startPoint.x + point.x < 0.0) {
                    point.x = -startPoint.x;
                }
                if (startPoint.y + point.y < 0.0) {
                    point.y = -startPoint.y;
                }
                if (startPoint.x + point.x > self.bounds.size.width) {
                    point.x = self.bounds.size.width - startPoint.x;
                }
                if (startPoint.y + point.y > self.bounds.size.height) {
                    point.y = self.bounds.size.height - startPoint.y;
                }
                //终点
                if (endPoint.x + point.x < 0.0) {
                    point.x = -endPoint.x;
                }
                if (endPoint.y + point.y < 0.0) {
                    point.y = -endPoint.y;
                }
                if (endPoint.x + point.x > self.bounds.size.width) {
                    point.x = self.bounds.size.width - endPoint.x;
                }
                if (endPoint.y + point.y > self.bounds.size.height) {
                    point.y = self.bounds.size.height - endPoint.y;
                }
                CGPoint sPoint = CGPointMake(startPoint.x+point.x, startPoint.y+point.y);
                self.shapeLayer.allowDrawArrow = NO;
                self.shapeLayer.startPoint = sPoint;
                CGPoint ePoint = CGPointMake(endPoint.x+point.x, endPoint.y+point.y);
                self.shapeLayer.allowDrawArrow = YES;
                self.shapeLayer.endPoint = ePoint;
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
                    self.shapeLayer.startPoint = point;
                }
                else {
                    self.shapeLayer.endPoint = point;
                }
            }
        }
    }
    else if (gesture.state == UIGestureRecognizerStateEnded ||
             gesture.state == UIGestureRecognizerStateCancelled) {
        if (createLayer) {
            self.createLayer = nil;
        }
    }
}

@end
