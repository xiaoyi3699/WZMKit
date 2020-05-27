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
#import "WZMPublic.h"
#import "WZMButton.h"
#import "WZMAlbumLocalView.h"

@interface WZMAlbumCell ()

@property (nonatomic, strong) WZMAlbumPhotoModel *model;
@property (nonatomic, strong) WZMAlbumConfig *config;
@property (nonatomic, assign, getter=isDisplay) BOOL display;

@end

@implementation WZMAlbumCell {
    UIImageView *_photoImageView;
    UILabel *_gifLabel;
    UIView *_videoTimeView;
    UILabel *_videoTimeLabel;
    UIImageView *_playImageView;
    UILabel *_indexLabel;
    WZMButton *_localBtn;
    WZMButton *_iCloudBtn;
    WZMButton *_indexBtn;
    CAKeyframeAnimation *_animation;
    UIActivityIndicatorView *_activityView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _photoImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.clipsToBounds = YES;
        [self addSubview:_photoImageView];
        
        _playImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width-20)/2, (self.bounds.size.height-20)/2, 20, 20)];
        _playImageView.image = [WZMPublic imageWithFolder:@"album" imageName:@"album_play.png"];
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
        videoImageView.image = [WZMPublic imageWithFolder:@"album" imageName:@"album_video.png"];
        [_videoTimeView addSubview:videoImageView];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.frame = self.bounds;
        _activityView.hidesWhenStopped = YES;
        [self addSubview:_activityView];
        
        _gifLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-25, self.bounds.size.height-15, 25, 15)];
        _gifLabel.text = @"GIF";
        _gifLabel.font = [UIFont systemFontOfSize:10];
        _gifLabel.textColor = [UIColor whiteColor];
        _gifLabel.backgroundColor = [UIColor blackColor];
        _gifLabel.textAlignment = NSTextAlignmentCenter;
        _gifLabel.hidden = YES;
        [self addSubview:_gifLabel];
        
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-30, 0, 30, 30)];
        _indexLabel.text = @"1";
        _indexLabel.font = [UIFont boldSystemFontOfSize:17];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.backgroundColor = WZM_ALBUM_COLOR;
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.hidden = YES;
        _indexLabel.layer.masksToBounds = YES;
        _indexLabel.layer.cornerRadius = 15;
        _indexLabel.userInteractionEnabled = YES;
        [self addSubview:_indexLabel];
        
        UITapGestureRecognizer *indexTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(indexTapGesture:)];
        [_indexLabel addGestureRecognizer:indexTap];
        
        _indexBtn = [WZMButton buttonWithType:UIButtonTypeCustom];
        _indexBtn.frame = CGRectMake(self.bounds.size.width-30, 0, 30, 30);
        _indexBtn.imageFrame = CGRectMake(0, 0, 30, 30);
        _indexBtn.tintColor = [WZM_ALBUM_COLOR colorWithAlphaComponent:0.5];
        [_indexBtn setImage:[WZMPublic imageWithFolder:@"album" imageName:@"album_normal.png"] forState:UIControlStateNormal];
        [_indexBtn addTarget:self action:@selector(indexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_indexBtn];
        
        _iCloudBtn = [WZMButton buttonWithType:UIButtonTypeCustom];
        _iCloudBtn.frame = CGRectMake(0, 0, 30, 30);
        _iCloudBtn.imageFrame = CGRectMake(8, 2, 20, 20);
        _iCloudBtn.tintColor = [WZM_ALBUM_COLOR colorWithAlphaComponent:0.5];
        [_iCloudBtn setImage:[[WZMPublic imageWithFolder:@"album" imageName:@"album_xz.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_iCloudBtn addTarget:self action:@selector(iCloudBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _iCloudBtn.hidden = YES;
        [self addSubview:_iCloudBtn];
        
        _localBtn = [WZMButton buttonWithType:UIButtonTypeCustom];
        _localBtn.frame = CGRectMake(0.0, self.bounds.size.height-30.0, 30.0, 30.0);
        _localBtn.imageFrame = CGRectMake(5.0, 5.0, 20, 20);
        _localBtn.tintColor = [WZM_ALBUM_COLOR colorWithAlphaComponent:0.5];
        [_localBtn setImage:[WZMPublic imageWithFolder:@"album" imageName:@"album_dw@3x.png"] forState:UIControlStateNormal];
        [_localBtn addTarget:self action:@selector(localBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _localBtn.hidden = YES;
        [self addSubview:_localBtn];
    }
    return self;
}

- (void)setConfig:(WZMAlbumConfig *)config model:(WZMAlbumPhotoModel *)model {
    self.model = model;
    self.config = config;
    _localBtn.hidden = (CLLocationCoordinate2DIsValid(model.coordinate) == NO);
    [self setICloud:model.isICloud];
    if (model.thumbnail) {
        _photoImageView.image = model.thumbnail;
    }
    else {
        //获取缩略图
        model.width = self.bounds.size.width;
        [model getThumbnailCompletion:^(UIImage *thumbnail) {
            _photoImageView.image = thumbnail;
        } cloud:^(BOOL iCloud) {
            [self setICloud:iCloud];
        }];
    }
    if (model.type == WZMAlbumPhotoTypeVideo) {
        _gifLabel.hidden = YES;
        _videoTimeView.hidden = NO;
        _playImageView.hidden = NO;
        _videoTimeLabel.text = model.timeStr;
    }
    else if (model.type == WZMAlbumPhotoTypePhotoGif) {
        _gifLabel.hidden = !config.allowShowGIF;
        _videoTimeView.hidden = YES;
        _playImageView.hidden = YES;
        _videoTimeLabel.text = @"";
    }
    else {
        _gifLabel.hidden = YES;
        _videoTimeView.hidden = YES;
        _playImageView.hidden = YES;
        _videoTimeLabel.text = @"";
    }
    
    if (model.isSelected) {
        _indexBtn.hidden = YES;
        _indexLabel.hidden = NO;
        if (config.allowShowIndex) {
            NSString *indexStr = [NSString stringWithFormat:@"%@",@(model.index)];
            if (indexStr.length > 1) {
                _indexLabel.font = [UIFont systemFontOfSize:13];
            }
            else {
                _indexLabel.font = [UIFont systemFontOfSize:17];
            }
            _indexLabel.text = indexStr;
        }
        else {
            _indexLabel.text = @"";
        }
        if (model.isAnimated == NO) {
            model.animated = YES;
            [self startAnimation];
        }
    }
    else {
        _indexBtn.hidden = NO;
        _indexLabel.hidden = YES;
        _indexLabel.text = @"";
        if (model.isAnimated) {
            model.animated = NO;
            [self removeAnimation];
        }
    }
    
    if (config.allowShowIndex == NO) {
        _indexLabel.text = @"";
        _indexLabel.hidden = !model.isSelected;
    }
    else {
        
    }
}

- (void)setICloud:(BOOL)iCloud {
    if (iCloud) {
        _iCloudBtn.hidden = NO;
        if (self.model.isDownloading) {
            [_activityView startAnimating];
        }
        else {
            [_activityView stopAnimating];
        }
    }
    else {
        _iCloudBtn.hidden = YES;
        [_activityView stopAnimating];
    }
}

//选择按钮点击事件
- (void)indexTapGesture:(UITapGestureRecognizer *)recognizer {
    [self indexBtnClick:nil];
}

- (void)indexBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(albumPhotoCellDidSelectedIndexBtn:)]) {
        [self.delegate albumPhotoCellDidSelectedIndexBtn:self];
    }
}

//位置点击事件
- (void)localBtnClick:(UIButton *)btn {
    NSLog(@"经度===%@",@(self.model.coordinate.longitude));
    NSLog(@"维度===%@",@(self.model.coordinate.latitude));
    WZMAlbumLocalView *localView = [[WZMAlbumLocalView alloc] initWithModel:self.model];
    [localView show];
}

//iCloud按钮点击事件
- (void)iCloudBtnClick:(UIButton *)btn {
    if (self.model.isDownloading) return;
    [_activityView startAnimating];
    [self.model getOriginalCompletion:^(id original) {
        if (original) {
            [self setICloud:NO];
        }
        else {
            [self setICloud:YES];
            [WZMAlbumHelper showiCloudError];
        }
    }];
}

- (void)startAnimation {
    if (_animation == nil) {
        _animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        _animation.duration = 0.2;
        _animation.removedOnCompletion = NO;
        _animation.fillMode = kCAFillModeForwards;
        
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        
        _animation.values = values;
        _animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    }
    [_indexLabel.layer addAnimation:_animation forKey:@"index.animation"];
}

- (void)removeAnimation {
    [_indexLabel.layer removeAnimationForKey:@"index.animation"];
}

@end
