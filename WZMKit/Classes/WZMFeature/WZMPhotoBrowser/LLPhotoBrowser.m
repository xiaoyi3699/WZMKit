//
//  LLPhotoBrowser.m
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2017/12/13.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "LLPhotoBrowser.h"
#import "LLMacro.h"

@interface LLPhotoBrowser ()<UICollectionViewDelegate,UICollectionViewDataSource,LLPhotoBrowserCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation LLPhotoBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = self.view.bounds.size;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor blackColor];
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
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[LLPhotoBrowserCell class] forCellWithReuseIdentifier:@"LLPhotoCell"];
    [self scrollToIndex:self.index];
}

#pragma mark - LLPhotoBrowserCellDelegate
- (void)photoBrowserCell:(LLPhotoBrowserCell *)photoBrowserCell
        clickAtIndexPath:(NSIndexPath *)indexPath
                 content:(id)content
                   isGif:(BOOL)isGif
                    type:(LLGestureRecognizerType)type {
    if ([self.delegate respondsToSelector:@selector(photoBrowser:clickAtIndex:content:isGif:type:)]) {
        [self.delegate photoBrowser:self clickAtIndex:indexPath.row content:content isGif:isGif type:type];
    }
}

#define mark - UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LLPhotoBrowserCell *cell = (LLPhotoBrowserCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"LLPhotoCell"
                                                                                               forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
    if (indexPath.row < _images.count) {
        [cell setImage:_images[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[LLPhotoBrowserCell class]]) {
        LLPhotoBrowserCell *photoCell = (LLPhotoBrowserCell *)cell;
        [photoCell didEndDisplay];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[LLPhotoBrowserCell class]]) {
        LLPhotoBrowserCell *photoCell = (LLPhotoBrowserCell *)cell;
        [photoCell willDisplay];
    }
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

//偏移
- (void)scrollToIndex:(NSInteger)index {
    if (index < _images.count) {
        [_collectionView setContentOffset:CGPointMake(LL_SCREEN_WIDTH*index, 0)];
    }
}

@end
