//
//  WZMAlbumPhotoModel.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef enum : NSUInteger {
    WZMAlbumPhotoTypePhoto = 0,
    WZMAlbumPhotoTypeLivePhoto,
    WZMAlbumPhotoTypePhotoGif,
    WZMAlbumPhotoTypeVideo,
    WZMAlbumPhotoTypeAudio
} WZMAlbumPhotoType;

@interface WZMAlbumPhotoModel : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) WZMAlbumPhotoType type;

+ (instancetype)modelWithAsset:(PHAsset *)asset;

@end
