//
//  CALayer+wzmcate.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/9/10.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "CALayer+wzmcate.h"

@implementation CALayer (wzmcate)

- (CGFloat)wzm_scale {
    NSNumber *v = [self valueForKeyPath:@"transform.scale"];
    return v.doubleValue;
}

- (void)setWzm_scale:(CGFloat)wzm_scale {
    [self setValue:@(wzm_scale) forKeyPath:@"transform.scale"];
}

- (CGFloat)wzm_scaleX {
    NSNumber *v = [self valueForKeyPath:@"transform.scale.x"];
    return v.doubleValue;
}

- (void)setWzm_scaleX:(CGFloat)wzm_scaleX {
    [self setValue:@(wzm_scaleX) forKeyPath:@"transform.scale.x"];
}

- (CGFloat)wzm_scaleY {
    NSNumber *v = [self valueForKeyPath:@"transform.scale.y"];
    return v.doubleValue;
}

- (void)setWzm_scaleY:(CGFloat)wzm_scaleY {
    [self setValue:@(wzm_scaleY) forKeyPath:@"transform.scale.y"];
}

- (CGFloat)wzm_scaleZ {
    NSNumber *v = [self valueForKeyPath:@"transform.scale.z"];
    return v.doubleValue;
}

- (void)setWzm_scaleZ:(CGFloat)wzm_scaleZ {
    [self setValue:@(wzm_scaleZ) forKeyPath:@"transform.scale.z"];
}

- (CGFloat)wzm_rotation {
    NSNumber *v = [self valueForKeyPath:@"transform.rotation"];
    return v.doubleValue;
}

- (void)setWzm_rotation:(CGFloat)wzm_rotation{
    [self setValue:@(wzm_rotation) forKeyPath:@"transform.rotation"];
}

- (CGFloat)wzm_rotationX {
    NSNumber *v = [self valueForKeyPath:@"transform.rotation.x"];
    return v.doubleValue;
}

- (void)setWzm_rotationX:(CGFloat)wzm_rotationX {
    [self setValue:@(wzm_rotationX) forKeyPath:@"transform.rotation.x"];
}

- (CGFloat)wzm_rotationY {
    NSNumber *v = [self valueForKeyPath:@"transform.rotation.y"];
    return v.doubleValue;
}

- (void)setWzm_rotationY:(CGFloat)wzm_rotationY {
    [self setValue:@(wzm_rotationY) forKeyPath:@"transform.rotation.y"];
}

- (CGFloat)wzm_rotationZ {
    NSNumber *v = [self valueForKeyPath:@"transform.rotation.z"];
    return v.doubleValue;
}

- (void)setWzm_rotationZ:(CGFloat)wzm_rotationZ {
    [self setValue:@(wzm_rotationZ) forKeyPath:@"transform.rotation.z"];
}

- (CGFloat)wzm_translationX {
    NSNumber *v = [self valueForKeyPath:@"transform.translation.x"];
    return v.doubleValue;
}

- (void)setWzm_translationX:(CGFloat)wzm_translationX {
    [self setValue:@(wzm_translationX) forKeyPath:@"transform.translation.x"];
}

- (CGFloat)wzm_translationY {
    NSNumber *v = [self valueForKeyPath:@"transform.translation.y"];
    return v.doubleValue;
}

- (void)setWzm_translationY:(CGFloat)wzm_translationY {
    [self setValue:@(wzm_translationY) forKeyPath:@"transform.translation.y"];
}

- (CGFloat)wzm_translationZ {
    NSNumber *v = [self valueForKeyPath:@"transform.translation.z"];
    return v.doubleValue;
}

- (void)setWzm_translationZ:(CGFloat)wzm_translationZ {
    [self setValue:@(wzm_translationZ) forKeyPath:@"transform.translation.z"];
}

- (CGFloat)wzm_transformDepth {
    return self.transform.m34;
}

- (void)setWzm_transformDepth:(CGFloat)wzm_transformDepth {
    CATransform3D d = self.transform;
    d.m34 = wzm_transformDepth;
    self.transform = d;
}

- (UIViewContentMode)wzm_contentMode {
    return [self wzm_CAGravityToUIViewContentMode:self.contentsGravity];
}

- (void)setWzm_contentMode:(UIViewContentMode)wzm_contentMode {
    self.contentsGravity = [self wzm_UIViewContentModeToCAGravity:wzm_contentMode];
}

