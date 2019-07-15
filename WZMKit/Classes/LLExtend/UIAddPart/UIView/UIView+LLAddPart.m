//
//  UIView+AddPart.m
//  test
//
//  Created by wangzhaomeng on 16/8/5.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "UIView+LLAddPart.h"
#import "LLDispatch.h"

@implementation UIView (LLAddPart)

- (UIViewController *)viewController{
    UIResponder *next = [self nextResponder];
    do{
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next);
    return nil;
}

- (BOOL)ll_isDescendantOfView:(UIView *)otherView {
    return [self isDescendantOfView:otherView];
}

#pragma - mark 自定义适配
//设置位置(宽和高保持不变)
- (CGFloat)minX{
    return CGRectGetMinX(self.frame);
}

- (void)setMinX:(CGFloat)minX{
    CGRect rect = self.frame;
    rect.origin.x = minX;
    self.frame = rect;
}

- (CGFloat)maxX{
    return CGRectGetMaxX(self.frame);
}

- (void)setMaxX:(CGFloat)maxX{
    CGRect rect = self.frame;
    rect.origin.x = maxX-CGRectGetWidth(rect);
    self.frame = rect;
}

- (CGFloat)minY{
    return CGRectGetMinY(self.frame);
}

- (void)setMinY:(CGFloat)minY{
    CGRect rect = self.frame;
    rect.origin.y = minY;
    self.frame = rect;
}

- (CGFloat)maxY{
    return CGRectGetMaxY(self.frame);
}

- (void)setMaxY:(CGFloat)maxY{
    CGRect rect = self.frame;
    rect.origin.y = maxY-CGRectGetHeight(rect);
    self.frame = rect;
}

- (CGFloat)LLCenterX{
    return CGRectGetMidX(self.frame);
}

- (void)setLLCenterX:(CGFloat)LLCenterX{
    self.center = CGPointMake(LLCenterX, CGRectGetMidY(self.frame));
}

- (CGFloat)LLCenterY{
    return CGRectGetMidY(self.frame);
}

- (void)setLLCenterY:(CGFloat)LLCenterY{
    self.center = CGPointMake(CGRectGetMidX(self.frame), LLCenterY);
}

- (CGPoint)LLPostion{
    return CGPointMake(self.minX, self.minY);
}

- (void)setLLPostion:(CGPoint)LLPostion{
    CGRect rect = self.frame;
    rect.origin.x = LLPostion.x;
    rect.origin.y = LLPostion.y;
    self.frame = rect;
}

//设置位置(其他顶点保持不变)
- (CGFloat)mutableMinX{
    return self.minX;
}

- (void)setMutableMinX:(CGFloat)mutableMinX{
    CGRect rect = self.frame;
    rect.origin.x = mutableMinX;
    rect.size.width = self.maxX-mutableMinX;
    self.frame = rect;
}

- (CGFloat)mutableMaxX{
    return self.maxX;
}

- (void)setMutableMaxX:(CGFloat)mutableMaxX{
    CGRect rect = self.frame;
    rect.size.width = mutableMaxX-self.minX;
    self.frame = rect;
}

- (CGFloat)mutableMinY{
    return self.minY;
}

- (void)setMutableMinY:(CGFloat)mutableMinY{
    CGRect rect = self.frame;
    rect.origin.y = mutableMinY;
    rect.size.height = self.maxY-mutableMinY;
    self.frame = rect;
}

- (CGFloat)mutableMaxY{
    return self.maxY;
}

- (void)setMutableMaxY:(CGFloat)mutableMaxY{
    CGRect rect = self.frame;
    rect.size.height = mutableMaxY-self.minY;
    self.frame = rect;
}

//设置宽和高(位置不变)
- (CGFloat)LLWidth{
    return CGRectGetWidth(self.frame);
}

- (void)setLLWidth:(CGFloat)LLWidth{
    CGRect rect = self.frame;
    rect.size.width = LLWidth;
    self.frame = rect;
}

- (CGFloat)LLHeight{
    return CGRectGetHeight(self.frame);
}

- (void)setLLHeight:(CGFloat)LLHeight{
    CGRect rect = self.frame;
    rect.size.height = LLHeight;
    self.frame = rect;
}

- (CGSize)LLSize{
    return CGSizeMake(self.LLWidth, self.LLHeight);
}

- (void)setLLSize:(CGSize)LLSize{
    CGRect rect = self.frame;
    rect.size.width = LLSize.width;
    rect.size.height = LLSize.height;
    self.frame = rect;
}

