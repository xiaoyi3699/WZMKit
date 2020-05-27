//
//  WZMAlbumPhotoModel.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMEnum.h"
#import <CoreLocation/CoreLocation.h>
@class WZMAlbumConfig;

@interface WZMAlbumPhotoModel : NSObject

@property (nonatomic, strong) id asset;
@property (nonatomic, strong) id photo;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, assign) WZMAlbumPhotoType type;
@property (nonatomic, strong) NSString *localIdentifier;
@property (nonatomic, assign, getter=isICloud) BOOL iCloud;
@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, assign, getter=isAnimated) BOOL animated;
@property (nonatomic, assign, getter=isDownloading) BOOL downloading;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSDate *modificationDate;
@property (nonatomic, strong) NSString *orgFilename;
@property (nonatomic, assign) NSInteger cacheSize;
@property (nonatomic, assign) CGSize imageSize;

+ (instancetype)modelWithAsset:(id)asset;

///获取原图
- (void)getOriginalCompletion:(void(^)(id original))completion;
///获取缩略图
- (void)getThumbnailCompletion:(void(^)(UIImage *thumbnail))completion cloud:(void(^)(BOOL iCloud))cloud;
///预设尺寸视频
- (void)exportVideoWithPreset:(NSString *)preset outFolder:(NSString *)outFolder completion:(void(^)(NSURL *videoURL))completion;
///预设尺寸图片
- (void)exportImageWithImageSize:(CGSize)imageSize completion:(void(^)(UIImage *image))completion;
///根据相册配置,获取图片
- (void)getImageWithConfig:(WZMAlbumConfig *)config completion:(void(^)(id obj))completion;
///排序
- (NSComparisonResult)compareOtherModel:(WZMAlbumPhotoModel *)otherModel;

@end
