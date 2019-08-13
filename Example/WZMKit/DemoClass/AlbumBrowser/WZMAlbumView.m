//
//  WZMAlbumView.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMAlbumView.h"
#import "WZMAlbumCell.h"
#import <Photos/Photos.h>

@interface WZMAlbumView ()<UICollectionViewDelegate,UICollectionViewDataSource,WZMAlbumCellDelegate>

@property (nonatomic, strong) WZMAlbumConfig *config;
@property (nonatomic, strong) UIVisualEffectView *toolView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, assign) CGRect albumFrame;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<WZMAlbumModel *> *allPhotos;
@property (nonatomic, strong) NSMutableArray<WZMAlbumModel *> *selectedPhotos;

@end

@implementation WZMAlbumView

- (instancetype)initWithFrame:(CGRect)frame config:(WZMAlbumConfig *)config {
    self = [super initWithFrame:frame];
    if (self) {
        self.config = config;
        self.albumFrame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-44);
        self.allPhotos = [[NSMutableArray alloc] initWithCapacity:0];
        self.selectedPhotos = [[NSMutableArray alloc] initWithCapacity:0];
        
        CGFloat itemW = floor((self.albumFrame.size.width-10-5*(config.column-1))/config.column);
        CGFloat itemH = itemW;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.albumFrame collectionViewLayout:flowLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [collectionView registerClass:[WZMAlbumCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:collectionView];
        self.collectionView = collectionView;
        
        self.toolView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        self.toolView.frame = CGRectMake(0, self.collectionView.wzm_maxY, self.bounds.size.width, 44);
        [self addSubview:self.toolView];
        
        UIView *toolLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.toolView.wzm_width, 0.5)];
        toolLineView.backgroundColor = WZM_R_G_B(220, 220, 220);
        [self.toolView.contentView addSubview:toolLineView];
        
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        okBtn.frame = CGRectMake(self.toolView.wzm_width-50, 0, 40, 44);
        okBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [okBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.toolView.contentView addSubview:okBtn];
        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(okBtn.wzm_minX-90, 7, 80, 30)];
        self.countLabel.text = [NSString stringWithFormat:@"%@/%@",@(self.selectedPhotos.count),@(config.maxCount)];
        self.countLabel.font = [UIFont systemFontOfSize:17];
        self.countLabel.textColor = [UIColor whiteColor];
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        self.countLabel.wzm_cornerRadius = 15;
        self.countLabel.backgroundColor = THEME_COLOR;
        [self.toolView.contentView addSubview:self.countLabel];
    }
    return self;
}

- (void)okBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(albumViewDidSelectedFinish:)]) {
        [self.delegate albumViewDidSelectedFinish:self];
    }
}

- (void)reloadData {
    [self.allPhotos removeAllObjects];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    if (!self.config.allowShowImage) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
    if (!self.config.allowShowVideo) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",
                                                  PHAssetMediaTypeImage];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in smartAlbums) {
        if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
        if (collection.estimatedAssetCount <= 0) continue;
        if ([self isCameraRollAlbum:collection]) {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PHAsset *phAsset = (PHAsset *)obj;
                WZMAlbumModel *model = [WZMAlbumModel modelWithAsset:phAsset];
                if (self.config.allowShowGIF == NO) {
                    if (model.type != WZMAlbumPhotoTypePhotoGif) {
                        [self.allPhotos addObject:model];
                    }
                }
            }];
            break;
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource && UICollectionViewDelegateWaterfallLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WZMAlbumCell *cell = (WZMAlbumCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.row < self.allPhotos.count) {
        [cell setConfig:self.config photoModel:[self.allPhotos objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WZMAlbumModel *model = [self.allPhotos objectAtIndex:indexPath.row];
    if (model.isSelected) {
        model.selected = NO;
        model.index = 1;
        NSInteger index = [self.selectedPhotos indexOfObject:model];
        for (NSInteger i = index+1; i < self.selectedPhotos.count; i ++) {
            WZMAlbumModel *tmodel = [self.selectedPhotos objectAtIndex:i];
            tmodel.index = tmodel.index-1;
        }
        [self.selectedPhotos removeObject:model];
    }
    else {
        if (self.selectedPhotos.count+1 > self.config.maxCount) {
            NSString *msg = [NSString stringWithFormat:@"最多只能选%@张照片",@(self.config.maxCount)];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        model.index = self.selectedPhotos.count+1;
        model.selected = YES;
        [self.selectedPhotos addObject:model];
    }
    [collectionView reloadData];
    self.countLabel.text = [NSString stringWithFormat:@"%@/%@",@(self.selectedPhotos.count),@(self.config.maxCount)];
}

- (BOOL)isCameraRollAlbum:(PHAssetCollection *)metadata {
    NSString *versionStr = [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (versionStr.length <= 1) {
        versionStr = [versionStr stringByAppendingString:@"00"];
    } else if (versionStr.length <= 2) {
        versionStr = [versionStr stringByAppendingString:@"0"];
    }
    CGFloat version = versionStr.floatValue;
    // 目前已知8.0.0 ~ 8.0.2系统，拍照后的图片会保存在最近添加中
    if (version >= 800 && version <= 802) {
        return ((PHAssetCollection *)metadata).assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded;
    } else {
        return ((PHAssetCollection *)metadata).assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary;
    }
}

- (void)dealloc {
    WZMLog(@"%@释放了",NSStringFromClass(self.class));
}

@end