- (UIViewContentMode)wzm_CAGravityToUIViewContentMode:(NSString *)gravity {
    static NSDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = @{ kCAGravityCenter:@(UIViewContentModeCenter),
                 kCAGravityTop:@(UIViewContentModeTop),
                 kCAGravityBottom:@(UIViewContentModeBottom),
                 kCAGravityLeft:@(UIViewContentModeLeft),
                 kCAGravityRight:@(UIViewContentModeRight),
                 kCAGravityTopLeft:@(UIViewContentModeTopLeft),
                 kCAGravityTopRight:@(UIViewContentModeTopRight),
                 kCAGravityBottomLeft:@(UIViewContentModeBottomLeft),
                 kCAGravityBottomRight:@(UIViewContentModeBottomRight),
                 kCAGravityResize:@(UIViewContentModeScaleToFill),
                 kCAGravityResizeAspect:@(UIViewContentModeScaleAspectFit),
                 kCAGravityResizeAspectFill:@(UIViewContentModeScaleAspectFill) };
    });
    if (!gravity) return UIViewContentModeScaleToFill;
    return (UIViewContentMode)((NSNumber *)dic[gravity]).integerValue;
}

- (NSString *)wzm_UIViewContentModeToCAGravity:(UIViewContentMode)contentMode {
    switch (contentMode) {
        case UIViewContentModeScaleToFill: return kCAGravityResize;
        case UIViewContentModeScaleAspectFit: return kCAGravityResizeAspect;
        case UIViewContentModeScaleAspectFill: return kCAGravityResizeAspectFill;
        case UIViewContentModeRedraw: return kCAGravityResize;
        case UIViewContentModeCenter: return kCAGravityCenter;
        case UIViewContentModeTop: return kCAGravityTop;
        case UIViewContentModeBottom: return kCAGravityBottom;
        case UIViewContentModeLeft: return kCAGravityLeft;
        case UIViewContentModeRight: return kCAGravityRight;
        case UIViewContentModeTopLeft: return kCAGravityTopLeft;
        case UIViewContentModeTopRight: return kCAGravityTopRight;
        case UIViewContentModeBottomLeft: return kCAGravityBottomLeft;
        case UIViewContentModeBottomRight: return kCAGravityBottomRight;
        default: return kCAGravityResize;
    }
}

- (NSData *)wzm_snapshotPDF {
    CGRect bounds = self.bounds;
    NSMutableData *data = [NSMutableData data];
    CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
    CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
    CGDataConsumerRelease(consumer);
    if (!context) return nil;
    CGPDFContextBeginPage(context, NULL);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    [self renderInContext:context];
    CGPDFContextEndPage(context);
    CGPDFContextClose(context);
    CGContextRelease(context);
    return data;
}

- (void)wzm_removeAllSublayers {
    while (self.sublayers.count) {
        [self.sublayers.lastObject removeFromSuperlayer];
    }
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
    CGRect frame = self.frame;
    frame.origin.x = wzm_centerX - frame.size.width * 0.5;
    self.frame = frame;
}

- (CGFloat)wzm_centerY {
    return CGRectGetMidY(self.frame);
}

- (void)setWzm_centerY:(CGFloat)wzm_centerY {
    CGRect frame = self.frame;
    frame.origin.y = wzm_centerY - frame.size.height * 0.5;
    self.frame = frame;
}

- (CGPoint)wzm_center {
    return CGPointMake(self.wzm_centerX, self.wzm_centerY);
}

- (void)setWzm_center:(CGPoint)wzm_center {
    CGRect frame = self.frame;
    frame.origin.x = wzm_center.x - frame.size.width * 0.5;
    frame.origin.y = wzm_center.y - frame.size.height * 0.5;
    self.frame = frame;
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
    return self.cornerRadius;
}

- (void)setWzm_cornerRadius:(CGFloat)wzm_cornerRadius {
    self.masksToBounds = YES;
    self.cornerRadius = wzm_cornerRadius;
}

- (CGFloat)wzm_borderWidth {
    return self.borderWidth;
}

- (void)setWzm_borderWidth:(CGFloat)wzm_borderWidth {
    self.borderWidth = wzm_borderWidth;
}

- (UIColor *)wzm_borderColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

- (void)setWzm_borderColor:(UIColor *)wzm_borderColor {
    self.borderColor = [wzm_borderColor CGColor];
}

- (void)wzm_addCorners:(UIRectCorner)corner radius:(CGFloat)radius{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corner
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.mask = maskLayer;
}

- (void)wzm_setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color {
    self.masksToBounds = YES;
    self.cornerRadius = radius;
    self.borderWidth = width;
    self.borderColor = [color CGColor];
}

- (void)wzm_setShadowRadius:(CGFloat)radius offset:(CGFloat)offset color:(UIColor *)color alpha:(CGFloat)alpha {
    CALayer *subLayer = [CALayer layer];
    subLayer.frame = self.frame;
    subLayer.cornerRadius = radius;
    subLayer.backgroundColor = color.CGColor;
    subLayer.shadowColor = color.CGColor;
    subLayer.shadowOffset = CGSizeMake(offset,offset);
    subLayer.shadowOpacity = alpha;
    subLayer.shadowRadius = radius;
    [self.superlayer insertSublayer:subLayer below:self];
}

@end
