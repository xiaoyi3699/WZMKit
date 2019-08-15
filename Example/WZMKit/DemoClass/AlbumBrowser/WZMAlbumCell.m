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
@property (nonatomic, strong) WZMAlbumConfig *config;
@property (nonatomic, assign, getter=isDisplay) BOOL display;

@end

@implementation WZMAlbumCell {
    int32_t _imageRequestID;
    UIImageView *_photoImageView;
    UILabel *_gifLabel;
    UIView *_videoTimeView;
    UILabel *_videoTimeLabel;
    UIImageView *_playImageView;
    UILabel *_indexLabel;
    UIButton *_previewBtn;
    UIButton *_iCloudBtn;
    UIActivityIndicatorView *_activityView;
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
        
        _indexLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _indexLabel.text = @"1";
        _indexLabel.font = [UIFont boldSystemFontOfSize:25];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.backgroundColor = [THEME_COLOR colorWithAlphaComponent:0.6];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.hidden = YES;
        [self addSubview:_indexLabel];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.frame = self.bounds;
        _activityView.hidesWhenStopped = YES;
        _activityView.backgroundColor = [THEME_COLOR colorWithAlphaComponent:0.2];
        [self addSubview:_activityView];
        
        _previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _previewBtn.frame = CGRectMake(self.bounds.size.width-30, 0, 30, 30);
        _previewBtn.tintColor = [THEME_COLOR colorWithAlphaComponent:0.5];
        [_previewBtn setImage:[[UIImage imageNamed:@"album_fd"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_previewBtn addTarget:self action:@selector(previewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _previewBtn.hidden = YES;
        [self addSubview:_previewBtn];
        
        _iCloudBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _iCloudBtn.frame = CGRectMake(self.bounds.size.width-30, 0, 30, 30);
        _iCloudBtn.tintColor = [THEME_COLOR colorWithAlphaComponent:0.5];
        [_iCloudBtn setImage:[[UIImage imageNamed:@"album_xz"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_iCloudBtn addTarget:self action:@selector(iCloudBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _iCloudBtn.hidden = YES;
        [self addSubview:_iCloudBtn];
    }
    return self;
}

- (void)setConfig:(WZMAlbumConfig *)config model:(WZMAlbumModel *)model {
    self.model = model;
    self.config = config;
    if (model.image) {
        _photoImageView.image = model.image;
        [self setICloud:model.isICloud];
    }
    else {
        //获取缩略图
        int32_t imageRequestID = [WZMAlbumHelper wzm_getThumbnailWithAsset:model.asset photoWidth:self.bounds.size.width thumbnail:^(UIImage *photo) {
            _photoImageView.image = photo;
            model.image = photo;
        } cloud:^(BOOL iCloud) {
            model.iCloud = iCloud;
            [self setICloud:model.isICloud];
        }];
        if (imageRequestID && _imageRequestID && imageRequestID != _imageRequestID) {
            [[PHImageManager defaultManager] cancelImageRequest:_imageRequestID];
        }
        _imageRequestID = imageRequestID;
    }
    
    if (model.type == WZMAlbumPhotoTypePhotoGif) {
        _gifLabel.hidden = NO;
        _videoTimeView.hidden = YES;
        _playImageView.hidden = YES;
        _videoTimeLabel.text = @"";
    }
    else if (model.type == WZMAlbumPhotoTypeVideo) {
        _gifLabel.hidden = YES;
        _videoTimeView.hidden = NO;
        _playImageView.hidden = NO;
        _videoTimeLabel.text = [self getTimeWithAsset:model.asset];
    }
    else {
        _gifLabel.hidden = YES;
        _videoTimeView.hidden = YES;
        _playImageView.hidden = YES;
        _videoTimeLabel.text = @"";
    }
    
    if (config.maxCount == 1 || config.allowShowIndex == NO) {
        _indexLabel.text = @"";
        _indexLabel.hidden = !model.isSelected;
    }
    else {
        if (model.isSelected) {
            _indexLabel.hidden = NO;
            _indexLabel.text = [NSString stringWithFormat:@"%@",@(model.index)];
        }
        else {
            _indexLabel.hidden = YES;
            _indexLabel.text = @"";
        }
    }
}

- (void)setICloud:(BOOL)iCloud {
    if (iCloud) {
        _iCloudBtn.hidden = NO;
        _previewBtn.hidden = YES;
        if (self.model.isDownloading) {
            [_activityView startAnimating];
        }
        else {
            [_activityView stopAnimating];
        }
    }
    else {
        _iCloudBtn.hidden = YES;
        _previewBtn.hidden = !self.config.allowPreview;
        [_activityView stopAnimating];
    }
}

//预览按钮点击事件
- (void)previewBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(albumPhotoCellWillShowPreview:)]) {
        [self.delegate albumPhotoCellWillShowPreview:self];
    }
}

//iCloud按钮点击事件
- (void)iCloudBtnClick:(UIButton *)btn {
    if (self.model.isDownloading) return;
    self.model.downloading = YES;
    [_activityView startAnimating];
    [self.model getICloudImageCompletion:^(id obj) {
        [self setICloud:NO];
    }];
}

- (NSString *)getTimeWithAsset:(id)asset {
    NSInteger second = [(PHAsset *)asset duration];
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
