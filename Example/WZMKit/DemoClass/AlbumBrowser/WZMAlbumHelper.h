//
//  WZMAlbumHelper.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZMAlbumPhotoModel.h"

@interface WZMAlbumHelper : NSObject

+ (WZMAlbumPhotoType)getAssetType:(PHAsset *)asset;
+ (PHImageRequestID)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;
@end
