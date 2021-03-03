//
//  WZMDrawView.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2021/3/3.
//  Copyright © 2021 wangzhaomeng. All rights reserved.
//

#import "WZMDrawView.h"
#import "WZMInline.h"
#import "UIImage+wzmcate.h"

@interface WZMDrawView ()

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, strong) UIBezierPath *shapePath;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation WZMDrawView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lineDotted = NO;
        self.lineWidth = 12.0;
        self.imageSpacing = 20.0;
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
        self.index = 0;
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
        if (self.lineDotted) {
            layer.lineDashPattern = @[@(path.lineWidth*4.0), @(path.lineWidth*2.5)];
        }
        [self.layer addSublayer:layer];
        self.shapeLayer = layer;
        
        [self.lines addObject:self.shapeLayer];
        
        self.lastPoint = point;
        [self addLineToPoint:point];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [gesture locationInView:gesture.view];
        if (self.images.count) {
            if (self.imageSpacing > 0.0) {
                if (fabs(point.x-self.lastPoint.x) > self.imageSpacing || fabs(point.y-self.lastPoint.y) > self.imageSpacing) {
                    self.lastPoint = point;
                    [self addLineToPoint:point];
                }
            }
            else {
                CGFloat dx = point.x - self.lastPoint.x;
                CGFloat dy = point.y - self.lastPoint.y;
                NSInteger dd = MAX(fabs(dx), fabs(dy));
                if (dd > 0) {
                    CGFloat ddx = dx/dd;
                    CGFloat ddy = dy/dd;
                    for (NSInteger i = 0; i < dd; i ++) {
                        CGPoint dPoint = CGPointMake(self.lastPoint.x+ddx, self.lastPoint.y+ddy);
                        self.lastPoint = dPoint;
                        [self drawImageAtPoint:dPoint];
                    }
                }
                else {
                    self.lastPoint = point;
                    [self drawImageAtPoint:point];
                }
            }
        }
        else {
            [self addLineToPoint:point];
        }
    }
}

- (void)addLineToPoint:(CGPoint)point {
    [self.shapePath addLineToPoint:point];
    self.shapeLayer.path = self.shapePath.CGPath;
    [self drawImageAtPoint:point];
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

- (void)drawImageAtPoint:(CGPoint)point {
    if (self.images.count == 0) return;
    self.index ++;
    UIImage *image;
    id img = [self.images objectAtIndex:(self.index%(self.images.count))];
    if ([img isKindOfClass:[NSString class]]) {
        image = [UIImage imageNamed:img];
    }
    else if ([img isKindOfClass:[UIImage class]]) {
        image = img;
    }
    if (image == nil) return;
    CGSize imageSize = WZMSizeRatioToMaxSize(image.size, CGSizeMake(self.lineWidth, self.lineWidth));
    CGRect imageRect = CGRectZero;
    imageRect.size = imageSize;
    imageRect.origin.x = (point.x - imageSize.width/2.0);
    imageRect.origin.y = (point.y - imageSize.height/2.0);
    
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = imageRect;
    layer.contents = (__bridge id)((image.CGImage));
    [self.shapeLayer addSublayer:layer];
}

- (void)setImageColor:(UIColor *)imageColor {
    if (_images.count && imageColor) {
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (UIImage *image in _images) {
            UIImage *img = [image wzm_changeColor:imageColor];
            [images addObject:img];
        }
        _images = [images copy];
    }
    _imageColor = imageColor;
}

- (void)setImages:(NSArray *)images {
    if (_imageColor && images.count) {
        NSMutableArray *imgs = [[NSMutableArray alloc] init];
        for (UIImage *image in images) {
            UIImage *img = [image wzm_changeColor:_imageColor];
            [imgs addObject:img];
        }
        images = [imgs copy];
    }
    _images = images;
}

@end
