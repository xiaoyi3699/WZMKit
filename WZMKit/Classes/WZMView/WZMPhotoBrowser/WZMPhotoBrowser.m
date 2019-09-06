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

@interface WZMPhotoBrowser ()<UICollectionViewDelegate,UICollectionViewDataSource,WZMPhotoBrowserCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation WZMPhotoBrowser

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
    [_collectionView registerClass:[WZMPhotoBrowserCell class] forCellWithReuseIdentifier:@"WZMPhotoCell"];
    [self scrollToIndex:self.index];
    
    UIView *closeView = [[UIView alloc] initWithFrame:CGRectMake(10, WZM_STATUS_HEIGHT, 40, 40)];
    closeView.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.2];
    closeView.layer.masksToBounds = YES;
    closeView.layer.cornerRadius = 20;
    [self.view addSubview:closeView];
    
    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeItemTap)];
    [closeView addGestureRecognizer:closeTap];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 14, 12, 12)];
    imageView.image = [WZMPublic imageNamed:@"close_1" ofType:@"png"];
    [closeView addSubview:imageView];
}

- (void)showFromController:(UIViewController *)controller {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [UIView transitionWithView:window duration:0.35 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [controller presentViewController:self animated:NO completion:nil];
    } completion:nil];
}

- (void)dismiss {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [UIView transitionWithView:window duration:0.35 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self dismissViewControllerAnimated:NO completion:nil];
    } completion:nil];
}

- (void)closeItemTap {
    [self dismiss];
}

#pragma mark - WZMPhotoBrowserCellDelegate
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
    cell.indexPath = indexPath;
    cell.delegate = self;
    if (indexPath.row < _images.count) {
        [cell setImage:_images[indexPath.row]];
    }
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
        [_collectionView setContentOffset:CGPointMake(WZM_SCREEN_WIDTH*index, 0)];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
