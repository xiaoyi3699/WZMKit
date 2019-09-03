//
//  WZMAlbumModel.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMAlbumModel.h"
#import "WZMAlbumHelper.h"
#import <Photos/Photos.h>

@implementation WZMAlbumModel

+ (instancetype)modelWithAsset:(PHAsset *)asset {
    WZMAlbumModel *model = [[WZMAlbumModel alloc] init];
    model.asset = asset;
    model.iCloud = YES;
    model.selected = NO;
    model.downloading = NO;
    model.type = [WZMAlbumHelper wzm_getAssetType:asset];
    return model;
}

///获取缩略图
- (void)getThumbnailWithAsset:(id)asset thumbnail:(void(^)(UIImage *photo))thumbnail {
    if (self.thumbnail) {
        if (thumbnail) {
            thumbnail(self.thumbnail);
        }
    }
    else {
        [WZMAlbumHelper wzm_getThumbnailWithAsset:asset photoWidth:200 thumbnail:^(UIImage *photo) {
            self.thumbnail = photo;
            if (thumbnail) {
                thumbnail(photo);
            }
        } cloud:nil];
    }
}

///获取原图
- (void)getOriginalWithAsset:(id)asset completion:(void(^)(id obj))completion {
    [WZMAlbumHelper wzm_getOriginalWithAsset:asset completion:^(id obj) {
        self.original = obj;
        if (completion) {
            completion(obj);
        }
    }];
}

///从iCloud获取原图
- (void)getICloudImageCompletion:(void (^)(id obj))completion {
    if (self.downloading) return;
    self.downloading = YES;
    [WZMAlbumHelper wzm_getICloudWithAsset:self.asset progressHandler:nil completion:^(id obj) {
        self.iCloud = NO;
        self.downloading = NO;
        self.original = obj;
        if (completion) {
            completion(obj);
        }
    }];
}

@end
