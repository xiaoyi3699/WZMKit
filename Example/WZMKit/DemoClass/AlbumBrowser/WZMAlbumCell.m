//
//  WZMAlbumCell.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMAlbumCell.h"
#import "WZMAlbumHelper.h"
#import <Photos/Photos.h>

@interface WZMAlbumCell ()

@property (nonatomic, strong) WZMAlbumModel *model;

@end

@implementation WZMAlbumCell {
    int32_t _imageRequestID;
    NSString *_representedAssetIdentifier;
    UIImageView *_photoImageView;
    UILabel *_gifLabel;
    UIView *_videoTimeView;
    UILabel *_videoTimeLabel;
    UIImageView *_playImageView;
    UIButton *_selectedBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _photoImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.clipsToBounds = YES;
        [self addSubview:_photoImageView];
        
        _playImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width-20)/2, (self.bounds.size.height-30)/2, 20, 20)];
        _playImageView.image = [UIImage imageNamed:@"album_play"];
        _playImageView.hidden = YES;
        [self addSubview:_playImageView];
        
        _videoTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-15, self.bounds.size.width, 15)];
        _videoTimeView.backgroundColor = [UIColor blackColor];
        _videoTimeView.hidden = YES;
        [self addSubview:_videoTimeView];
        
        _videoTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_videoTimeView.bounds.size.width-42, 0, 40, 15)];
        _videoTimeLabel.font = [UIFont systemFontOfSize:7];
        _videoTimeLabel.textColor = [UIColor whiteColor];
        _videoTimeLabel.textAlignment = NSTextAlignmentRight;
        [_videoTimeView addSubview:_videoTimeLabel];
        
        UIImageView *videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 1, 13, 13)];
        videoImageView.image = [UIImage imageNamed:@"album_video"];
        [_videoTimeView addSubview:videoImageView];
        
        _gifLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-25, self.bounds.size.height-15, 25, 15)];
        _gifLabel.text = @"GIF";
        _gifLabel.font = [UIFont systemFontOfSize:10];
        _gifLabel.textColor = [UIColor whiteColor];
        _gifLabel.backgroundColor = [UIColor blackColor];
        _gifLabel.textAlignment = NSTextAlignmentCenter;
        _gifLabel.hidden = YES;
        [self addSubview:_gifLabel];
        
        _selectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedBtn.frame = CGRectMake(self.bounds.size.width-30, 0, 30, 30);
        [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"album_normal"] forState:UIControlStateNormal];
        [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"album_seleced"] forState:UIControlStateSelected];
        [_selectedBtn addTarget:self action:@selector(didSelected) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_selectedBtn];
    }
    return self;
}

- (void)setConfig:(WZMAlbumModel *)photoModel {
    self.model = photoModel;
    PHAsset *phAsset = (PHAsset *)photoModel.asset;
    _representedAssetIdentifier = phAsset.localIdentifier;
    int32_t imageRequestID = [WZMAlbumHelper wzm_getThumbnailImageWithAsset:photoModel.asset photoWidth:self.bounds.size.width completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if ([_representedAssetIdentifier isEqualToString:phAsset.localIdentifier]) {
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
    _selectedBtn.selected = photoModel.isSelected;
    if (photoModel.type == WZMAlbumPhotoTypePhotoGif) {
        _gifLabel.hidden = NO;
        _videoTimeView.hidden = YES;
        _playImageView.hidden = YES;
        _videoTimeLabel.text = @"";
    }
    else if (photoModel.type == WZMAlbumPhotoTypeVideo) {
        _gifLabel.hidden = YES;
        _videoTimeView.hidden = NO;
        _playImageView.hidden = NO;
        _videoTimeLabel.text = [NSString wzm_getTimeBySecond:phAsset.duration];
    }
    else {
        _gifLabel.hidden = YES;
        _videoTimeView.hidden = YES;
        _playImageView.hidden = YES;
        _videoTimeLabel.text = @"";
    }
}

- (void)didSelected {
    _selectedBtn.selected = !_selectedBtn.isSelected;
    self.model.selected = _selectedBtn.isSelected;
    if ([self.delegate respondsToSelector:@selector(albumPhotoDidSelectedCell:)]) {
        [self.delegate albumPhotoDidSelectedCell:self];
    }
}

@end
