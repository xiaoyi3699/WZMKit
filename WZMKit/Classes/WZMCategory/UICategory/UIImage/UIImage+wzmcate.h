//
//  UIImage+wzmcate.h
//  Money
//
//  Created by fan on 16/7/15.
//  Copyright © 2016年 liupeidong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMEnum.h"
#import "WZMBlock.h"

@interface UIImage (wzmcate)

#pragma mark - 类方法
///根据颜色创建image
+ (UIImage *)wzm_getImageByColor:(UIColor *)color;
///根据颜色创建image<圆形>
+ (UIImage *)wzm_getRoundImageByColor:(UIColor *)color size:(CGSize)size;
///根据颜色创建image<矩形>
+ (UIImage *)wzm_getRectImageByColor:(UIColor *)color size:(CGSize)size;
///截屏
+ (UIImage *)wzm_getScreenImageByView:(UIView *)view;
///base64编码转换为图片
+ (UIImage *)wzm_getImageByBase64:(NSString *)str;
///创建一个动态图片，动态图片持续的时间为duration
+ (UIImage *)wzm_getGifByImages:(NSArray *)images duration:(NSTimeInterval)duration;
///获取launchImage
+ (UIImage *)wzm_getLaunchImageByType: (WZMLaunchImageType)type;
///梯度图
+ (UIImage *)wzm_getGradientImageByColors:(NSArray *)colors gradientType: (WZMGradientType)gradientType imgSize:(CGSize)imgSize;
///绘制空心图片
+ (UIImage *)wzm_getImageWithShadowFrame:(CGRect)shadowFrame hollowFrame:(CGRect)hollowFrame shadowColor:(UIColor *)shadowColor;
///合并图片
+ (UIImage *)wzm_mergeImage:(UIImage*)firstImage otherImage:(UIImage*)secondImage;

#pragma mark - 二维码
///生成二维码图片
+ (UIImage *)wzm_getQRCodeByString:(NSString *)string size:(CGFloat)size;
///二维码图片添加logo
- (UIImage *)wzm_addLogo:(UIImage *)logo logoSize:(CGFloat)logoSize;
///改变二维码图片的颜色
- (UIImage *)wzm_getQRImageWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

#pragma mark - 实例方法
///剪裁图片
- (UIImage *)wzm_clipImageWithRect:(CGRect)rect;
///压缩图片所占的物理内存大小 100M以内的图片经过三层压缩，<= 1M
- (UIImage *)wzm_getScaleImage;
///按比例压缩image
- (UIImage *)wzm_getImageWithScale:(CGFloat)scale;
///圆角图片
- (UIImage *)wzm_getRoundImageWithRadius:(CGFloat)radius ;
///图片上绘制文字
- (UIImage *)wzm_getImageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize;
///拉伸图片
- (UIImage *)wzm_resizableImage;
///聊天气泡拉伸
- (UIImage *)wzm_getBubbleImageWithLeft:(NSInteger)left top:(NSInteger)top;
///取图片某一像素的颜色
- (UIColor *)wzm_getColorAtPixel:(CGPoint)point;
///判断该图片是否有Alpha通道
- (BOOL)wzm_isHasAlphaChannel;
///模糊图片
- (UIImage *)wzm_getBlurImageWithScale:(CGFloat)scale;
///灰度图
- (UIImage *)wzm_getGrayImage;
///按给定的方向旋转图片
- (UIImage*)wzm_getRotateImage:(UIImageOrientation)orient;
///垂直翻转
- (UIImage *)wzm_getVerticalImage;
///水平翻转
- (UIImage *)wzm_getHorizontalImage;

@end
