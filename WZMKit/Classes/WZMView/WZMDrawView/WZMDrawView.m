#import "WZMDrawView.h"
#import "WZMInline.h"

@interface WZMDrawView ()

@property (nonatomic,strong) NSMutableArray *lines;

@end

@implementation WZMDrawView {
    CGPoint _lastPoint;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dotted = NO;
        self.eraser = NO;
        self.hbSize = 20.0;
        self.spacing = 30.0;
        self.lineWidth = 12.0;
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
        [dic setObject:@(self.isDotted) forKey:@"dotted"];
        [dic setObject:@(self.isEraser) forKey:@"eraser"];
        if (self.hbImages.count) {
            [dic setObject:self.hbImages forKey:@"images"];
            [dic setObject:@(self.hbSize) forKey:@"hbSize"];
        }
        [self.lines addObject:dic];
        
        if (self.hbImages.count) {
            _lastPoint = point;
            [self setNeedsDisplay];
        }
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSDictionary *dic = [self.lines lastObject];
        NSMutableArray *points = [dic objectForKey:@"points"];
        CGPoint point = [gesture locationInView:gesture.view];
        
        if (self.hbImages.count) {
            if (fabs(point.x-_lastPoint.x) > self.spacing || fabs(point.y-_lastPoint.y) > self.spacing) {
                _lastPoint = point;
                [points addObject:[NSValue valueWithCGPoint:point]];
                [self setNeedsDisplay];
            }
        }
        else {
            [points addObject:[NSValue valueWithCGPoint:point]];
            [self setNeedsDisplay];
        }
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
        NSArray *images = [dic objectForKey:@"images"];
        CGFloat hbSize = [[dic objectForKey:@"hbSize"] floatValue];
        if (images.count) {
            for (NSInteger i = 0; i < points.count; i ++) {
                UIImage *image;
                id img = [images objectAtIndex:(i%(images.count))];
                if ([img isKindOfClass:[NSString class]]) {
                    image = [UIImage imageNamed:img];
                }
                else if ([img isKindOfClass:[UIImage class]]) {
                    image = img;
                }
                if (image == nil) return;
                CGPoint point = [points[i] CGPointValue];
                
                CGSize imageSize = WZMSizeRatioToMaxSize(image.size, CGSizeMake(hbSize, hbSize));
                CGRect imageRect = CGRectZero;
                imageRect.size = imageSize;
                imageRect.origin.x = (point.x - imageSize.width/2.0);
                imageRect.origin.y = (point.y - imageSize.height/2.0);
                [image drawInRect:imageRect];
            }
        }
        else {
            UIColor *color = [dic objectForKey:@"color"];
            CGFloat lineWidth = [[dic objectForKey:@"width"] floatValue];
            BOOL dotted = [[dic objectForKey:@"dotted"] boolValue];
            BOOL eraser = [[dic objectForKey:@"eraser"] boolValue];
            if (points.count > 1) {
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                if (eraser) {
                    CGContextSetBlendMode(ctx, kCGBlendModeClear);
                }
                else {
                    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
                }
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
                CGContextSetStrokeColorWithColor(ctx, color.CGColor);
                if (dotted && eraser == NO) {
                    CGFloat lengths[]= {lineWidth*4.0, lineWidth*2.0};
                    CGContextSetLineDash(ctx, 0.0, lengths, 2);
                }
                else {
                    CGFloat d = lineWidth;
                    if (!dotted) {
                        d = 0.01;
                    }
                    CGFloat lengths[]= {d*4.0, d*2.0};
                    CGContextSetLineDash(ctx, 0.0, lengths, 2);
                }
                CGContextStrokePath(ctx);
            }
        }
    }];
}

- (void)drawImage:(NSArray *)images index:(NSInteger)index point:(CGPoint)point size:(CGFloat)size {
    UIImage *image;
    id img = [images objectAtIndex:(index%(images.count))];
    if ([img isKindOfClass:[NSString class]]) {
        image = [UIImage imageNamed:img];
    }
    else if ([img isKindOfClass:[UIImage class]]) {
        image = img;
    }
    if (image == nil) return;
    CGSize imageSize = WZMSizeRatioToMaxSize(image.size, CGSizeMake(size, size));
    CGRect imageRect = CGRectZero;
    imageRect.size = imageSize;
    imageRect.origin.x = (point.x - imageSize.width/2.0);
    imageRect.origin.y = (point.y - imageSize.height/2.0);
    
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = imageRect;
    layer.contents = (__bridge id)((image.CGImage));
    [self.layer addSublayer:layer];
}

@end
