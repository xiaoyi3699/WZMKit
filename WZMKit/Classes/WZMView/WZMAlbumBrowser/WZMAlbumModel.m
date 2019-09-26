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
    model.userCache = NO;
    model.downloading = NO;
    model.type = [WZMAlbumHelper wzm_getAssetType:asset];
    if (model.type == WZMAlbumPhotoTypeVideo) {
        model.duration = [(PHAsset *)asset duration];
        model.timeStr = [model getTimeWithSecond:model.duration];
    }
    else {
        model.duration = 0;
        model.timeStr = @"00";
    }
    return model;
}

///获取缩略图
- (void)getThumbnailCompletion:(void(^)(UIImage *thumbnail))completion {
    if (self.thumbnail) {
        if (completion) {
            completion(self.thumbnail);
        }
    }
    else {
        [WZMAlbumHelper wzm_getThumbnailWithAsset:self.asset photoWidth:200 thumbnail:^(UIImage *photo) {
            if (self.isUserCache) {
                self.thumbnail = photo;
            }
            if (completion) {
                completion(photo);
            }
        } cloud:nil];
    }
}

///获取原图
- (void)getOriginalCompletion:(void(^)(id original))completion {
    [WZMAlbumHelper wzm_getOriginalWithAsset:self.asset completion:^(id obj) {
        if (self.isUserCache) {
            self.original = obj;
        }
        if (completion) {
            completion(obj);
        }
    }];
}

///从iCloud获取原图
- (void)getICloudImageCompletion:(void (^)(id original))completion {
    if (self.downloading) return;
    self.downloading = YES;
    [WZMAlbumHelper wzm_getICloudWithAsset:self.asset progressHandler:nil completion:^(id obj) {
        self.iCloud = NO;
        self.downloading = NO;
        if (self.isUserCache) {
            self.original = obj;
        }
        if (completion) {
            completion(obj);
        }
    }];
}

///预设尺寸视频
- (void)exportVideoWithPreset:(NSString *)preset outFolder:(NSString *)outFolder completion:(void(^)(NSURL *videoURL))completion {
    [WZMAlbumHelper wzm_exportVideoWithAsset:self.asset preset:preset outFolder:outFolder completion:^(NSURL *videoURL) {
        if (completion) {
            completion(videoURL);
        }
    }];
}

///预设尺寸图片
- (void)exportImageWithImageSize:(CGSize)imageSize completion:(void(^)(UIImage *image))completion {
    [WZMAlbumHelper wzm_exportImageWithAsset:self.asset imageSize:imageSize completion:^(UIImage *image) {
        if (completion) {
            completion(image);
        }
    }];
}

///时间
- (NSString *)getTimeWithSecond:(NSInteger)second {
    NSString *time;
    if (second < 60) {
        time = [NSString stringWithFormat:@"00:%02ld",(long)second];
    }
    else {
        if (second < 3600) {
            time = [NSString stringWithFormat:@"%02ld:%02ld",(long)(second/60),(long)(second%60)];
        }
        else {
            time = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)(second/3600),(long)((second-second/3600*3600)/60),(long)(second%60)];
        }
    }
    return time;
}

@end
