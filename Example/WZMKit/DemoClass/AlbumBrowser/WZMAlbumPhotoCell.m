//
//  WZMAlbumPhotoCell.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMAlbumPhotoCell.h"
#import "WZMAlbumHelper.h"

@implementation WZMAlbumPhotoCell {
    int32_t _imageRequestID;
    NSString *_representedAssetIdentifier;
    UIImageView *_photoImageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _photoImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.clipsToBounds = YES;
        [self addSubview:_photoImageView];
    }
    return self;
}

- (void)setConfig:(WZMAlbumPhotoModel *)photoModel {
    _representedAssetIdentifier = photoModel.asset.localIdentifier;
    int32_t imageRequestID = [WZMAlbumHelper getPhotoWithAsset:photoModel.asset photoWidth:self.bounds.size.width completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if ([_representedAssetIdentifier isEqualToString:photoModel.asset.localIdentifier]) {
            _photoImageView.image = photo;
        } else {
            [[PHImageManager defaultManager] cancelImageRequest:_imageRequestID];
        }
        if (!isDegraded) {
            _imageRequestID = 0;
        }
    } progressHandler:nil networkAccessAllowed:NO];
    if (imageRequestID && _imageRequestID && imageRequestID != _imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:_imageRequestID];
    }
    _imageRequestID = imageRequestID;
}

@end
