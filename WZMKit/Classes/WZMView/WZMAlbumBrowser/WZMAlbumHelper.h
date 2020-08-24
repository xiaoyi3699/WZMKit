//
//  WZMAlbumHelper.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "WZMEnum.h"

@interface WZMAlbumHelper : NSObject

//文件格式
+ (WZMAlbumPhotoType)wzm_getAssetType:(id)asset;
///获取缩略图
+ (int32_t)wzm_getThumbnailWithAsset:(id)asset photoWidth:(CGFloat)photoWidth thumbnail:(void(^)(UIImage *photo))thumbnail cloud:(void(^)(BOOL iCloud))cloud;
///获取原图/原视频
+ (int32_t)wzm_getOriginalWithAsset:(id)asset completion:(void(^)(id obj))completion;
///从iCloud获取图片/视频
+ (void)wzm_getICloudWithAsset:(id)asset progressHandler:(void(^)(double progress))progressHandler completion:(void (^)(id obj))completion;
///导出图片
+ (void)wzm_exportImageWithAsset:(id)asset imageSize:(CGSize)imageSize completion:(void(^)(UIImage *image))completion;
///导出GIF
+ (void)wzm_exportGifWithAsset:(id)asset completion:(void(^)(NSData *data))completion;
///导出视频
+ (void)wzm_exportVideoWithAsset:(id)asset completion:(void(^)(NSURL *videoURL))completion;
+ (void)wzm_exportVideoWithAsset:(id)asset preset:(NSString *)preset outFolder:(NSString *)outFolder completion:(void(^)(NSURL *videoURL))completion;
///保存视频到系统相册
+ (void)wzm_saveVideoWithPath:(NSString *)path completion:(void(^)(NSError *error))completion;
///保存图片到系统相册
+ (void)wzm_saveImage:(UIImage *)image completion:(void(^)(NSError *error))completion;
+ (void)wzm_saveImageWithPath:(NSString *)path completion:(void(^)(NSError *error))completion;
///清除视频缓存
+ (void)wzm_claerVideoCache;
///从iCloud获取图片失败
+ (void)showiCloudError;
#pragma mark - 刷新相册通知
+ (void)postUpdateAlbumNotification;
+ (void)addUpdateAlbumObserver:(id)observer selector:(SEL)selector;
+ (void)removeUpdateAlbumObserver:(id)observer;
#pragma mark - other
///修正图片转向
+ (UIImage *)wzm_fixOrientation:(UIImage *)aImage;
///修正视频转向
+ (AVMutableVideoComposition *)fixedCompositionWithAsset:(AVAsset *)videoAsset;

@end
