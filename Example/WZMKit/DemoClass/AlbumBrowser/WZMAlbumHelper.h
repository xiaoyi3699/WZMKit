//
//  WZMAlbumHelper.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZMEnum.h"

@interface WZMAlbumHelper : NSObject

//文件格式
+ (WZMAlbumPhotoType)getAssetType:(id)asset;
///获取缩略图
+ (int32_t)wzm_getThumbnailWithAsset:(id)asset photoWidth:(CGFloat)photoWidth thumbnail:(void(^)(UIImage *photo))thumbnail cloud:(void(^)(BOOL iCloud))cloud;
///获取原图
+ (void)wzm_getOriginalWithAsset:(id)asset completion:(void(^)(UIImage *photo, BOOL iCloud))completion;
///从iCloud获取图片
+ (void)getICloudImageWithAsset:(id)asset progressHandler:(void(^)(double progress))progressHandler completion:(void (^)(id obj))completion;
//获取视频
+ (void)wzm_getVideoWithAsset:(id)asset completion:(void(^)(NSURL *videoURL))completion;
///导出视频
+ (void)wzm_exportVideoWithAsset:(id)asset completion:(void(^)(NSURL *videoURL))completion;
///保存视频到系统相册
+ (void)wzm_saveVideo:(NSString *)path;
///保存图片到系统相册
+ (void)wzm_saveImage:(UIImage *)image;
///保存图片到自定义相册
+ (void)wzm_saveToAlbumName:(NSString *)albumName data:(NSData *)data completion:(doBlock)completion;
///清除视频缓存
+ (void)wzm_claerVideoCache;

@end