//设置宽和高(中心点不变)
- (CGFloat)center_width{
    return CGRectGetWidth(self.frame);
}

- (void)setCenter_width:(CGFloat)center_width{
    CGRect rect = self.frame;
    CGFloat dx = (center_width-CGRectGetWidth(rect))/2.0;
    rect.origin.x -= dx;
    rect.size.width = center_width;
    self.frame = rect;
}

- (CGFloat)center_height{
    return CGRectGetHeight(self.frame);
}

- (void)setCenter_height:(CGFloat)center_height{
    CGRect rect = self.frame;
    CGFloat dy = (center_height-CGRectGetHeight(rect))/2.0;
    rect.origin.y -= dy;
    rect.size.height = center_height;
    self.frame = rect;
}

- (CGSize)center_size{
    return CGSizeMake(self.LLWidth, self.LLHeight);
}

- (void)setCenter_size:(CGSize)center_size{
    CGRect rect = self.frame;
    CGFloat dx = (center_size.width-CGRectGetWidth(rect))/2.0;
    CGFloat dy = (center_size.height-CGRectGetHeight(rect))/2.0;
    rect.origin.x -= dx;
    rect.origin.y -= dy;
    rect.size.width = center_size.width;
    rect.size.height = center_size.height;
    self.frame = rect;
}

//设置宽高比例
- (CGFloat)LLScale{
    if (self.LLHeight != 0) {
        return self.LLWidth/self.LLHeight;
    }
    return -404;
}

- (void)setScale:(CGFloat)scale x:(CGFloat)x y:(CGFloat)y maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight{
    CGFloat width = maxWidth;
    CGFloat height = width/scale;
    if (height > maxHeight) {
        height = maxHeight;
        width = height*scale;
    }
    self.frame = CGRectMake(x, y, width, height);
}

- (void)setLLCornerRadius:(CGFloat)LLCornerRadius{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = LLCornerRadius;
}

- (CGFloat)LLCornerRadius{
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = width;
    self.layer.borderColor = [color CGColor];
}

