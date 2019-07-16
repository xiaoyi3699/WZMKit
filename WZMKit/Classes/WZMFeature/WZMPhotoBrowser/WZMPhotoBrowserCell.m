//
//  WZMPhotoBrowserCell.m
//  WZMCommonSDK
//
//  Created by WangZhaomeng on 2017/12/13.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMPhotoBrowserCell.h"

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

- (void)clickAtPhoto:(WZMPhoto *)photo content:(id)content isGif:(BOOL)isGif type: (WZMGestureRecognizerType)type{
    if ([self.delegate respondsToSelector:@selector(photoBrowserCell:clickAtIndexPath:content:isGif:type:)]) {
        [self.delegate photoBrowserCell:self clickAtIndexPath:self.indexPath content:content isGif:isGif type:type];
    }
}

- (void)setImage:(id)image {
    _photo.zoomScale = 1.0;
    _photo.wzm_image = image;
}

- (void)willDisplay {
    [_photo startGif];
}

- (void)didEndDisplay {
    _photo.zoomScale = 1.0;
    [_photo stopGif];
}

@end
