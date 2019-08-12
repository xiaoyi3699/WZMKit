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
+ (int32_t)wzm_getThumbnailImageWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;
///获取原图
+ (void)wzm_getOriginalImageWithAsset:(id)asset completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;
///获取视频
+ (void)wzm_getVideoWithAsset:(id)asset completion:(void (^)(NSString *videoPath, NSString *desc))completion;
///保存视频到系统相册
+ (void)wzm_saveVideo:(NSString *)path;
///保存图片到系统相册
+ (void)wzm_saveImage:(UIImage *)image;
///保存图片到自定义相册
+ (void)wzm_saveToAlbumName:(NSString *)albumName data:(NSData *)data completion:(doBlock)completion;

@end
