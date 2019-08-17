//
//  UIView+wzmcate.m
//  test
//
//  Created by wangzhaomeng on 16/8/5.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "UIView+wzmcate.h"
#import "WZMDispatch.h"
#import <objc/runtime.h>

@implementation UIView (wzmcate)

static NSString *_visualKey = @"visual";

- (UIViewController *)wzm_viewController{
    UIResponder *next = [self nextResponder];
    do{
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next);
    return nil;
}

- (BOOL)wzm_isDescendantOfView:(UIView *)otherView {
    return [self isDescendantOfView:otherView];
}

//设置位置(宽和高保持不变)
- (CGFloat)wzm_minX {
    return CGRectGetMinX(self.frame);
}

- (void)setWzm_minX:(CGFloat)wzm_minX {
    CGRect rect = self.frame;
    rect.origin.x = wzm_minX;
    self.frame = rect;
}

- (CGFloat)wzm_maxX {
    return CGRectGetMaxX(self.frame);
}

- (void)setWzm_maxX:(CGFloat)wzm_maxX {
    CGRect rect = self.frame;
    rect.origin.x = wzm_maxX-CGRectGetWidth(rect);
    self.frame = rect;
}

- (CGFloat)wzm_minY {
    return CGRectGetMinY(self.frame);
}

- (void)setWzm_minY:(CGFloat)wzm_minY {
    CGRect rect = self.frame;
    rect.origin.y = wzm_minY;
    self.frame = rect;
}

- (CGFloat)wzm_maxY {
    return CGRectGetMaxY(self.frame);
}

- (void)setWzm_maxY:(CGFloat)wzm_maxY {
    CGRect rect = self.frame;
    rect.origin.y = wzm_maxY-CGRectGetHeight(rect);
    self.frame = rect;
}

- (CGFloat)wzm_centerX {
    return CGRectGetMidX(self.frame);
}

- (void)setWzm_centerX:(CGFloat)wzm_centerX {
    self.center = CGPointMake(wzm_centerX, CGRectGetMidY(self.frame));
}

- (CGFloat)wzm_centerY {
    return CGRectGetMidY(self.frame);
}

- (void)setWzm_centerY:(CGFloat)wzm_centerY {
    self.center = CGPointMake(CGRectGetMidX(self.frame), wzm_centerY);
}

- (CGPoint)wzm_postion {
    return CGPointMake(self.wzm_minX, self.wzm_minY);
}

- (void)setWzm_postion:(CGPoint)wzm_postion {
    CGRect rect = self.frame;
    rect.origin.x = wzm_postion.x;
    rect.origin.y = wzm_postion.y;
    self.frame = rect;
}

//设置位置(其他顶点保持不变)
- (CGFloat)wzm_mutableMinX {
    return self.wzm_minX;
}

- (void)setWzm_mutableMinX:(CGFloat)wzm_mutableMinX {
    CGRect rect = self.frame;
    rect.origin.x = wzm_mutableMinX;
    rect.size.width = self.wzm_maxX-wzm_mutableMinX;
    self.frame = rect;
}

- (CGFloat)wzm_mutableMaxX {
    return self.wzm_maxX;
}

- (void)setWzm_mutableMaxX:(CGFloat)wzm_mutableMaxX {
    CGRect rect = self.frame;
    rect.size.width = wzm_mutableMaxX-self.wzm_minX;
    self.frame = rect;
}

- (CGFloat)wzm_mutableMinY {
    return self.wzm_minY;
}

- (void)setWzm_mutableMinY:(CGFloat)wzm_mutableMinY {
    CGRect rect = self.frame;
    rect.origin.y = wzm_mutableMinY;
    rect.size.height = self.wzm_maxY-wzm_mutableMinY;
    self.frame = rect;
}

- (CGFloat)wzm_mutableMaxY {
    return self.wzm_maxY;
}

- (void)setWzm_mutableMaxY:(CGFloat)wzm_mutableMaxY {
    CGRect rect = self.frame;
    rect.size.height = wzm_mutableMaxY-self.wzm_minY;
    self.frame = rect;
}

//设置宽和高(位置不变)
- (CGFloat)wzm_width {
    return CGRectGetWidth(self.frame);
}

- (void)setWzm_width:(CGFloat)wzm_width {
    CGRect rect = self.frame;
    rect.size.width = wzm_width;
    self.frame = rect;
}

- (CGFloat)wzm_height {
    return CGRectGetHeight(self.frame);
}

- (void)setWzm_height:(CGFloat)wzm_height {
    CGRect rect = self.frame;
    rect.size.height = wzm_height;
    self.frame = rect;
}

- (CGSize)wzm_size {
    return CGSizeMake(self.wzm_width, self.wzm_height);
}

- (void)setWzm_size:(CGSize)wzm_size {
    CGRect rect = self.frame;
    rect.size.width = wzm_size.width;
    rect.size.height = wzm_size.height;
    self.frame = rect;
}

//设置宽和高(中心点不变)
- (CGFloat)wzm_center_width {
    return CGRectGetWidth(self.frame);
}

