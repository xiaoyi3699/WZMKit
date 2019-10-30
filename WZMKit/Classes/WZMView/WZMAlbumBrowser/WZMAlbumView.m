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
#import "WZMAlbumHelper.h"
#import "WZMMacro.h"
#import "UIColor+wzmcate.h"

@interface WZMAlbumView ()<UICollectionViewDelegate,UICollectionViewDataSource,WZMAlbumCellDelegate>

@property (nonatomic, assign) BOOL hasViews;
@property (nonatomic, assign) BOOL onlyOne;
@property (nonatomic, strong) WZMAlbumConfig *config;
@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, assign) CGRect albumFrame;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) WZMAlbumModel *selectedAlbum;
@property (nonatomic, strong) NSMutableArray<WZMAlbumModel *> *allAlbums;
@property (nonatomic, strong) NSMutableArray<WZMAlbumPhotoModel *> *selectedPhotos;

@end

@implementation WZMAlbumView {
    CGSize _itemSize;
    NSInteger _lastRow;
    NSInteger _lastColumn;
    NSInteger _selectIndex;
}

- (instancetype)initWithConfig:(WZMAlbumConfig *)config {
    self = [super init];
    if (self) {
        [self setupConfig:config];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame config:(WZMAlbumConfig *)config {
    self = [super init];
    if (self) {
        [self setupConfig:config];
        [self setFrame:frame];
    }
    return self;
}

- (void)setupConfig:(WZMAlbumConfig *)config {
    self.hasViews = NO;
    self.config = config;
    self.onlyOne = (config.allowPreview == NO && config.maxCount == 1);
    self.allAlbums = [[NSMutableArray alloc] initWithCapacity:0];
    self.selectedPhotos = [[NSMutableArray alloc] initWithCapacity:0];
    _selectIndex = 0;
    if (self.onlyOne == NO) {
        if (config.allowDragSelect) {
            UIPanGestureRecognizer *selectPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(selectPanGesture:)];
            [self addGestureRecognizer:selectPan];
        }
    }
    [WZMAlbumHelper addUpdateAlbumObserver:self selector:@selector(collectionViewReloadData)];
}

- (void)setFrame:(CGRect)frame {
    if (CGRectIsNull(frame)) return;
    if (CGRectEqualToRect(frame, CGRectZero)) return;
    if (CGRectEqualToRect(frame, self.frame)) return;
    [super setFrame:frame];
    CGFloat toolHeight = 50;
    if (self.onlyOne) {
        toolHeight = 0;
    }
    if (self.hasViews == NO) {
        self.hasViews = YES;
        self.albumFrame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-toolHeight-WZM_BOTTOM_HEIGHT);
        CGFloat itemW = floor((self.albumFrame.size.width-10-5*(self.config.column-1))/self.config.column);
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
            self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.collectionView.wzm_maxY, self.bounds.size.width, toolHeight)];
            self.toolView.backgroundColor = [UIColor wzm_getDynamicColorByLightColor:WZM_R_G_B(235, 235, 235) darkColor:WZM_R_G_B(20, 20, 20)];
            [self addSubview:self.toolView];
            
            self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.wzm_width-110, 7, 100, 36)];
            self.countLabel.text = [NSString stringWithFormat:@"完成(%@/%@)",@(self.selectedPhotos.count),@(self.config.maxCount)];
            self.countLabel.font = [UIFont systemFontOfSize:14];
            self.countLabel.textColor = [UIColor whiteColor];
            self.countLabel.textAlignment = NSTextAlignmentCenter;
            self.countLabel.wzm_cornerRadius = 5;
            self.countLabel.backgroundColor = WZM_ALBUM_COLOR;
            self.countLabel.userInteractionEnabled = YES;
            [self.toolView addSubview:self.countLabel];
            
            UITapGestureRecognizer *okTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectedFinish)];
            [self.countLabel addGestureRecognizer:okTap];
            
            UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.wzm_width-self.countLabel.wzm_width-20, toolHeight)];
            msgLabel.text = [NSString stringWithFormat:@"最多选择%@张图片",@(self.config.maxCount)];
            msgLabel.font = [UIFont systemFontOfSize:13];
            msgLabel.textColor = [UIColor wzm_getDynamicColorByLightColor:WZM_ALBUM_COLOR darkColor:[UIColor whiteColor]];
            msgLabel.textAlignment = NSTextAlignmentLeft;
            [self.toolView addSubview:msgLabel];
        }
    }
    self.collectionView.wzm_height = self.bounds.size.height-toolHeight-WZM_BOTTOM_HEIGHT;
    self.toolView.wzm_minY = self.collectionView.wzm_maxY;
}

//确定按钮点击事件
- (void)didSelectedFinish {
    if ([self.delegate respondsToSelector:@selector(albumViewDidSelectedFinish:)]) {
        [self.delegate albumViewDidSelectedFinish:self];
    }
}

//cell代理
- (void)albumPhotoCellDidSelectedIndexBtn:(WZMAlbumCell *)cell {
    [self checkSelectedAtIndexPath:cell.indexPath];
}