- (void)setShadowRadius:(CGFloat)radius offset:(CGFloat)offset color:(UIColor *)color alpha:(CGFloat)alpha {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = alpha;
    self.layer.shadowRadius = radius;
    
    //阴影路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGRect rect = self.bounds;
    float width = rect.size.width;
    float height = rect.size.height;
    float x = rect.origin.x;
    float y = rect.origin.y;
    
    CGPoint topLeft,topMiddle,topRight,rightMiddle,bottomRight,bottomMiddle,bottomLeft,leftMiddle;
    topLeft = rect.origin;
    topLeft.x -= offset;
    topLeft.y -= offset;
    topMiddle    = CGPointMake(x+(width/2),y-offset);
    topRight     = CGPointMake(x+width+offset,y-offset);
    rightMiddle  = CGPointMake(x+width+offset,y+(height/2));
    bottomRight  = CGPointMake(x+width+offset,y+height+offset);
    bottomMiddle = CGPointMake(x+(width/2),y+height+offset);
    bottomLeft   = CGPointMake(x-offset,y+height+offset);
    leftMiddle   = CGPointMake(x-offset,y+(height/2));
    
    [path moveToPoint:topLeft];
    //添加四个二元曲线
    [path addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];
    [path addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    [path addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];
    //设置阴影路径
    self.layer.shadowPath = path.CGPath;
}

- (void)setShadowOffset:(CGFloat)offset color:(UIColor *)color opacity:(CGFloat)opacity shadowType:(LLShadowType)shadowType {
    
    self.layer.shadowColor = color.CGColor; //阴影颜色
    self.layer.shadowOpacity = opacity;     //不透明度
    self.layer.shadowRadius = 5;            //模糊半径
    
    //设置偏移距离
    if (shadowType == LLShadowTypeAll) {
        self.layer.shadowOffset = CGSizeMake(0, 0);
    }
    else if (shadowType == LLShadowTypeTopLeft) {
        self.layer.shadowOffset = CGSizeMake(-offset, -offset);
    }
    else if (shadowType == LLShadowTypeTopRight) {
        self.layer.shadowOffset = CGSizeMake(offset, -offset);
    }
    else if (shadowType == LLShadowTypeBottomLeft) {
        self.layer.shadowOffset = CGSizeMake(-offset, offset);
    }
    else {
        self.layer.shadowOffset = CGSizeMake(offset, offset);
    }
}

- (void)ll_3dAlertBackgroundAnimationAuto:(NSTimeInterval)duration {
    LLDispatch_create_main_queue_timer(@"transform", duration, ^{
        static float degree = 0;
        //起始值
        CATransform3D fromValue = CATransform3DIdentity;
        
        fromValue.m34 = -1.f/600;
        fromValue     = CATransform3DRotate(fromValue, degree, 0, 1, 0);
        
        // 结束值
        CATransform3D toValue = CATransform3DIdentity;
        
        toValue.m34 = -1.f/600;
        toValue     = CATransform3DRotate(toValue, degree += 45.f, 0, 1, 0);
        
        // 添加3D动画
        CABasicAnimation *transform3D = [CABasicAnimation animationWithKeyPath:@"transform"];
        
        transform3D.duration  = duration;
        transform3D.fromValue = [NSValue valueWithCATransform3D:fromValue];
        transform3D.toValue   = [NSValue valueWithCATransform3D:toValue];
        self.layer.transform  = toValue;
        
        [self.layer addAnimation:transform3D forKey:@"transform3D"];
    });
}

- (void)ll_3dAlertBackgroundAnimation:(NSTimeInterval)duration {
    
    CGFloat x = self.center.x;
    CGFloat y = self.frame.origin.y;
    self.layer.anchorPoint = CGPointMake(0.5, 0);
    self.layer.position = CGPointMake(x, y);
    
    //起始值
    CATransform3D fromValue = CATransform3DIdentity;
    fromValue.m34 = -1.f / 300;
    fromValue     = CATransform3DRotate(fromValue, 0, 1, 0, 0);
    
    // 结束值
    CATransform3D toValue = CATransform3DIdentity;
    toValue.m34 = -1.f / 300;
    toValue     = CATransform3DRotate(toValue, 25.f, 1, 0, 0);
    
    // 添加3D动画
    CABasicAnimation *transform3D = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    transform3D.duration  = duration;
    transform3D.fromValue = [NSValue valueWithCATransform3D:fromValue];
    transform3D.toValue   = [NSValue valueWithCATransform3D:toValue];
    self.layer.transform  = toValue;
    
    [self.layer addAnimation:transform3D forKey:@"transform3D"];
}

- (void)startRotationAxis:(NSString *)axis duration:(NSTimeInterval)duration repeatCount:(NSInteger)repeatCount{
    NSString *transformName = [NSString stringWithFormat:@"transform.rotation.%@",axis];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:transformName];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI*2.0 ];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = duration;
    rotationAnimation.repeatCount = repeatCount;
    rotationAnimation.autoreverses = NO;
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:rotationAnimation forKey:@"Rotation"];
}

- (void)transform3DMakeRotationX:(CGFloat)angleX Y:(CGFloat)angleY Z:(CGFloat)angleZ {
    
    CATransform3D transform3D = CATransform3DIdentity;
    if (angleX != 0) {
        transform3D = CATransform3DConcat(transform3D, CATransform3DMakeRotation(angleX*M_PI/180.0, 1, 0, 0));
    }
    if (angleY != 0) {
        transform3D = CATransform3DConcat(transform3D, CATransform3DMakeRotation(angleY*M_PI/180.0, 0, 1, 0));
    }
    if (angleZ != 0) {
        transform3D = CATransform3DConcat(transform3D, CATransform3DMakeRotation(angleZ*M_PI/180.0, 0, 0, 1));
    }
    self.layer.transform = transform3D;
}

- (void)transform3DMakeScaleX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z {
    
    self.layer.transform = CATransform3DMakeScale(x, y, z);
}

- (void)outFromCenterNoneWithDuration:(NSTimeInterval)duration{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [self.layer addAnimation:animation forKey:@"LLAlertNone_appear"];
}

- (void)dismissToCenterNoneWithDuration:(NSTimeInterval)duration {
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [self.layer addAnimation:animation forKey:@"LLAlertNone_dismiss"];
}

- (void)outFromCenterAnimationWithDuration:(NSTimeInterval)duration{
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [self.layer addAnimation:animation forKey:@"LLAlertAnimation_appear"];
}

- (void)dismissToCenterAnimationWithDuration:(NSTimeInterval)duration {
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [self.layer addAnimation:animation forKey:@"LLAlertAnimation_dismiss"];
}

- (void)outAnimation{
    [UIView animateWithDuration:1.0 animations:^{
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.values = @[@(0.1),@(1.0),@(1.5)];
        animation.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        animation.calculationMode = kCAAnimationLinear;
        [self.layer addAnimation:animation forKey:@"SHOW"];
    } completion:^(BOOL finished){
    }];
}

