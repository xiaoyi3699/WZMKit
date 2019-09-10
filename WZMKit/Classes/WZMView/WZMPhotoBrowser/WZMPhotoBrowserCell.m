//
//  WZMPhotoBrowserCell.m
//  WZMKit
//
//  Created by WangZhaomeng on 2017/12/13.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMPhotoBrowserCell.h"
#import "WZMPhoto.h"

@interface WZMPhotoBrowserCell ()<WZMPhotoDelegate>

@end

@implementation WZMPhotoBrowserCell {
    WZMPhoto *_photo;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = self.bounds;
        rect.size.width -= 10;
        rect.origin.x = 5;
        _photo = [[WZMPhoto alloc] initWithFrame:rect];
        _photo.wzm_delegate = self;
        _photo.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_photo];
    }
    return self;
}

#pragma mark - WZMPhotoDelegate
- (void)clickAtPhoto:(WZMPhoto *)photo contentType:(WZMAlbumPhotoType)contentType gestureType:(WZMGestureRecognizerType)gestureType {
    if ([self.delegate respondsToSelector:@selector(photoBrowserCell:clickAtIndexPath:contentType:gestureType:)]) {
        [self.delegate photoBrowserCell:self clickAtIndexPath:self.indexPath contentType:contentType gestureType:gestureType];
    }
}

- (void)setImage:(id)image {
    _photo.zoomScale = 1.0;
    _photo.wzm_image = image;
}

- (void)willDisplay {
    [_photo start];
}

- (void)didEndDisplay {
    _photo.zoomScale = 1.0;
    [_photo stop];
}

@end
