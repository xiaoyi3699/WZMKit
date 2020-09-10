//
//  CALayer+wzmcate.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/9/10.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (wzmcate)

@property (nonatomic, assign) CGFloat wzm_scale;
@property (nonatomic, assign) CGFloat wzm_scaleX;
@property (nonatomic, assign) CGFloat wzm_scaleY;
@property (nonatomic, assign) CGFloat wzm_scaleZ;

@property (nonatomic, assign) CGFloat wzm_rotation;
@property (nonatomic, assign) CGFloat wzm_rotationX;
@property (nonatomic, assign) CGFloat wzm_rotationY;
@property (nonatomic, assign) CGFloat wzm_rotationZ;

@property (nonatomic, assign) CGFloat wzm_translationX;
@property (nonatomic, assign) CGFloat wzm_translationY;
@property (nonatomic, assign) CGFloat wzm_translationZ;

@property (nonatomic, assign) CGFloat wzm_transformDepth;
@property (nonatomic, assign) UIViewContentMode wzm_contentMode;
- (void)wzm_removeAllSublayers;

///自定义适配
- (CGFloat)wzm_minX;
- (void)setWzm_minX:(CGFloat)wzm_minX;
- (CGFloat)wzm_maxX;
- (void)setWzm_maxX:(CGFloat)wzm_maxX;
- (CGFloat)wzm_minY;
- (void)setWzm_minY:(CGFloat)wzm_minY;
- (CGFloat)wzm_maxY;
- (void)setWzm_maxY:(CGFloat)wzm_maxY;
- (CGFloat)wzm_centerX;
- (void)setWzm_centerX:(CGFloat)wzm_centerX;
- (CGFloat)wzm_centerY;
- (void)setWzm_centerY:(CGFloat)wzm_centerY;
- (CGPoint)wzm_center;
- (void)setWzm_center:(CGPoint)wzm_center;
- (CGPoint)wzm_postion;
- (void)setWzm_postion:(CGPoint)wzm_postion;
- (CGFloat)wzm_mutableMinX;
- (void)setWzm_mutableMinX:(CGFloat)wzm_mutableMinX;
- (CGFloat)wzm_mutableMaxX;
- (void)setWzm_mutableMaxX:(CGFloat)wzm_mutableMaxX;
- (CGFloat)wzm_mutableMinY;
- (void)setWzm_mutableMinY:(CGFloat)wzm_mutableMinY;
- (CGFloat)wzm_mutableMaxY;
- (void)setWzm_mutableMaxY:(CGFloat)wzm_mutableMaxY;
- (CGFloat)wzm_width;
- (void)setWzm_width:(CGFloat)wzm_width;
- (CGFloat)wzm_height;
- (void)setWzm_height:(CGFloat)wzm_height;
- (CGSize)wzm_size;
- (void)setWzm_size:(CGSize)wzm_size;
- (CGFloat)wzm_center_width;
- (void)setWzm_center_width:(CGFloat)wzm_center_width;
- (CGFloat)wzm_center_height;
- (void)setWzm_center_height:(CGFloat)wzm_center_height;
- (CGSize)wzm_center_size;
- (void)setWzm_center_size:(CGSize)wzm_center_size;
- (CGFloat)wzm_cornerRadius;
- (void)setWzm_cornerRadius:(CGFloat)wzm_cornerRadius;
- (CGFloat)wzm_borderWidth;
- (void)setWzm_borderWidth:(CGFloat)wzm_borderWidth;
- (UIColor *)wzm_borderColor;
- (void)setWzm_borderColor:(UIColor *)wzm_borderColor;
- (void)wzm_addCorners:(UIRectCorner)corner radius:(CGFloat)radius;
- (void)wzm_setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color;
- (void)wzm_setShadowRadius:(CGFloat)radius offset:(CGFloat)offset color:(UIColor *)color alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
