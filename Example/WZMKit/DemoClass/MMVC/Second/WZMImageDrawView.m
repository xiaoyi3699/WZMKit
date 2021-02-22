//
//  WZMImageDrawView.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2021/2/22.
//  Copyright © 2021 wangzhaomeng. All rights reserved.
//

#import "WZMImageDrawView.h"
@interface WZMImageDrawView ()

@property (nonatomic,strong) NSMutableArray *lines;

@end

@implementation WZMImageDrawView {
    CGPoint _lastPoint;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.width = 20.0;
        self.color = [UIColor redColor];
        self.backgroundColor = [UIColor clearColor];
        _lines = [[NSMutableArray alloc] initWithCapacity:0];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)recover {
    if (self.lines.count) {
        [self.lines removeAllObjects];
        [self setNeedsDisplay];
    }
}

- (void)backforward {
    if (self.lines.count) {
        [self.lines removeLastObject];
        [self setNeedsDisplay];
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSMutableArray *points = [[NSMutableArray alloc] initWithCapacity:0];
        CGPoint point = [gesture locationInView:gesture.view];
        [points addObject:[NSValue valueWithCGPoint:point]];
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
        [dic setObject:points forKey:@"points"];
        [dic setObject:self.color forKey:@"color"];
        [self.lines addObject:dic];
        
        _lastPoint = point;
        [self setNeedsDisplay];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSDictionary *dic = [self.lines lastObject];
        NSMutableArray *points = [dic objectForKey:@"points"];
        CGPoint point = [gesture locationInView:gesture.view];
        
        CGFloat dx = point.x - _lastPoint.x;
        CGFloat dy = point.y - _lastPoint.y;
        NSInteger dd = MAX(fabs(dx), fabs(dy));
        if (dd > 0) {
            CGFloat ddx = dx/dd;
            CGFloat ddy = dy/dd;
            for (NSInteger i = 0; i < dd; i ++) {
                CGPoint dPoint = CGPointMake(_lastPoint.x+ddx, _lastPoint.y+ddy);
                _lastPoint = dPoint;
                [points addObject:[NSValue valueWithCGPoint:dPoint]];
                [self drawImageAtPoint:dPoint];
            }
        }
        else {
            _lastPoint = point;
            [points addObject:[NSValue valueWithCGPoint:point]];
            [self drawImageAtPoint:point];
        }
    }
}

- (void)drawImageAtPoint:(CGPoint)point {
    UIImage *image = self.image;
    if (self.color) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    CGSize imageSize = WZMSizeRatioToMaxSize(image.size, CGSizeMake(self.width, self.width));
    CGRect imageRect = CGRectZero;
    imageRect.size = imageSize;
    imageRect.origin.x = (point.x - imageSize.width/2.0);
    imageRect.origin.y = (point.y - imageSize.height/2.0);
    
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = imageRect;
    layer.contents = CFBridgingRelease(image.CGImage);
    [self.layer addSublayer:layer];
}

@end