//刷新相册
- (void)reloadData {
    if (self.allAlbums.count > 0) return;
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    if (!self.config.allowShowImage) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
    if (!self.config.allowShowVideo) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in smartAlbums) {
        if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
        if (collection.estimatedAssetCount <= 0) continue;
        if ([self isCameraRollAlbum:collection]) {
            WZMAlbumModel *cameraRollAlbumModel = [[WZMAlbumModel alloc] init];
            cameraRollAlbumModel.title = @"相机胶卷";
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PHAsset *phAsset = (PHAsset *)obj;
                WZMAlbumPhotoModel *model = [WZMAlbumPhotoModel modelWithAsset:phAsset];
                model.localIdentifier = phAsset.localIdentifier;
                [cameraRollAlbumModel.photos addObject:model];
            }];
            cameraRollAlbumModel.count = cameraRollAlbumModel.photos.count;
            [self.allAlbums addObject:cameraRollAlbumModel];
            break;
        }
    }
    
    PHFetchResult *customAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in customAlbums) {
        if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
        if (collection.estimatedAssetCount <= 0) continue;
        WZMAlbumModel *albumModel = [[WZMAlbumModel alloc] init];
        albumModel.title = collection.localizedTitle;
        [self.allAlbums addObject:albumModel];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAsset *phAsset = (PHAsset *)obj;
            WZMAlbumPhotoModel *model = [WZMAlbumPhotoModel modelWithAsset:phAsset];
            model.localIdentifier = phAsset.localIdentifier;
            [albumModel.photos addObject:model];
        }];
        albumModel.count = albumModel.photos.count;
    }
    WZMAlbumModel *albumModel = [self.allAlbums objectAtIndex:0];
    [self reloadDataWithAlbumModel:albumModel];
}

- (void)reloadDataWithAlbumModel:(WZMAlbumModel *)albumModel {
    self.selectedAlbum = albumModel;
    [self.collectionView reloadData];
}

- (void)collectionViewReloadData {
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
        [self checkSelectedAtIndexPath:indexPath];
    }
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource && UICollectionViewDelegateWaterfallLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedAlbum.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WZMAlbumCell *cell = (WZMAlbumCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    if (indexPath.row < self.selectedAlbum.photos.count) {
        [cell setConfig:self.config model:[self.selectedAlbum.photos objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.selectedAlbum.photos.count) return;
    if (self.config.allowPreview) {
        if ([self.delegate respondsToSelector:@selector(albumViewWillPreview:atIndexPath:)]) {
            [self.delegate albumViewWillPreview:self atIndexPath:indexPath];
        }
    }
    else {
        [self checkSelectedAtIndexPath:indexPath];
    }
}

#pragma mark - private method
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

//检查是否是iCloud图片
- (void)checkSelectedAtIndexPath:(NSIndexPath *)indexPath {
    WZMAlbumPhotoModel *model = [self.selectedAlbum.photos objectAtIndex:indexPath.row];
    BOOL isICloud = model.isICloud;
    BOOL isAllowSelect = (model.type == WZMAlbumPhotoTypePhoto && self.config.allowUseThumbnail);
    [model getOriginalCompletion:^(id original) {
        if (original || isAllowSelect) {
            [self didSelectedAtIndexPath:indexPath];
        }
        else {
            [WZMAlbumHelper showiCloudError];
        }
        if (isICloud) {
            [self.collectionView reloadData];
        }
    }];
    if (isICloud && model.isSelected == NO) {
        [self.collectionView reloadData];
    }
}

//选中图片
- (void)didSelectedAtIndexPath:(NSIndexPath *)indexPath {
    if (self.onlyOne) {
        WZMAlbumPhotoModel *model = [self.selectedAlbum.photos objectAtIndex:indexPath.row];
        [self.selectedPhotos addObject:model];
        [self didSelectedFinish];
        if (self.selectedAlbum.selectedCount < self.selectedAlbum.count) {
            self.selectedAlbum.selectedCount ++;
        }
    }
    else {
        WZMAlbumPhotoModel *model = [self.selectedAlbum.photos objectAtIndex:indexPath.row];
        if (model.isSelected) {
            model.selected = NO;
            model.index = 1;
            NSInteger index = [self.selectedPhotos indexOfObject:model];
            for (NSInteger i = index+1; i < self.selectedPhotos.count; i ++) {
                WZMAlbumPhotoModel *tmodel = [self.selectedPhotos objectAtIndex:i];
                tmodel.index = tmodel.index-1;
            }
            [self.selectedPhotos removeObject:model];
            if (self.selectedAlbum.selectedCount > 0) {
                self.selectedAlbum.selectedCount --;
            }
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
            if (self.selectedAlbum.selectedCount < self.selectedAlbum.count) {
                self.selectedAlbum.selectedCount ++;
            }
        }
        [self.collectionView reloadData];
        self.countLabel.text = [NSString stringWithFormat:@"完成(%@/%@)",@(self.selectedPhotos.count),@(self.config.maxCount)];
    }
}

- (void)dealloc {
    WZMLog(@"%@释放了",NSStringFromClass(self.class));
    [WZMAlbumHelper removeUpdateAlbumObserver:self];
}

@end
