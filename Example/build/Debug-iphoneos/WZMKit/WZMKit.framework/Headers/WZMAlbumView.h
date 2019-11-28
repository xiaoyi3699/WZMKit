//
//  WZMAlbumView.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMAlbumModel.h"
#import "WZMAlbumPhotoModel.h"
#import "WZMAlbumConfig.h"
@protocol WZMAlbumViewDelegate;

@interface WZMAlbumView : UIView

///配置
@property (nonatomic, readonly, strong) WZMAlbumConfig *config;
///代理
@property (nonatomic, weak) id<WZMAlbumViewDelegate> delegate;
///视图
@property (nonatomic, readonly, strong) UICollectionView *collectionView;
///选中的相册
@property (nonatomic, readonly, strong) WZMAlbumModel *selectedAlbum;
///所有相册
@property (nonatomic, readonly, strong) NSMutableArray<WZMAlbumModel *> *allAlbums;
///选中的图片
@property (nonatomic, readonly, strong) NSMutableArray<WZMAlbumPhotoModel *> *selectedPhotos;

- (void)reloadData;
- (void)reloadDataWithAlbumModel:(WZMAlbumModel *)albumModel;

- (instancetype)initWithConfig:(WZMAlbumConfig *)config;
- (instancetype)initWithFrame:(CGRect)frame config:(WZMAlbumConfig *)config;

@end

@protocol WZMAlbumViewDelegate <NSObject>

@optional
- (void)albumViewDidSelectedFinish:(WZMAlbumView *)albumView;
- (void)albumViewWillPreview:(WZMAlbumView *)albumView atIndexPath:(NSIndexPath *)indexPath;

@end
