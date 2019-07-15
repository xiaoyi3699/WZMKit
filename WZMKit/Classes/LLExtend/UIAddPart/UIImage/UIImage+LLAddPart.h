//
//  UIImage+AddPart.h
//  Money
//
//  Created by fan on 16/7/15.
//  Copyright © 2016年 liupeidong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLEnum.h"
#import "LLBlock.h"

@interface UIImage (LLAddPart)

#pragma mark - 类方法
///根据颜色创建image
+ (UIImage *)ll_getImageByColor:(UIColor *)color;
///根据颜色创建image<圆形>
+ (UIImage *)ll_getRoundImageByColor:(UIColor *)color size:(CGSize)size;
///根据颜色创建image<矩形>
+ (UIImage *)ll_getRectImageByColor:(UIColor *)color size:(CGSize)size;
///截屏
+ (UIImage *)ll_getScreenImageByView:(UIView *)view;
///根据ALAsset/PHAsset获取image
+ (void)ll_getImageWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info))completion;
///base64编码转换为图片
+ (UIImage *)ll_getImageByBase64:(NSString *)str;
///创建一个动态图片，动态图片持续的时间为duration
+ (UIImage *)ll_getGifByImages:(NSArray *)images duration:(NSTimeInterval)duration;
///获取launchImage
+ (UIImage *)ll_getLaunchImageByType:(LLLaunchImageType)type;
///梯度图
+ (UIImage *)ll_getGradientImageByColors:(NSArray *)colors gradientType:(LLGradientType)gradientType imgSize:(CGSize)imgSize;
///绘制空心图片
+ (UIImage *)ll_getImageWithShadowFrame:(CGRect)shadowFrame hollowFrame:(CGRect)hollowFrame shadowColor:(UIColor *)shadowColor;
///保存图片到自定义相册
+ (void)ll_saveToAlbumName:(NSString *)albumName data:(NSData *)data completion:(doBlock)completion;
///合并图片
+ (UIImage *)ll_mergeImage:(UIImage*)firstImage otherImage:(UIImage*)secondImage;

#pragma mark - 二维码
///生成二维码图片
+ (UIImage *)ll_getQRCodeByString:(NSString *)string size:(CGFloat)size;
///二维码图片添加logo
- (UIImage *)ll_addLogo:(UIImage *)logo logoSize:(CGFloat)logoSize;
///改变二维码图片的颜色
- (UIImage *)ll_getQRImageWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

#pragma mark - 实例方法
///保存到相册
- (void)ll_savedToAlbum;
///剪裁图片
- (UIImage *)ll_clipImageWithRect:(CGRect)rect;
///压缩图片所占的物理内存大小 100M以内的图片经过三层压缩，<= 1M
- (UIImage *)ll_getScaleImage;
///按比例压缩image
- (UIImage *)ll_getImageWithScale:(CGFloat)scale;
///圆角图片
- (UIImage *)ll_getRoundImageWithRadius:(CGFloat)radius ;
///图片上绘制文字
- (UIImage *)ll_getImageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize;
///拉伸图片
- (UIImage *)ll_resizableImage;
///聊天气泡拉伸
- (UIImage *)ll_getBubbleImageWithLeft:(NSInteger)left top:(NSInteger)top;
///取图片某一像素的颜色
- (UIColor *)ll_getColorAtPixel:(CGPoint)point;
///判断该图片是否有Alpha通道
- (BOOL)ll_isHasAlphaChannel;
///模糊图片
- (UIImage *)ll_getBlurImageWithScale:(CGFloat)scale;
///灰度图
- (UIImage *)ll_getGrayImage;
///按给定的方向旋转图片
- (UIImage*)ll_getRotateImage:(UIImageOrientation)orient;
///垂直翻转
- (UIImage *)ll_getVerticalImage;
///水平翻转
- (UIImage *)ll_getHorizontalImage;

@end
