//
//  WZMAlbumPhotoModel.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMAlbumPhotoModel.h"

@implementation WZMAlbumPhotoModel

+ (instancetype)modelWithAsset:(PHAsset *)asset {
    WZMAlbumPhotoModel *model = [[WZMAlbumPhotoModel alloc] init];
    model.asset = asset;
    model.isSelected = NO;
    model.type = [self getAssetType:asset];
    return model;
}

+ (WZMAlbumPhotoType)getAssetType:(PHAsset *)asset {
    WZMAlbumPhotoType type = WZMAlbumPhotoTypePhoto;
    PHAsset *phAsset = (PHAsset *)asset;
    if (phAsset.mediaType == PHAssetMediaTypeVideo)      type = WZMAlbumPhotoTypeVideo;
    else if (phAsset.mediaType == PHAssetMediaTypeAudio) type = WZMAlbumPhotoTypeAudio;
    else if (phAsset.mediaType == PHAssetMediaTypeImage) {
        if (@available(iOS 9.1, *)) {
//             if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) type = WZMAlbumPhotoTypeLivePhoto;
        }
        if ([[phAsset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
            type = WZMAlbumPhotoTypePhotoGif;
        }
    }
    return type;
}

@end
