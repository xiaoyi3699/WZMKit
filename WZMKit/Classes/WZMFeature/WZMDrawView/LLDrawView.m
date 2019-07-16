#import "LLDrawView.h"

@interface LLDrawView ()

@property (nonatomic,strong) NSMutableArray *lines;

@end

@implementation LLDrawView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lineWidth = 12;
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
        [dic setObject:@(self.lineWidth) forKey:@"width"];
        [self.lines addObject:dic];
    }
    else {
        NSDictionary *dic = [self.lines lastObject];
        NSMutableArray *points = [dic objectForKey:@"points"];
        CGPoint point = [gesture locationInView:gesture.view];
        [points addObject:[NSValue valueWithCGPoint:point]];
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    [_lines enumerateObjectsUsingBlock:^(NSMutableDictionary  *_Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *points = [dic objectForKey:@"points"];
        UIColor *color = [dic objectForKey:@"color"];
        CGFloat lineWidth = [[dic objectForKey:@"width"] floatValue];
        if (points.count > 1) {
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGPoint startPoint = [points[0] CGPointValue];
            CGContextMoveToPoint(ctx, startPoint.x, startPoint.y);
            NSInteger count = points.count;
            for (NSInteger i = 1; i < count; i ++) {
                CGPoint endPoint = [points[i] CGPointValue];
                CGContextAddLineToPoint(ctx, endPoint.x, endPoint.y);
            }
            CGContextSetLineJoin(ctx, kCGLineJoinRound);
            CGContextSetLineCap(ctx, kCGLineCapRound);
            CGContextSetLineWidth(ctx, lineWidth);
            CGContextSetStrokeColorWithColor(ctx, color.CGColor);
            CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
            CGContextStrokePath(ctx);
        }
    }];
}

@end