- (void)setWzm_center_width:(CGFloat)wzm_center_width {
    CGRect rect = self.frame;
    CGFloat dx = (wzm_center_width-CGRectGetWidth(rect))/2.0;
    rect.origin.x -= dx;
    rect.size.width = wzm_center_width;
    self.frame = rect;
}

- (CGFloat)wzm_center_height {
    return CGRectGetHeight(self.frame);
}

- (void)setWzm_center_height:(CGFloat)wzm_center_height {
    CGRect rect = self.frame;
    CGFloat dy = (wzm_center_height-CGRectGetHeight(rect))/2.0;
    rect.origin.y -= dy;
    rect.size.height = wzm_center_height;
    self.frame = rect;
}

- (CGSize)wzm_center_size {
    return CGSizeMake(self.wzm_width, self.wzm_height);
}

- (void)setWzm_center_size:(CGSize)wzm_center_size {
    CGRect rect = self.frame;
    CGFloat dx = (wzm_center_size.width-CGRectGetWidth(rect))/2.0;
    CGFloat dy = (wzm_center_size.height-CGRectGetHeight(rect))/2.0;
    rect.origin.x -= dx;
    rect.origin.y -= dy;
    rect.size.width = wzm_center_size.width;
    rect.size.height = wzm_center_size.height;
    self.frame = rect;
}

- (CGFloat)wzm_cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setWzm_cornerRadius:(CGFloat)wzm_cornerRadius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = wzm_cornerRadius;
}

- (CGFloat)wzm_borderWidth {
    return self.layer.borderWidth;
}

- (void)setWzm_borderWidth:(CGFloat)wzm_borderWidth {
    self.layer.borderWidth = wzm_borderWidth;
}

- (UIColor *)wzm_borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setWzm_borderColor:(UIColor *)wzm_borderColor {
    self.layer.borderColor = [wzm_borderColor CGColor];
}

- (void)wzm_addCorners:(UIRectCorner)corner radius:(CGFloat)radius{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corner
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)wzm_setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = width;
    self.layer.borderColor = [color CGColor];
}

