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
    model.iCloud = NO;
    model.selected = NO;
    model.downloading = NO;
    model.type = [WZMAlbumHelper getAssetType:asset];
    return model;
}

- (void)getICloudImageCompletion:(void (^)(id obj))completion {
    self.downloading = YES;
    [WZMAlbumHelper getICloudImageWithAsset:self.asset progressHandler:nil completion:^(id obj) {
        self.iCloud = NO;
        self.downloading = NO;
        if (completion) {
            completion(obj);
        }
    }];
}

@end
