
#import "WZMMosaicView.h"

@interface WZMMosaicView ()

@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSMutableDictionary *pathDic;
@property (nonatomic, strong) NSMutableDictionary *shapeLayerDic;
@property (nonatomic, strong) NSMutableDictionary *mosaicImageLayerDic;

@end

@implementation WZMMosaicView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lineWidth = 16.0;
        self.type = WZMMosaicViewTypeMosaic;
        self.lines = [[NSMutableArray alloc] initWithCapacity:0];
        
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:self.imageView];
        
        self.pathDic = [[NSMutableDictionary alloc] init];
        self.shapeLayerDic = [[NSMutableDictionary alloc] init];
        self.mosaicImageLayerDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - public method
//清空
- (void)recover {
    if (self.lines.count) {
        [self recoverLayer];
        [self.lines removeAllObjects];
        [self setNeedsDisplay];
    }
}

//撤销
- (void)backforward {
    if (self.lines.count) {
        [self recoverLayer];
        [self.lines removeLastObject];
        [self setNeedsDisplay];
    }
}

#pragma mark - private method
- (void)recoverLayer {
    for (NSString *key in self.pathDic.allKeys) {
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGMutablePathRef path = CGPathCreateMutableCopy(pathRef);
        CGPathRelease(pathRef);
        [self.pathDic setValue:(__bridge id)(path) forKey:key];
    }
    for (CAShapeLayer *shapeLayer in self.shapeLayerDic.allValues) {
        shapeLayer.path = nil;
    }
}

- (void)createMosaicLayersIfNeed {
    NSString *key = [self getKey:self.type];
    CALayer *mosaicImageLayer = [self.mosaicImageLayerDic valueForKey:key];
    if (mosaicImageLayer == nil) {
        mosaicImageLayer = [CALayer layer];
        mosaicImageLayer.frame = self.bounds;
        //mosaicImageLayer.wzm_contentMode = UIViewContentModeScaleAspectFill;
        [self.layer addSublayer:mosaicImageLayer];
        [self.mosaicImageLayerDic setValue:mosaicImageLayer forKey:key];
    }
    CAShapeLayer *shapeLayer = [self.shapeLayerDic valueForKey:key];
    if (shapeLayer == nil) {
        shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = self.bounds;
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineWidth = self.lineWidth;
        shapeLayer.strokeColor = [UIColor blueColor].CGColor;
        shapeLayer.fillColor = nil;
        [self.layer addSublayer:shapeLayer];
        mosaicImageLayer.mask = shapeLayer;
        [self.shapeLayerDic setValue:shapeLayer forKey:key];
    }
    
    CGMutablePathRef path = (__bridge CGMutablePathRef)([self.pathDic valueForKey:key]);
    if (path == nil) {
        CGMutablePathRef pathRef = CGPathCreateMutable();
        path = CGPathCreateMutableCopy(pathRef);
        CGPathRelease(pathRef);
        [self.pathDic setValue:(__bridge id)(path) forKey:key];
    }
}