- (void)wzm_setShadowRadius:(CGFloat)radius offset:(CGFloat)offset color:(UIColor *)color alpha:(CGFloat)alpha {
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

- (void)wzm_setShadowOffset:(CGFloat)offset color:(UIColor *)color opacity:(CGFloat)opacity shadowType: (WZMShadowType)shadowType {
    
    self.layer.shadowColor = color.CGColor; //阴影颜色
    self.layer.shadowOpacity = opacity;     //不透明度
    self.layer.shadowRadius = 5;            //模糊半径
    
    //设置偏移距离
    if (shadowType == WZMShadowTypeAll) {
        self.layer.shadowOffset = CGSizeMake(0, 0);
    }
    else if (shadowType == WZMShadowTypeTopLeft) {
        self.layer.shadowOffset = CGSizeMake(-offset, -offset);
    }
    else if (shadowType == WZMShadowTypeTopRight) {
        self.layer.shadowOffset = CGSizeMake(offset, -offset);
    }
    else if (shadowType == WZMShadowTypeBottomLeft) {
        self.layer.shadowOffset = CGSizeMake(-offset, offset);
    }
    else {
        self.layer.shadowOffset = CGSizeMake(offset, offset);
    }
}

//遮罩效果
- (UIView *)visual {
    return objc_getAssociatedObject(self, &_visualKey);
}

- (void)setVisual:(UIView *)visual {
    objc_setAssociatedObject(self, &_visualKey, visual, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)wzm_hollowFrame:(CGRect)hollowFrame shadowColor:(UIColor *)shadowColor blur:(BOOL)blur {
    if (blur) {
        if (self.visual == nil) {
            UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
            visualView.frame = self.bounds;
            [self addSubview:visualView];
            self.visual = visualView;
        }
    }
    else {
        if (self.visual == nil) {
            UIView *visualView = [[UIView alloc] init];
            visualView.frame = self.bounds;
            visualView.backgroundColor = shadowColor;
            [self addSubview:visualView];
            self.visual = visualView;
        }
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath *cropPath = [UIBezierPath bezierPathWithRect:hollowFrame];
    [path appendPath:cropPath];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillRule = kCAFillRuleEvenOdd;
    self.visual.layer.mask = shapeLayer;
}

- (UIColor *)wzm_colorWithPoint:(CGPoint)point {
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGContextTranslateCTM(context, -point.x, -point.y);
    [self.layer renderInContext:context];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
}

- (void)wzm_gradientColorWithGradientType: (WZMGradientType)type {
    NSMutableArray *colorArray = [NSMutableArray new];
    for (NSInteger hue = 0; hue < 255; hue += 5) {
        UIColor *color = [UIColor colorWithHue:hue/255.0
                                    saturation:1.0
                                    brightness:1.0
                                         alpha:1.0];
        [colorArray addObject:color];
    }
    [self wzm_gradientColors:colorArray gradientType:type];
}

- (void)wzm_gradientColors:(NSArray *)colors gradientType: (WZMGradientType)type {
    
    NSMutableArray *CGColors = [NSMutableArray arrayWithCapacity:colors.count];
    
    for (UIColor *color in colors) {
        [CGColors addObject:(id)color.CGColor];
    }
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = CGColors;
    //    gradient.locations = @[@0.0, @1.0];
    if (type == WZMGradientTypeLeftToRight) {
        gradient.startPoint = CGPointMake(0.0, 0.0);
        gradient.endPoint = CGPointMake(1.0, 0.0);
    }
    else if (type == WZMGradientTypeTopToBottom) {
        gradient.startPoint = CGPointMake(0.0, 0.0);
        gradient.endPoint = CGPointMake(0.0, 1.0);
    }
    else if (type == WZMGradientTypeUpleftToLowright) {
        gradient.startPoint = CGPointMake(0.0, 0.0);
        gradient.endPoint = CGPointMake(1.0, 1.0);
    }
    else {
        gradient.startPoint = CGPointMake(1.0, 0.0);
        gradient.endPoint = CGPointMake(0.0, 1.0);
    }
    [self.layer insertSublayer:gradient atIndex:0];
}

- (BOOL)wzm_savePDFToDocumentsWithFileName:(NSString *)aFilename {
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

- (void)wzm_outFromCenterNoneWithDuration:(NSTimeInterval)duration{
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
    
    [self.layer addAnimation:animation forKey:@"wzm_no_appear"];
}

- (void)wzm_outFromCenterAnimationWithDuration:(NSTimeInterval)duration{
    
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
    
    [self.layer addAnimation:animation forKey:@"wzm_appear"];
}

- (void)wzm_dismissToCenterNoneWithDuration:(NSTimeInterval)duration {
    
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
    
    [self.layer addAnimation:animation forKey:@"wzm_no_dismiss"];
}

- (void)wzm_dismissToCenterAnimationWithDuration:(NSTimeInterval)duration {
    
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
    
    [self.layer addAnimation:animation forKey:@"wzm_dismiss"];
}

- (void)wzm_3dBackgroundAnimation:(BOOL)show duration:(CGFloat)duration {
    if (show) {
        CGFloat x = self.center.x;
        CGFloat y = self.frame.origin.y;
        self.layer.anchorPoint = CGPointMake(0.5, 0);
        self.layer.position = CGPointMake(x, y);
        
        //起始值
        CATransform3D fromValue = CATransform3DIdentity;
        fromValue.m34 = -1.f / 300;
        fromValue = CATransform3DRotate(fromValue, 0, 1, 0, 0);
        
        // 结束值
        CATransform3D toValue = CATransform3DIdentity;
        toValue.m34 = -1.f / 300;
        toValue = CATransform3DRotate(toValue, 25.f, 1, 0, 0);
        
        // 添加3D动画
        CABasicAnimation *transform3D = [CABasicAnimation animationWithKeyPath:@"transform"];
        transform3D.duration  = duration;
        transform3D.fromValue = [NSValue valueWithCATransform3D:fromValue];
        transform3D.toValue   = [NSValue valueWithCATransform3D:toValue];
        self.layer.transform  = toValue;
        [self.layer addAnimation:transform3D forKey:@"transform3D"];
    }
    else {
        CABasicAnimation *transform3D = [CABasicAnimation animationWithKeyPath:@"transform"];
        transform3D.duration  = duration;
        CATransform3D toValue = CATransform3DIdentity;
        toValue = CATransform3DRotate(toValue, 0, 1, 0, 0);
        self.layer.transform  = toValue;
        [self.layer addAnimation:transform3D forKey:@"transform3D"];
    }
}

- (void)wzm_startRotationAxis:(NSString *)axis duration:(NSTimeInterval)duration repeatCount:(NSInteger)repeatCount{
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

- (void)wzm_transform3DMakeRotationX:(CGFloat)angleX Y:(CGFloat)angleY Z:(CGFloat)angleZ {
    
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

- (void)wzm_transform3DMakeScaleX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z {
    self.layer.transform = CATransform3DMakeScale(x, y, z);
}

- (void)wzm_transitionFromLeftWithType:(AnimationType)type duration:(NSTimeInterval)duration completion:(doBlock)completion{
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

- (void)wzm_transitionFromRightWithType:(AnimationType)type duration:(NSTimeInterval)duration completion:(doBlock)completion{
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

- (void)wzm_transitionFromTopWithType:(AnimationType)type duration:(NSTimeInterval)duration completion:(doBlock)completion{
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

- (void)wzm_transitionFromBottomWithType:(AnimationType)type duration:(NSTimeInterval)duration completion:(doBlock)completion{
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

/**
 绘制虚线
 **/
- (void)wzm_drawlineInFrame:(CGRect)frame
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
- (void)wzm_drawGridInFrame:(CGRect)frame
                    length:(CGFloat)lineLength
               lineSpacing:(CGFloat)lineSpacing
                 lineColor:(UIColor *)lineColor
{
    [self wzm_drawlineInFrame:frame length:lineLength lineSpacing:lineSpacing lineColor:lineColor isHorizontal:YES];
    [self wzm_drawlineInFrame:frame length:lineLength lineSpacing:lineSpacing lineColor:lineColor isHorizontal:NO];
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