- (void)insideAnimation{
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         self.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.5, 0.5);
     } completion:^(BOOL finished){//do other thing
         [UIView animateWithDuration:0.2 animations:
          ^(void){
              self.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.2, 1.2);
          } completion:^(BOOL finished){//do other thing
              [UIView animateWithDuration:0.1 animations:
               ^(void){
                   self.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
               } completion:^(BOOL finished){//do other thing
               }];
          }];
     }];
}

- (void)transitionFromLeftWithType:(AnimationType)type duration:(NSTimeInterval)duration completion:(doBlock)completion{
    [UIView animateWithDuration:duration animations:^{
        CATransition *animation = [CATransition animation];
        animation.type = [self getType:type];
        animation.subtype = kCATransitionFromLeft;
        animation.duration = duration;
        animation.startProgress = 0.0;
        animation.endProgress = 1.0;
        [self.layer addAnimation:animation forKey:nil];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)transitionFromRightWithType:(AnimationType)type duration:(NSTimeInterval)duration completion:(doBlock)completion{
    [UIView animateWithDuration:duration animations:^{
        CATransition *animation = [CATransition animation];
        animation.type = [self getType:type];
        animation.subtype = kCATransitionFromRight;
        animation.duration = duration;
        animation.startProgress = 0.0;
        animation.endProgress = 1.0;
        [self.layer addAnimation:animation forKey:nil];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)transitionFromTopWithType:(AnimationType)type duration:(NSTimeInterval)duration completion:(doBlock)completion{
    [UIView animateWithDuration:duration animations:^{
        CATransition *animation = [CATransition animation];
        animation.type = [self getType:type];
        animation.subtype = kCATransitionFromTop;
        animation.duration = duration;
        animation.startProgress = 0.0;
        animation.endProgress = 1.0;
        [self.layer addAnimation:animation forKey:nil];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)transitionFromBottomWithType:(AnimationType)type duration:(NSTimeInterval)duration completion:(doBlock)completion{
    [UIView animateWithDuration:duration animations:^{
        CATransition *animation = [CATransition animation];
        animation.type = [self getType:type];
        animation.subtype = kCATransitionFromBottom;
        animation.duration = duration;
        animation.startProgress = 0.0;
        animation.endProgress = 1.0;
        [self.layer addAnimation:animation forKey:nil];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

//旋转180°缩小到最小,然后再从小到大推出
- (void)transform0:(doBlock)transform completion:(doBlock)completion{
    [UIView animateWithDuration:0.35f animations:^  {
        self.transform = CGAffineTransformMakeScale(0.001, 0.001);
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.1, 0.2, 0.2)];
        animation.duration = 0.35f;
        animation.repeatCount = 1;
        [self.layer addAnimation:animation forKey:nil];
    }completion:^(BOOL finished){
        [UIView animateWithDuration:0.35f animations:^  {
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            if (transform) {
                transform();
            }
        }completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    }];
}

//向右旋转45°缩小到最小,然后再从小到大推出
- (void)transform1:(doBlock)transform completion:(doBlock)completion{
    [UIView animateWithDuration:0.35f animations:^  {
         self.transform = CGAffineTransformMakeScale(0.001, 0.001);
         CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
         animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.70, 0.40, 0.80)];
         animation.duration = 0.35f;
         animation.repeatCount = 1;  
         [self.layer addAnimation:animation forKey:nil];
     }completion:^(BOOL finished){
         [UIView animateWithDuration:0.35f animations:^  {
              self.transform = CGAffineTransformMakeScale(1.0, 1.0);
             if (transform) {
                 transform();
             }
          }completion:^(BOOL finished) {
              if (completion) {
                  completion();
              }
          }];
     }];
}

- (void)ll_addCorners:(UIRectCorner)corner radius:(CGFloat)radius{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corner
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (UIColor *)ll_colorWithPoint:(CGPoint)point {
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(context, -point.x, -point.y);
    [self.layer renderInContext:context];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
}

- (void)ll_gradientColors:(NSArray *)colors gradientType:(LLGradientType)type {
    
    NSMutableArray *CGColors = [NSMutableArray arrayWithCapacity:colors.count];
    
    for (UIColor *color in colors) {
        [CGColors addObject:(id)color.CGColor];
    }
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = CGColors;
//    gradient.locations = @[@0.0, @1.0];
    if (type == LLGradientTypeLeftToRight) {
        gradient.startPoint = CGPointMake(0.0, 0.0);
        gradient.endPoint = CGPointMake(1.0, 0.0);
    }
    else if (type == LLGradientTypeTopToBottom) {
        gradient.startPoint = CGPointMake(0.0, 0.0);
        gradient.endPoint = CGPointMake(0.0, 1.0);
    }
    else if (type == LLGradientTypeUpleftToLowright) {
        gradient.startPoint = CGPointMake(0.0, 0.0);
        gradient.endPoint = CGPointMake(1.0, 1.0);
    }
    else {
        gradient.startPoint = CGPointMake(1.0, 0.0);
        gradient.endPoint = CGPointMake(0.0, 1.0);
    }
    [self.layer insertSublayer:gradient atIndex:0];
}

- (void)ll_gradientColorWithGradientType:(LLGradientType)type {
    NSMutableArray *colorArray = [NSMutableArray new];
    for (NSInteger hue = 0; hue < 255; hue += 5) {
        UIColor *color = [UIColor colorWithHue:hue/255.0
                                    saturation:1.0
                                    brightness:1.0
                                         alpha:1.0];
        [colorArray addObject:color];
    }
    [self ll_gradientColors:colorArray gradientType:type];
}

- (BOOL)ll_savePDFToDocumentsWithFileName:(NSString *)aFilename {
    NSMutableData *pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData(pdfData, self.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:pdfContext];
    UIGraphicsEndPDFContext();
    
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *documentDirectoryFilename = [document stringByAppendingPathComponent:aFilename];
    return [pdfData writeToFile:documentDirectoryFilename atomically:YES];
}

/**
 绘制虚线
 **/
- (void)ll_drawlineInFrame:(CGRect)frame
                    length:(CGFloat)lineLength
               lineSpacing:(CGFloat)lineSpacing
                 lineColor:(UIColor *)lineColor
              isHorizontal:(BOOL)isHorizontal
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFrame:frame];
    if (isHorizontal) {
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(frame)/2, CGRectGetHeight(frame))];
    }
    else {
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(frame), CGRectGetHeight(frame)/2)];
    }
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //设置虚线宽度
    if (isHorizontal) {
        [shapeLayer setLineWidth:CGRectGetHeight(frame)];
    }
    else {
        [shapeLayer setLineWidth:CGRectGetWidth(frame)];
    }
    [shapeLayer setLineJoin:kCALineJoinRound];
    //设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithFloat:lineLength], [NSNumber numberWithFloat:lineSpacing], nil]];
    //设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    
    if (isHorizontal) {
        CGPathMoveToPoint(path, NULL, CGRectGetMinX(frame), CGRectGetMinY(frame));
        CGPathAddLineToPoint(path, NULL,CGRectGetMaxX(frame), CGRectGetMinY(frame));
    }
    else {
        CGPathMoveToPoint(path, NULL, CGRectGetMinX(frame), CGRectGetMinY(frame));
        CGPathAddLineToPoint(path, NULL,CGRectGetMinX(frame), CGRectGetMaxY(frame));
    }
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [self.layer addSublayer:shapeLayer];
}

/**
 绘制网格
 **/
- (void)ll_drawGridInFrame:(CGRect)frame
                    length:(CGFloat)lineLength
               lineSpacing:(CGFloat)lineSpacing
                 lineColor:(UIColor *)lineColor
{
    [self ll_drawlineInFrame:frame length:lineLength lineSpacing:lineSpacing lineColor:lineColor isHorizontal:YES];
    [self ll_drawlineInFrame:frame length:lineLength lineSpacing:lineSpacing lineColor:lineColor isHorizontal:NO];
}

#pragma mark - private
- (NSString *)getType:(AnimationType)type{
    switch (type) {
        case 1:  return @"fade";
        case 2:  return @"push";
        case 3:  return @"reveal";
        case 4:  return @"moveIn";
        case 5:  return @"cube";
        case 6:  return @"suckEffect";
        case 7:  return @"oglFlip";
        case 8:  return @"rippleEffect";
        case 9:  return @"pageCurl";
        case 10: return @"pageUnCurl";
        case 11: return @"cameraIrisHollowOpen";
        case 12: return @"cameraIrisHollowClose";
        case 13: return @"curlDown";
        case 14: return @"curlUp";
        case 15: return @"flipFromLeft";
        case 16: return @"flipFromRight";
        default: break;
    }
}

@end
