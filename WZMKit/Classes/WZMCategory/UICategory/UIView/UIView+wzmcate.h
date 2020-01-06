//
//  UIView+wzmcate.h
//  test
//
//  Created by wangzhaomeng on 16/8/5.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMEnum.h"
#import "WZMBlock.h"

@interface UIView (wzmcate)

///获取view所在的ViewController
- (UIViewController *)wzm_viewController;
///判断view是不是指定视图的子视图
- (BOOL)wzm_isDescendantOfView:(UIView *)otherView;

//设置位置(宽和高保持不变)
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

- (CGPoint)wzm_postion;
- (void)setWzm_postion:(CGPoint)wzm_postion;

//设置位置(其他顶点保持不变)
- (CGFloat)wzm_mutableMinX;
- (void)setWzm_mutableMinX:(CGFloat)wzm_mutableMinX;

- (CGFloat)wzm_mutableMaxX;
- (void)setWzm_mutableMaxX:(CGFloat)wzm_mutableMaxX;

- (CGFloat)wzm_mutableMinY;
- (void)setWzm_mutableMinY:(CGFloat)wzm_mutableMinY;

- (CGFloat)wzm_mutableMaxY;
- (void)setWzm_mutableMaxY:(CGFloat)wzm_mutableMaxY;

//设置宽和高(顶点位置不变)
- (CGFloat)wzm_width;
- (void)setWzm_width:(CGFloat)wzm_width;

- (CGFloat)wzm_height;
- (void)setWzm_height:(CGFloat)wzm_height;

- (CGSize)wzm_size;
- (void)setWzm_size:(CGSize)wzm_size;

//设置宽和高(中心点不变)
- (CGFloat)wzm_center_width;
- (void)setWzm_center_width:(CGFloat)wzm_center_width;

- (CGFloat)wzm_center_height;
- (void)setWzm_center_height:(CGFloat)wzm_center_height;

- (CGSize)wzm_center_size;
- (void)setWzm_center_size:(CGSize)wzm_center_size;

//设置圆角
- (CGFloat)wzm_cornerRadius;
- (void)setWzm_cornerRadius:(CGFloat)wzm_cornerRadius;

- (CGFloat)wzm_borderWidth;
- (void)setWzm_borderWidth:(CGFloat)wzm_borderWidth;

- (UIColor *)wzm_borderColor;
- (void)setWzm_borderColor:(UIColor *)wzm_borderColor;

///添加任意圆角
- (void)wzm_addCorners:(UIRectCorner)corner radius:(CGFloat)radius;
///设置圆角、边框
- (void)wzm_setCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color;
///设置阴影
- (void)wzm_setShadowRadius:(CGFloat)radius offset:(CGFloat)offset color:(UIColor *)color alpha:(CGFloat)alpha;
- (void)wzm_setShadowOffset:(CGFloat)offset color:(UIColor *)color opacity:(CGFloat)opacity shadowType: (WZMShadowType)shadowType;
///设置空心遮罩,毛玻璃效果下,shadowColor无效
- (void)wzm_hollowFrame:(CGRect)hollowFrame shadowColor:(UIColor *)shadowColor blur:(BOOL)blur;
///获取某一点的颜色
- (UIColor *)wzm_colorWithPoint:(CGPoint)point;
///渐变
- (void)wzm_gradientColorWithGradientType: (WZMGradientType)type;
- (void)wzm_gradientColors:(NSArray *)colors gradientType: (WZMGradientType)type;
///将一个view保存为pdf格式
- (BOOL)wzm_savePDFToDocumentsWithFileName:(NSString *)aFilename;

///alertView弹出动画
- (void)wzm_outFromCenterNoneWithDuration:(NSTimeInterval)duration;
- (void)wzm_outFromCenterAnimationWithDuration:(NSTimeInterval)duration;
///alertView消失动画
- (void)wzm_dismissToCenterNoneWithDuration:(NSTimeInterval)duration;
- (void)wzm_dismissToCenterAnimationWithDuration:(NSTimeInterval)duration;
///有3d效果的旋转背景动画
- (void)wzm_3dBackgroundAnimation:(BOOL)show duration:(CGFloat)duration;
///旋转动画(参数axis:坐标轴x,y,z 小写)
- (void)wzm_startRotationAxis:(NSString *)axis duration:(NSTimeInterval)duration repeatCount:(NSInteger)repeatCount;
///旋转角度(x、y、z)
- (void)wzm_transform3DMakeRotationX:(CGFloat)angleX Y:(CGFloat)angleY Z:(CGFloat)angleZ;
///放大系数(x、y、z)
- (void)wzm_transform3DMakeScaleX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;
///转场动画
- (void)wzm_transitionFromLeftWithType:(AnimationType)type duration:(NSTimeInterval)duration completion:(doBlock)completion;
- (void)wzm_transitionFromRightWithType:(AnimationType)type duration:(NSTimeInterval)duration completion:(doBlock)completion;
- (void)wzm_transitionFromTopWithType:(AnimationType)type duration:(NSTimeInterval)duration completion:(doBlock)completion;
- (void)wzm_transitionFromBottomWithType:(AnimationType)type duration:(NSTimeInterval)duration completion:(doBlock)completion;

///绘制虚线框
- (void)wzm_addDottedLineWithFrame:(CGRect)frame
                         lineWidth:(CGFloat)lineWidth
                         lineColor:(UIColor *)lineColor;

///绘制虚线
- (void)wzm_drawlineInFrame:(CGRect)frame
                    length:(CGFloat)lineLength
               lineSpacing:(CGFloat)lineSpacing
                 lineColor:(UIColor *)lineColor
              isHorizontal:(BOOL)isHorizontal;
///绘制网格
- (void)wzm_drawGridInFrame:(CGRect)frame
                    length:(CGFloat)lineLength
               lineSpacing:(CGFloat)lineSpacing
                 lineColor:(UIColor *)lineColor;

@end
