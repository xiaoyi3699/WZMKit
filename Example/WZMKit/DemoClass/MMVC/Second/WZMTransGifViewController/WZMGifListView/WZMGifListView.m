//
//  WZMGifListView.m
//  ThirdApp
//
//  Created by Zhaomeng Wang on 2020/8/20.
//  Copyright © 2020 富秋. All rights reserved.
//

#import "WZMGifListView.h"
#import "WZMGifListCell.h"

@interface WZMGifListView () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) UISlider *speedSlider;
@end

@implementation WZMGifListView {
    BOOL _isItemShake;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setConfig];
    }
    return self;
}

- (void)setConfig {
    self.backgroundColor = [UIColor whiteColor];
    _isItemShake = NO;
    self.dataList = [[NSMutableArray alloc] initWithCapacity:0];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 15.0, self.bounds.size.width, 20.0)];
    titleLabel.text = @"↓ 长按图片可拖动排序 ↓";
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(60, 60);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    if (@available(iOS 11.0, *)) {
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[WZMGifListCell class] forCellWithReuseIdentifier:@"listCell"];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    if (@available(iOS 9.0, *)) {
        [self addRecognize];
    }
    
    UILabel *speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, 70.0, 30.0)];
    speedLabel.text = @"播放速度";
    speedLabel.textColor = [UIColor grayColor];
    speedLabel.textAlignment = NSTextAlignmentLeft;
    speedLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:speedLabel];
    self.speedLabel = speedLabel;
    
    self.delayTime = 0.3;
    UISlider *speedSlider = [[UISlider alloc] initWithFrame:CGRectMake(80.0, 0.0, 0.0, 30.0)];
    speedSlider.minimumValue = 0.1;
    speedSlider.maximumValue = 1.0;
    speedSlider.minimumTrackTintColor = WZM_THEME_COLOR;
    speedSlider.value = self.delayTime;
    [speedSlider addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [speedSlider addTarget:self action:@selector(touchChange:) forControlEvents:UIControlEventValueChanged];
    [speedSlider addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    [self addSubview:speedSlider];
    self.speedSlider = speedSlider;
}

- (void)layoutSubviews {
    if (self.collectionView.bounds.size.width == 0 && self.bounds.size.width > 0) {
        CGRect rect = self.bounds;
        rect.origin.y += 40.0;
        rect.size.height -= 80.0;
        self.collectionView.frame = rect;
        self.titleLabel.wzm_width = self.bounds.size.width-20.0;
        self.speedLabel.wzm_minY = self.collectionView.wzm_maxY;
        self.speedSlider.frame = CGRectMake(80.0, self.speedLabel.wzm_minY, self.bounds.size.width-90.0, 30.0);
    }
}

- (void)reloadWithImages:(NSArray *)images {
    self.dataList = images.mutableCopy;
    [self.collectionView reloadData];
}

//进度条滑动开始
- (void)touchDown:(UISlider *)slider {
}

//进度条滑动
- (void)touchChange:(UISlider *)slider {
    
}

//进度条滑动结束
- (void)touchUp:(UISlider *)slider {
    self.delayTime = slider.value;
    if ([self.delegate respondsToSelector:@selector(gifListViewDidChange:)]) {
        [self.delegate gifListViewDidChange:self];
    }
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WZMGifListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"listCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    if (indexPath.row < self.dataList.count) {
        [cell setConfig:[self.dataList objectAtIndex:indexPath.row]];
    }
    if (_isItemShake) {
        // 调用cell开始抖动方法
        [cell beginShake];
        
    }else{
        // 调用cell停止抖动方法
        [cell stopShake];
        
    }
    return cell;
}

//手势处理
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    //删除数据源中初始位置的数据
    UIImage *image = [self.dataList objectAtIndex:sourceIndexPath.row];
    [self.dataList removeObject:image];
    //将数据插入数据源中新的位置，实现数据源的更新
    [self.dataList insertObject:image atIndex:destinationIndexPath.row];
    
    NSArray *cellArray = [self.collectionView visibleCells];
    for (WZMGifListCell *cell in cellArray ) {
        [cell stopShake];
    }
    
    WZMDispatch_after(0.5, ^{
        [collectionView reloadData];
        [self reloadWithImages:self.dataList];
        if ([self.delegate respondsToSelector:@selector(gifListViewDidChange:)]) {
            [self.delegate gifListViewDidChange:self];
        }
    });
}

//长按拖动
- (void)addRecognize {
    UILongPressGestureRecognizer *recognize = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    //设置长按响应时间为0.5秒
    recognize.minimumPressDuration = 0.5;
    [self.collectionView addGestureRecognizer:recognize];
}

// 长按抖动手势方法
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
            _isItemShake = YES;
            NSArray *cellArray = [self.collectionView visibleCells];
            for (WZMGifListCell *cell in cellArray ) {
                [cell beginShake];
            }
            // 通过手势获取点，通过点获取点击的indexPath， 移动该cell
            NSIndexPath *aIndexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:aIndexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            // 通过手势获取点，通过点获取拖动到的indexPath， 更新该cell位置
            [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectionView]];
        }
            break;
        case UIGestureRecognizerStateEnded:{
            // 移动完成关闭cell移动
            [self.collectionView endInteractiveMovement];
            // collectionView停止抖动
            _isItemShake = NO;
            NSArray *cellArray = [self.collectionView visibleCells];
            for (WZMGifListCell *cell in cellArray ) {
                // 调用cell停止抖动方法
                [cell stopShake];
            }
        }
            break;
        default:
            [self.collectionView endInteractiveMovement];
            _isItemShake = NO;
            NSArray *cellArray = [self.collectionView visibleCells];
            for (WZMGifListCell *cell in cellArray ) {
                [cell stopShake];
            }
            break;
    }
}

@end
