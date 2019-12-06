//
//  WZMNoteAnimation.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/12/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMNoteAnimation.h"

@interface WZMNoteAnimation ()

@property (nonatomic, strong) UIView *preview;
@property (nonatomic, strong) UIView *noteView;
@property (nonatomic, strong) UIBezierPath *bezierPath;

@end

@implementation WZMNoteAnimation

- (instancetype)initWithFrame:(CGRect)frame config:(WZMNoteConfig *)config {
    self = [super init];
    if (self) {
        self.config = config;
        
        self.preview = [[UIView alloc] initWithFrame:frame];
        self.preview.wzm_borderColor = [UIColor redColor];
        self.preview.wzm_borderWidth = 0.5;
        
        self.noteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        self.noteView.backgroundColor = [UIColor redColor];
        [self.preview addSubview:self.noteView];
        
        [self layoutPreview];
    }
    return self;
}

- (void)layoutPreview {
    if (self.config.text.length <= 0) return;
    //单个字的宽和高
    CGFloat singleW = (self.preview.bounds.size.width/self.config.text.length);
    //音符上下波动间距
    CGFloat dy = self.preview.bounds.size.height-singleW;
    //音符起始x、y坐标
    CGFloat startX = 0.0, startY = dy;
    
    NSMutableArray *words = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *layers = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *points = [[NSMutableArray alloc] initWithCapacity:0];
    UIFont *font = [UIFont systemFontOfSize:20];
    for (NSInteger i = 0; i < self.config.text.length; i ++) {
        @autoreleasepool {
            NSString *word = [self.config.text substringWithRange:NSMakeRange(i, 1)];
            [words addObject:word];
            
            CGRect rect = CGRectMake(startX+i*singleW, startY, singleW, singleW);
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.string = word;
            textLayer.font = (__bridge CFTypeRef _Nullable)(font);
            textLayer.fontSize = 20;
            textLayer.alignmentMode = kCAAlignmentCenter;
            textLayer.frame = rect;
            textLayer.foregroundColor = [UIColor redColor].CGColor;
            textLayer.backgroundColor = [UIColor clearColor].CGColor;
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            [self.preview.layer addSublayer:textLayer];
            [layers addObject:textLayer];
            
            CGPoint point1 = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
            CGPoint point2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect)-dy);
            [points addObject:NSStringFromCGPoint(point1)];
            [points addObject:NSStringFromCGPoint(point2)];
        }
    }
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth = 1;
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineCapRound;
    if (points.count > 1) {
        CGPoint startPoint = CGPointFromString(points[0]);
        [bezierPath moveToPoint:startPoint];
        NSInteger count = points.count;
        for (NSInteger i = 1; i < count; i ++) {
            CGPoint endPoint = CGPointFromString(points[i]);
            [bezierPath addLineToPoint:endPoint];
        }
    }
    self.bezierPath = bezierPath;
}

- (UIView *)startNoteAnimationInView:(UIView *)superview {
    if (self.preview.superview == nil) {
        [superview addSubview:self.preview];
    }
    else {
        [self.noteView.layer removeAnimationForKey:@"noteAnimation"];
    }
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    //设置动画属性，因为是沿着贝塞尔曲线动，所以要设置为position
    animation.keyPath = @"position";
    //设置动画时间
    animation.duration = 2;
    // 告诉在动画结束的时候不要移除
    animation.removedOnCompletion = NO;
    // 始终保持最新的效果
    animation.fillMode = kCAFillModeForwards;
    // 设置贝塞尔曲线路径
    animation.path = self.bezierPath.CGPath;
    // 将动画对象添加到视图的layer上
    [self.noteView.layer addAnimation:animation forKey:@"noteAnimation"];
    
    return self.preview;
}

@end
