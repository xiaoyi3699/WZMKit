//
//  WZMAlbumPhotoModel.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMAlbumPhotoModel.h"
#import "WZMAlbumHelper.h"
#import <Photos/Photos.h>

@implementation WZMAlbumPhotoModel

+ (instancetype)modelWithAsset:(PHAsset *)asset {
    WZMAlbumPhotoModel *model = [[WZMAlbumPhotoModel alloc] init];
    model.asset = asset;
    model.selected = NO;
    model.type = [WZMAlbumHelper getAssetType:asset];
    return model;
}

@end
