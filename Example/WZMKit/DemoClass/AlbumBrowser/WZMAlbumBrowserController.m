//
//  WZMAlbumBrowserController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMAlbumBrowserController.h"
#import "WZMAlbumModel.h"
#import "WZMAlbumPhotoCell.h"

@interface WZMAlbumBrowserController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<WZMAlbumModel *> *albums;
@property (nonatomic, strong) NSMutableArray<WZMAlbumPhotoModel *> *photos;

@end

@implementation WZMAlbumBrowserController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.column = 4;
        self.allowPickingImage = YES;
        self.allowPickingVideo = YES;
        self.albumFrame = [UIScreen mainScreen].bounds;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat itemW = floor((self.albumFrame.size.width-20-10*(self.column-1))/self.column);
    CGFloat itemH = itemW;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.albumFrame collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0, *)) {
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [collectionView registerClass:[WZMAlbumPhotoCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:collectionView];
    self.photos = [[NSMutableArray alloc] initWithCapacity:0];
    [self loadPhotoWithAlbum:@"All Photos"];
}

- (void)loadPhotoWithAlbum:(NSString *)album {
    [self.photos removeAllObjects];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    if (!self.allowPickingVideo) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    if (!self.allowPickingImage) option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",
                                                     PHAssetMediaTypeVideo];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    if ([album isEqualToString:@"All Photos"]) {
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        for (PHAssetCollection *collection in smartAlbums) {
            if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
            if (collection.estimatedAssetCount <= 0) continue;
            if ([self isCameraRollAlbum:collection]) {
                NSLog(@"%@",collection.localizedTitle);
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
                [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    PHAsset *phAsset = (PHAsset *)obj;
                    WZMAlbumPhotoModel *model = [WZMAlbumPhotoModel modelWithAsset:phAsset];
                    [self.photos addObject:model];
                }];
                break;
            }
        }
    }
    [self.collectionView reloadData];
    
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource && UICollectionViewDelegateWaterfallLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WZMAlbumPhotoCell *cell = (WZMAlbumPhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row < self.photos.count) {
        [cell setConfig:[self.photos objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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

- (void)setColumn:(NSInteger)column {
    if (_column == column) return;
    if (column < 1 || column > 5) {
        _column = 4;
        return;
    }
    _column = column;
}

@end
