//
//  WZMSegmentedViewController.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/5/27.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "WZMSegmentedViewController.h"
#import "WZMSubViewController.h"

@interface WZMSegmentedViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WZMScrollImageViewDelegage>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) WZMSegmentedView *segmentedView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray<WZMSubViewController *> *viewControllers;

@end

@implementation WZMSegmentedViewController {
    BOOL _dragging;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //头部悬浮视图
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, WZM_SCREEN_WIDTH, WZM_NAVBAR_HEIGHT+200.0)];
    self.headerView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.headerView];
    //列表子视图
    self.viewControllers = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 3; i ++) {
        WZMSubViewController *subVC = [[WZMSubViewController alloc] init];
        subVC.superViewController = self;
        [self.viewControllers addObject:subVC];
    }
    //分区视图
    self.collectionView.bounces = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    [self.view insertSubview:self.collectionView belowSubview:self.headerView];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    UIView *view = [cell viewWithTag:99];
    if (view != nil) {
        [view removeFromSuperview];
    }
    if (indexPath.row < self.viewControllers.count) {
        WZMSubViewController *vc = [self.viewControllers objectAtIndex:indexPath.row];
        vc.frame = [self collectionViewFrame];
        [cell addSubview:vc.view];
        vc.view.tag = 99;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_dragging == NO) return;
    CGFloat dindex = scrollView.contentOffset.x/scrollView.wzm_width;
    NSInteger index = (NSInteger)dindex;
    if (dindex - index == 0.0) {
        self.segmentedView.index = index;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _dragging = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_dragging == NO) return;
    // 停止类型1、停止类型2
    BOOL stop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (stop) {
        [self scrollViewDidEndScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_dragging == NO) return;
    if (!decelerate) {
        // 停止类型3
        BOOL stop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (stop) {
            [self scrollViewDidEndScroll];
        }
    }
}

- (void)scrollViewDidEndScroll {
    _dragging = NO;
}

#pragma mark - setter/getter
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:[self collectionViewFrame] collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
#else
        self.automaticallyAdjustsScrollViewInsets = NO;
#endif
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = [self collectionViewFrame].size;
    flowLayout.minimumInteritemSpacing = 0.0;
    flowLayout.minimumLineSpacing = 0.0;
    return flowLayout;
}

- (CGRect)collectionViewFrame {
    return self.view.bounds;
}

- (BOOL)navigatonBarIsHidden {
    return YES;
}

@end
