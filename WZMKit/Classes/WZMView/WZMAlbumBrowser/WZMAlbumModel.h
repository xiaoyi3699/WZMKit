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
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, assign) WZMAlbumPhotoType type;
@property (nonatomic, assign, getter=isICloud) BOOL iCloud;
@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, assign, getter=isUseCache) BOOL useCache;
@property (nonatomic, assign, getter=isAnimated) BOOL animated;
@property (nonatomic, assign, getter=isDownloading) BOOL downloading;

+ (instancetype)modelWithAsset:(id)asset;

///获取原图
- (void)getOriginalCompletion:(void(^)(id original))completion;
///从iCloud获取原图
- (void)getICloudImageCompletion:(void (^)(id original))completion;
///获取缩略图
- (void)getThumbnailCompletion:(void(^)(UIImage *thumbnail))completion;
///预设尺寸视频
- (void)exportVideoWithPreset:(NSString *)preset outFolder:(NSString *)outFolder completion:(void(^)(NSURL *videoURL))completion;
///预设尺寸图片
- (void)exportImageWithImageSize:(CGSize)imageSize completion:(void(^)(UIImage *image))completion;

@end
