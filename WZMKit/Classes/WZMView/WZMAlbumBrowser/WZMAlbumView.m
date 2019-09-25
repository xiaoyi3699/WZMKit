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
#import "UIView+wzmcate.h"
#import "WZMLogPrinter.h"
#import "WZMViewHandle.h"

@interface WZMAlbumView ()<UICollectionViewDelegate,UICollectionViewDataSource,WZMAlbumCellDelegate>

@property (nonatomic, assign) BOOL onlyOne;
@property (nonatomic, strong) WZMAlbumConfig *config;
@property (nonatomic, strong) UIVisualEffectView *toolView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, assign) CGRect albumFrame;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<WZMAlbumModel *> *allPhotos;
@property (nonatomic, strong) NSMutableArray<WZMAlbumModel *> *selectedPhotos;

@end

@implementation WZMAlbumView {
    CGSize _itemSize;
    NSInteger _lastRow;
    NSInteger _lastColumn;
}

- (instancetype)initWithFrame:(CGRect)frame config:(WZMAlbumConfig *)config {
    self = [super initWithFrame:frame];
    if (self) {
        self.config = config;
        self.onlyOne = (config.allowPreview == NO && config.maxCount == 1);
        self.allPhotos = [[NSMutableArray alloc] initWithCapacity:0];
        self.selectedPhotos = [[NSMutableArray alloc] initWithCapacity:0];
        
        CGFloat toolHeight = 50;
        if (self.onlyOne) {
            toolHeight = 0;
        }
        self.albumFrame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-toolHeight);
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
        collectionView.backgroundColor = [UIColor clearColor];
        if (@available(iOS 11.0, *)) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [collectionView registerClass:[WZMAlbumCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:collectionView];
        self.collectionView = collectionView;
        
        if (self.onlyOne == NO) {
            self.toolView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
            self.toolView.frame = CGRectMake(0, self.collectionView.wzm_maxY, self.bounds.size.width, toolHeight);
            self.toolView.backgroundColor = [UIColor colorWithRed:244/255. green:240/255. blue:240/255. alpha:0.8];
            [self addSubview:self.toolView];
            
            self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.wzm_width-110, 7, 100, 36)];
            self.countLabel.text = [NSString stringWithFormat:@"完成(%@/%@)",@(self.selectedPhotos.count),@(config.maxCount)];
            self.countLabel.font = [UIFont systemFontOfSize:14];
            self.countLabel.textColor = [UIColor whiteColor];
            self.countLabel.textAlignment = NSTextAlignmentCenter;
            self.countLabel.wzm_cornerRadius = 5;
            self.countLabel.backgroundColor = WZM_ALBUM_COLOR;
            self.countLabel.userInteractionEnabled = YES;
            [self.toolView.contentView addSubview:self.countLabel];
            
            UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.wzm_width-self.countLabel.wzm_minX-5, toolHeight)];
            msgLabel.text = [NSString stringWithFormat:@"最多选择%@张图片",@(config.maxCount)];
            msgLabel.font = [UIFont systemFontOfSize:13];
            msgLabel.textColor = WZM_ALBUM_COLOR;
            msgLabel.textAlignment = NSTextAlignmentLeft;
            [self.toolView.contentView addSubview:msgLabel];
            
            UITapGestureRecognizer *okTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectedFinish)];
            [self.countLabel addGestureRecognizer:okTap];
            
            UIPanGestureRecognizer *selectPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(selectPanGesture:)];
            [self addGestureRecognizer:selectPan];
        }
    }
    return self;
}

//确定按钮点击事件
- (void)didSelectedFinish {
    if ([self.delegate respondsToSelector:@selector(albumViewDidSelectedFinish:)]) {
        [self.delegate albumViewDidSelectedFinish:self];
    }
}

//cell代理
- (void)albumPhotoCellWillPreview:(WZMAlbumCell *)cell {
    if ([self.delegate respondsToSelector:@selector(albumViewWillPreview:atIndexPath:)]) {
        [self.delegate albumViewWillPreview:self atIndexPath:cell.indexPath];
    }
}

//刷新相册
- (void)reloadData {
    [self.allPhotos removeAllObjects];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    if (!self.config.allowShowImage) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
    if (!self.config.allowShowVideo) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
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
                [self.allPhotos addObject:model];
            }];
            break;
        }
    }
    [self.collectionView reloadData];
}

//滑动选择
- (void)selectPanGesture:(UIPanGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _lastRow = -1;
        _lastColumn = -1;
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        _itemSize = layout.itemSize;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        NSInteger row = ceil((self.collectionView.contentOffset.y+point.y)/(_itemSize.height+5))-1;
        NSInteger column = ceil(point.x/(_itemSize.width+5))-1;
        if (row < 0) {
            row = 0;
        }
        if (column < 0) {
            column = 0;
        }
        else if (column > self.config.column-1) {
            column = self.config.column-1;
        }
        if (_lastRow == row && _lastColumn == column) return;
        _lastRow = row; _lastColumn = column;
        NSInteger index = row*self.config.column+column;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource && UICollectionViewDelegateWaterfallLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WZMAlbumCell *cell = (WZMAlbumCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    if (indexPath.row < self.allPhotos.count) {
        [cell setConfig:self.config model:[self.allPhotos objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.allPhotos.count) return;
    if (self.onlyOne) {
        WZMAlbumModel *model = [self.allPhotos objectAtIndex:indexPath.row];
        [self.selectedPhotos addObject:model];
        [self didSelectedFinish];
    }
    else {
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
                [WZMViewHandle wzm_showInfoMessage:msg];
                return;
            }
            model.index = self.selectedPhotos.count+1;
            model.selected = YES;
            [self.selectedPhotos addObject:model];
        }
        [collectionView reloadData];
        self.countLabel.text = [NSString stringWithFormat:@"完成(%@/%@)",@(self.selectedPhotos.count),@(self.config.maxCount)];
    }
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
