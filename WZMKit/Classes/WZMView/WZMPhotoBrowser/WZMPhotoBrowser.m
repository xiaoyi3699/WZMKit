//
//  WZMPhotoBrowser.m
//  WZMKit
//
//  Created by WangZhaomeng on 2017/12/13.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMPhotoBrowser.h"
#import "WZMPhotoBrowserCell.h"
#import "WZMMacro.h"
#import "WZMLogPrinter.h"
#import "UIImage+wzmcate.h"

@interface WZMPhotoBrowser ()<UICollectionViewDelegate,UICollectionViewDataSource,WZMPhotoBrowserCellDelegate>

@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation WZMPhotoBrowser

- (instancetype)init {
    self = [super init];
    if (self) {
        self.bgImage = [UIImage wzm_getScreenImageByView:[UIApplication sharedApplication].delegate.window];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.bgImageView.image = self.bgImage;
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.contentView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = self.view.bounds.size;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
#else
    self.automaticallyAdjustsScrollViewInsets = NO;
#endif
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_collectionView];
    [_collectionView registerClass:[WZMPhotoBrowserCell class] forCellWithReuseIdentifier:@"WZMPhotoCell"];
    [self scrollToIndex:self.index];
    
    UIView *closeView = [[UIView alloc] initWithFrame:CGRectMake(10, WZM_STATUS_HEIGHT, 40, 40)];
    closeView.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.2];
    closeView.layer.masksToBounds = YES;
    closeView.layer.cornerRadius = 20;
    [self.contentView addSubview:closeView];
    
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeItemTap)];
    [closeView addGestureRecognizer:closeTap];
    
    UIImageView *closeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 14, 12, 12)];
    closeImageView.image = [WZMPublic imageWithFolder:@"common" imageName:@"close_1.png"];
    [closeView addSubview:closeImageView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.bgImageView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.bgImageView.hidden = YES;
}

- (void)closeItemTap {
    if ([self.delegate respondsToSelector:@selector(photoBrowser:clickAtIndex:contentType:gestureType:)]) {
        [self.delegate photoBrowser:self clickAtIndex:self.index contentType:WZMAlbumPhotoTypePhoto gestureType:WZMGestureRecognizerTypeClose];
    }
}

#pragma mark - WZMPhotoBrowserCellDelegate
- (void)photoBrowserCell:(WZMPhotoBrowserCell *)photoBrowserCell didPanWithAlpha:(CGFloat)alpha {
    self.contentView.alpha = alpha;
}

- (void)photoBrowserCell:(WZMPhotoBrowserCell *)photoBrowserCell
        clickAtIndexPath:(NSIndexPath *)indexPath
             contentType:(WZMAlbumPhotoType)contentType
             gestureType:(WZMGestureRecognizerType)gestureType {
    if ([self.delegate respondsToSelector:@selector(photoBrowser:clickAtIndex:contentType:gestureType:)]) {
        [self.delegate photoBrowser:self clickAtIndex:indexPath.row contentType:contentType gestureType:gestureType];
    }
}

#define mark - UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WZMPhotoBrowserCell *cell = (WZMPhotoBrowserCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"WZMPhotoCell" forIndexPath:indexPath];
    if (cell.delegate == nil) {
        cell.delegate = self;
    }
    cell.indexPath = indexPath;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[WZMPhotoBrowserCell class]]) {
        WZMPhotoBrowserCell *photoCell = (WZMPhotoBrowserCell *)cell;
        [photoCell didEndDisplay];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[WZMPhotoBrowserCell class]]) {
        WZMPhotoBrowserCell *photoCell = (WZMPhotoBrowserCell *)cell;
        if (indexPath.row < _images.count) {
            [photoCell setImage:_images[indexPath.row]];
        }
        [photoCell willDisplay];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _index = scrollView.contentOffset.x/WZM_SCREEN_WIDTH;
}

#pragma mark - setter
- (void)setImages:(NSArray *)images {
    if (_images == images) return;
    _images = images;
    [_collectionView reloadData];
}

- (void)setIndex:(NSInteger)index {
    if (_index == index) return;
    _index = index;
    [self scrollToIndex:index];
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
        _contentView.backgroundColor = [UIColor blackColor];
    }
    return _contentView;
}

//偏移
- (void)scrollToIndex:(NSInteger)index {
    if (index < _images.count) {
        [_collectionView setContentOffset:CGPointMake(WZM_SCREEN_WIDTH*index, 0)];
    }
}

- (BOOL)wzm_navigationShouldDrag {
    return NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)dealloc {
    WZMLog(@"%@释放了",NSStringFromClass(self.class));
}

@end