- (void)createMosaicImageIfNeed {
    for (NSString *key in self.mosaicImageLayerDic.allKeys) {
        CALayer *mosaicImageLayer = [self.mosaicImageLayerDic valueForKey:key];
        if (mosaicImageLayer.contents == nil) {
            //生成马赛克
            UIImage *image = self.mosaicImage;
            if (image == nil) {
                image = self.image;
            }
            CIImage *ciImage = [[CIImage alloc] initWithImage:image];
            CIFilter *filter;
            WZMMosaicViewType type = (WZMMosaicViewType)key.integerValue;
            if (type == WZMMosaicViewTypeBlur) {
                //高斯模糊
                filter = [CIFilter filterWithName:@"CIGaussianBlur"];
                [filter setValue:@(30) forKey:kCIInputRadiusKey];
            }
            else if (type == WZMMosaicViewTypeSepia) {
                //色调
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
            mosaicImageLayer.contents = (__bridge id)(cgImage);
            CGImageRelease(cgImage);
        }
    }
}

#pragma mark - setter
- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

- (void)setType:(WZMMosaicViewType)type {
    if (_type == type) return;
    _type = type;
    if (self.superview) {
        [self createMosaicLayersIfNeed];
        [self setNeedsDisplay];
    }
}

- (void)setLineWidth:(CGFloat)lineWidth {
    if (_lineWidth == lineWidth) return;
    _lineWidth = lineWidth;
    if (self.superview) {
        [self setNeedsDisplay];
    }
}

- (NSString *)getKey:(WZMMosaicViewType)i {
    return [NSString stringWithFormat:@"%@",@(i)];
}

#pragma mark - super method
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        [self createMosaicLayersIfNeed];
        [self createMosaicImageIfNeed];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    NSString *key = [self getKey:self.type];
    CAShapeLayer *shapeLayer = [self.shapeLayerDic valueForKey:key];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGMutablePathRef path = (__bridge CGMutablePathRef)([self.pathDic valueForKey:key]);
    CGPathMoveToPoint(path, NULL, point.x, point.y);
    CGMutablePathRef startPath = CGPathCreateMutableCopy(path);
    shapeLayer.path = startPath;
    shapeLayer.lineWidth = self.lineWidth;
    CGPathRelease(startPath);
    
    NSMutableArray *pointArray = [[NSMutableArray alloc] initWithCapacity:0];
    [pointArray addObject:[NSValue valueWithCGPoint:point]];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:pointArray forKey:@"points"];
    [dic setObject:@(self.type) forKey:@"type"];
    [dic setObject:@(self.lineWidth) forKey:@"width"];
    [self.lines addObject:dic];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    NSString *key = [self getKey:self.type];
    CAShapeLayer *shapeLayer = [self.shapeLayerDic valueForKey:key];
    CGMutablePathRef path = (__bridge CGMutablePathRef)([self.pathDic valueForKey:key]);
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    CGMutablePathRef pathRef = CGPathCreateMutableCopy(path);
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (!currentContext) {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 0);
    }
    CGContextAddPath(currentContext, pathRef);
    [[UIColor blueColor] setStroke];
    CGContextDrawPath(currentContext, kCGPathStroke);
    shapeLayer.path = pathRef;
    shapeLayer.lineWidth = self.lineWidth;
    CGPathRelease(pathRef);
    
    NSDictionary *dic = [self.lines lastObject];
    NSMutableArray *pointArray = [dic objectForKey:@"points"];
    [pointArray addObject:[NSValue valueWithCGPoint:point]];
}

- (void)drawRect:(CGRect)rect {
    if (self.image == nil) return;
    [self createMosaicImageIfNeed];
    [_lines enumerateObjectsUsingBlock:^(NSMutableDictionary  *_Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *pointsArray = [dic objectForKey:@"points"];
        CGFloat lineWidth = [[dic objectForKey:@"width"] floatValue];
        WZMMosaicViewType type = [[dic objectForKey:@"type"] integerValue];
        NSString *key = [self getKey:type];
        CAShapeLayer *shapeLayer = [self.shapeLayerDic valueForKey:key];
        CGMutablePathRef path = (__bridge CGMutablePathRef)([self.pathDic valueForKey:key]);
        if (pointsArray.count > 1) {
            CGPoint startPoint = [pointsArray[0] CGPointValue];
            CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
            CGMutablePathRef startPath = CGPathCreateMutableCopy(path);
            shapeLayer.path = startPath;
            shapeLayer.lineWidth = lineWidth;
            CGPathRelease(startPath);
            
            NSInteger count = pointsArray.count;
            for (NSInteger i = 1; i < count; i ++) {
                CGPoint endPoint = [pointsArray[i] CGPointValue];
                CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
                CGMutablePathRef pathRef = CGPathCreateMutableCopy(path);
                
                CGContextRef currentContext = UIGraphicsGetCurrentContext();
                if (!currentContext) {
                    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 0);
                }
                CGContextAddPath(currentContext, pathRef);
                [[UIColor blueColor] setStroke];
                CGContextDrawPath(currentContext, kCGPathStroke);
                shapeLayer.path = pathRef;
                CGPathRelease(pathRef);
            }
        }
    }];
}

- (void)dealloc {
    for (NSString *key in self.pathDic.allKeys) {
        CGMutablePathRef path = (__bridge CGMutablePathRef)([self.pathDic valueForKey:key]);
        if (path) {
            CGPathRelease(path);
        }
    }
    NSLog(@"马赛克释放了");
}

@end
