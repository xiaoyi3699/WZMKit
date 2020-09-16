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
#import "WZMDefined.h"
#import "UIColor+wzmcate.h"
#import "WZMButton.h"

@interface WZMPhotoBrowser ()<UICollectionViewDelegate,UICollectionViewDataSource,WZMPhotoBrowserCellDelegate>

@property (nonatomic, assign) BOOL statusHidden;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) WZMButton *closeBtn;
@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIImage *bgImage;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation WZMPhotoBrowser

- (instancetype)init {
    self = [super init];
    if (self) {
        self.statusHidden = YES;
#if WZM_APP
        self.bgImage = [UIImage wzm_getScreenImageByView:[UIApplication sharedApplication].delegate.window];
#endif
        self.modalPresentationStyle = UIModalPresentationFullScreen;
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
    
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, WZM_SCREEN_WIDTH, WZM_NAVBAR_HEIGHT)];
    self.navView.backgroundColor = [UIColor wzm_getDynamicColorByLightColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0] darkColor:[UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0]];
    self.navView.alpha = 0.0;
    [self.view addSubview:self.navView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, WZM_STATUS_HEIGHT, WZM_SCREEN_WIDTH-120.0, 44.0)];
    self.titleLabel.textColor = [UIColor wzm_getDynamicColor:[UIColor darkTextColor]];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    self.titleLabel.text = [NSString stringWithFormat:@"%@/%@",@(self.index+1),@(self.images.count)];
    [self.navView addSubview:self.titleLabel];
    
    self.closeBtn = [[WZMButton alloc] initWithFrame:CGRectMake(0.0, WZM_STATUS_HEIGHT, 60.0, 44.0)];
    self.closeBtn.imageFrame = CGRectMake(15.0, 7.0, 30.0, 30.0);
    self.closeBtn.adjustsImageWhenHighlighted = NO;
    [self.closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:self.closeBtn];
    [self traitCollectionDidChange:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.bgImageView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.bgImageView.hidden = YES;
}

- (void)closeBtnClick:(UIButton *)btn {
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
    if (gestureType == WZMGestureRecognizerTypeSingle) {
        CGFloat alpha = 1 - self.navView.alpha;
        self.statusHidden = (alpha == 0.0);
        [self setNeedsStatusBarAppearanceUpdate];
        [UIView animateWithDuration:0.2 animations:^{
            self.navView.alpha = alpha;
        }];
    }
    else {
        if ([self.delegate respondsToSelector:@selector(photoBrowser:clickAtIndex:contentType:gestureType:)]) {
            [self.delegate photoBrowser:self clickAtIndex:indexPath.row contentType:contentType gestureType:gestureType];
        }
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
    CGFloat i1 = scrollView.contentOffset.x/WZM_SCREEN_WIDTH;
    NSInteger i2 = floor(i1);
    if (i1 == i2) {
        _index = i2;
        self.titleLabel.text = [NSString stringWithFormat:@"%@/%@",@(self.index+1),@(self.images.count)];
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

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    BOOL isLight = YES;
    if (@available(iOS 12.0, *)) {
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            isLight = NO;
        }
    }
    UIImage *image;
    if (isLight) {
        image = [WZMPublic imageWithFolder:@"common" imageName:@"back_black.png"];
    }
    else {
        image = [WZMPublic imageWithFolder:@"common" imageName:@"back_white.png"];
    }
    [self.closeBtn setImage:image forState:UIControlStateNormal];
}

- (BOOL)wzm_navigationShouldDrag {
    return NO;
}

- (BOOL)prefersStatusBarHidden {
    return self.statusHidden;;
}

@end
