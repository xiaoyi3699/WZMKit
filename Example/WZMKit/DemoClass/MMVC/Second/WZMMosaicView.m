
#import "WZMMosaicView.h"

@interface WZMMosaicView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CALayer *mosaicImageLayer;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGMutablePathRef path;
@property (nonatomic, strong) NSMutableArray *lines;

@end

@implementation WZMMosaicView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lineWidth = 16.0;
        self.type = WZMMosaicViewTypeMosaic;
        self.lines = [[NSMutableArray alloc] initWithCapacity:0];
        //添加imageview（imageView）到self上
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:self.imageView];
        //添加layer（mosaicImageLayer）到self上
        self.mosaicImageLayer = [CALayer layer];
        self.mosaicImageLayer.frame = self.bounds;
        //self.mosaicImageLayer.wzm_contentMode = UIViewContentModeScaleAspectFill;
        [self.layer addSublayer:self.mosaicImageLayer];
        
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.frame = self.bounds;
        self.shapeLayer.lineCap = kCALineCapRound;
        self.shapeLayer.lineJoin = kCALineJoinRound;
        //手指移动时 画笔的宽度
        self.shapeLayer.lineWidth = self.lineWidth;
        self.shapeLayer.strokeColor = [UIColor blueColor].CGColor;
        self.shapeLayer.fillColor = nil;
        
        [self.layer addSublayer:self.shapeLayer];
        self.mosaicImageLayer.mask = self.shapeLayer;
        
        CGMutablePathRef pathRef = CGPathCreateMutable();
        self.path = CGPathCreateMutableCopy(pathRef);
        CGPathRelease(pathRef);
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGPathMoveToPoint(self.path, NULL, point.x, point.y);
    CGMutablePathRef startPath = CGPathCreateMutableCopy(self.path);
    self.shapeLayer.path = startPath;
    self.shapeLayer.lineWidth = self.lineWidth;
    CGPathRelease(startPath);
    
    NSMutableArray *pointArray = [[NSMutableArray alloc] initWithCapacity:0];
    [pointArray addObject:[NSValue valueWithCGPoint:point]];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:pointArray forKey:@"points"];
    [dic setObject:@(self.lineWidth) forKey:@"width"];
    [self.lines addObject:dic];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGPathAddLineToPoint(self.path, NULL, point.x, point.y);
    CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (!currentContext) {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 0);
    }
    CGContextAddPath(currentContext, path);
    [[UIColor blueColor] setStroke];
    CGContextDrawPath(currentContext, kCGPathStroke);
    self.shapeLayer.path = path;
    self.shapeLayer.lineWidth = self.lineWidth;
    CGPathRelease(path);
    
    NSDictionary *dic = [self.lines lastObject];
    NSMutableArray *pointArray = [dic objectForKey:@"points"];
    [pointArray addObject:[NSValue valueWithCGPoint:point]];
}

- (void)recover {
    if (self.lines.count) {
        [self recoverLayer];
        [self.lines removeAllObjects];
        [self setNeedsDisplay];
    }
}

- (void)backforward {
    if (self.lines.count) {
        [self recoverLayer];
        [self.lines removeLastObject];
        [self setNeedsDisplay];
    }
}

- (void)recoverLayer {
    CGMutablePathRef pathRef = CGPathCreateMutable();
    self.path = CGPathCreateMutableCopy(pathRef);
    CGPathRelease(pathRef);
    self.shapeLayer.path = nil;
}

- (void)drawRect:(CGRect)rect {
    if (self.image == nil) return;
    if (self.mosaicImageLayer.contents == nil) {
        //生成马赛克
        CIImage *ciImage = [[CIImage alloc] initWithImage:self.image];
        CIFilter *filter;
        if (self.type == WZMMosaicViewTypeBlur) {
            //高斯模糊
            filter = [CIFilter filterWithName:@"CIGaussianBlur"];
            [filter setValue:@(30) forKey:kCIInputRadiusKey];
        }
        else if (self.type == WZMMosaicViewTypeSepia) {
            filter = [CIFilter filterWithName:@"CISepiaTone"];
            [filter setValue:@(30) forKey:kCIInputIntensityKey];
        }
        else {
            //马赛克
            filter = [CIFilter filterWithName:@"CIPixellate"];
            [filter setValue:@(30) forKey:kCIInputScaleKey];
        }
        [filter setValue:ciImage  forKey:kCIInputImageKey];
        CIImage *outImage = [filter valueForKey:kCIOutputImageKey];
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = [context createCGImage:outImage fromRect:[outImage extent]];
        self.mosaicImageLayer.contents = (__bridge id)(cgImage);
        CGImageRelease(cgImage);
    }
    [_lines enumerateObjectsUsingBlock:^(NSMutableDictionary  *_Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *pointsArray = [dic objectForKey:@"points"];
        CGFloat lineWidth = [[dic objectForKey:@"width"] floatValue];
        if (pointsArray.count > 1) {
            CGPoint startPoint = [pointsArray[0] CGPointValue];
            CGPathMoveToPoint(self.path, NULL, startPoint.x, startPoint.y);
            CGMutablePathRef startPath = CGPathCreateMutableCopy(self.path);
            self.shapeLayer.path = startPath;
            self.shapeLayer.lineWidth = lineWidth;
            CGPathRelease(startPath);
            
            NSInteger count = pointsArray.count;
            for (NSInteger i = 1; i < count; i ++) {
                CGPoint endPoint = [pointsArray[i] CGPointValue];
                CGPathAddLineToPoint(self.path, NULL, endPoint.x, endPoint.y);
                CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
                
                CGContextRef currentContext = UIGraphicsGetCurrentContext();
                if (!currentContext) {
                    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 0);
                }
                CGContextAddPath(currentContext, path);
                [[UIColor blueColor] setStroke];
                CGContextDrawPath(currentContext, kCGPathStroke);
                self.shapeLayer.path = path;
                CGPathRelease(path);
            }
        }
    }];
}

- (void)setMosaicImage:(UIImage *)mosaicImage {
    _mosaicImage = mosaicImage;
    self.mosaicImageLayer.contents = (id)mosaicImage.CGImage;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
    
}

- (void)setLineWidth:(CGFloat)lineWidth {
    if (_lineWidth == lineWidth) return;
    _lineWidth = lineWidth;
    self.shapeLayer.lineWidth = _lineWidth;
}

- (void)dealloc {
    if (self.path) {
        CGPathRelease(_path);
    }
    NSLog(@"马赛克释放了");
}

@end
