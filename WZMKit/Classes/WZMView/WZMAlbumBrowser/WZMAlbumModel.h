//
//  WZMAlbumModel.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZMEnum.h"

@interface WZMAlbumModel : NSObject

@property (nonatomic, strong) id asset;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) id original;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) WZMAlbumPhotoType type;
@property (nonatomic, assign, getter=isICloud) BOOL iCloud;
@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, assign, getter=isDownloading) BOOL downloading;

+ (instancetype)modelWithAsset:(id)asset;
///从iCloud获取原图
- (void)getICloudImageCompletion:(void (^)(id obj))completion;
///获取原图
- (void)getOriginalWithAsset:(id)asset completion:(void(^)(id obj))completion;
///获取缩略图
- (void)getThumbnailWithAsset:(id)asset thumbnail:(void(^)(UIImage *photo))thumbnail;

@end
