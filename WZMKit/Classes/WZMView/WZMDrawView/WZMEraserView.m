#import "WZMEraserView.h"
#import "WZMInline.h"

@interface WZMEraserView ()

@property (nonatomic,strong) NSMutableArray *lines;

@end

@implementation WZMEraserView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lineWidth = 12.0;
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
        [dic setObject:@(self.lineWidth) forKey:@"width"];
        [self.lines addObject:dic];
        [self setNeedsDisplay];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSDictionary *dic = [self.lines lastObject];
        NSMutableArray *points = [dic objectForKey:@"points"];
        CGPoint point = [gesture locationInView:gesture.view];
        
        [points addObject:[NSValue valueWithCGPoint:point]];
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    if (self.image) {
        CGRect imageFrame = rect;
        if (self.contentMode == UIViewContentModeScaleAspectFit) {
            CGSize size = WZMSizeRatioToMaxSize(self.image.size, rect.size);
            CGFloat x = (rect.size.width - size.width)/2.0;
            CGFloat y = (rect.size.height - size.height)/2.0;
            imageFrame.origin = CGPointMake(x, y);
            imageFrame.size = size;
        }
        else if (self.contentMode == UIViewContentModeScaleAspectFill) {
            CGSize size = WZMSizeRatioToFillSize(self.image.size, rect.size);
            CGFloat x = (rect.size.width - size.width)/2.0;
            CGFloat y = (rect.size.height - size.height)/2.0;
            imageFrame.origin = CGPointMake(x, y);
            imageFrame.size = size;
        }
        [self.image drawInRect:imageFrame];
    }
    [_lines enumerateObjectsUsingBlock:^(NSMutableDictionary  *_Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *points = [dic objectForKey:@"points"];
        CGFloat lineWidth = [[dic objectForKey:@"width"] floatValue];
        if (points.count > 1) {
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGContextSetBlendMode(ctx, kCGBlendModeClear);
            CGPoint startPoint = [points[0] CGPointValue];
            CGContextMoveToPoint(ctx, startPoint.x, startPoint.y);
            NSInteger count = points.count;
            for (NSInteger i = 1; i < count; i ++) {
                CGPoint endPoint = [points[i] CGPointValue];
                CGContextAddLineToPoint(ctx, endPoint.x, endPoint.y);
            }
            CGContextSetLineWidth(ctx, lineWidth);
            CGContextSetLineCap(ctx, kCGLineCapRound);
            CGContextSetLineJoin(ctx, kCGLineJoinRound);
            CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
            CGContextSetStrokeColorWithColor(ctx, [UIColor clearColor].CGColor);
            CGContextStrokePath(ctx);
        }
    }];
}

@end
