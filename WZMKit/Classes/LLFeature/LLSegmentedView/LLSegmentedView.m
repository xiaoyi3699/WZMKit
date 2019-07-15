//
//  LLSegmentedView.m
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2017/12/15.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "LLSegmentedView.h"
#import "UIView+LLAddPart.h"

@interface LLSegmentedView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation LLSegmentedView {
    UIButton *_dropBtn;
    UIVisualEffectView *_dropMenu;
    NSArray *_titleWidths;
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_flowLayout;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
    }
    return self;
}

- (void)createViews {
    _font = [UIFont systemFontOfSize:15];
    _normalColor = [UIColor darkTextColor];
    _selectedColor = [UIColor redColor];
    _lineColor = [UIColor redColor];
    [self refreshTitleWidth];
    
    CGRect rect = self.bounds;
    rect.size.height -= 0.5;
    _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:_flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:_collectionView];
    [_collectionView registerClass:[LLSegmentedCell class] forCellWithReuseIdentifier:@"LLSegmentedCell"];
}

#pragma mark - public method
- (void)setIndex:(NSInteger)index {
    if (_index == index) return;
    _index = index;
    
    [self animationWithIndex:_index];
}

- (void)setTitles:(NSArray *)titles {
    if (titles == nil || titles.count == 0) return;
    if (_titles == titles) return;
    _titles = titles;
    
    _index = 0;
    [self refreshTitleWidth];
    [self animationWithIndex:_index];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGRect rect = self.bounds;
    rect.size.height -= 0.5;
    _collectionView.frame = rect;
}

#pragma mark - private method
- (void)animationWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [_collectionView reloadData];
    [_collectionView scrollToItemAtIndexPath:indexPath
                            atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                    animated:YES];
}

- (void)refreshTitleWidth {
    
    NSInteger totalWidth = 0;
    NSMutableArray *titleWidths = [NSMutableArray arrayWithCapacity:_titles.count];
    for (NSString *title in _titles) {
        NSInteger titleW = (ceil([title sizeWithAttributes:@{NSFontAttributeName:_font}].width)+10);
        [titleWidths addObject:@(titleW)];
        totalWidth += titleW;
    }
    _titleWidths = [titleWidths copy];
    
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    
    if (_titles.count <= 1) {
        _flowLayout.minimumInteritemSpacing = 0;
    }
    else {
        NSInteger tureW = totalWidth + (_titles.count-1)*20 + 20;
        if (tureW < self.bounds.size.width) {
            _flowLayout.minimumInteritemSpacing = (self.bounds.size.width-20-totalWidth)/(_titles.count-1);
        }
        else {
            _flowLayout.minimumInteritemSpacing = 20;
        }
    }
    if (_collectionView) {
        [_collectionView setCollectionViewLayout:_flowLayout];
    }
}

- (void)reloadSbuviews {
    if (self.superview) {
        [_collectionView reloadData];
    }
}

#pragma mark - setter
- (void)setFont:(UIFont *)font {
    if (_font == font) return;
    _font = font;
    [self reloadSbuviews];
}

- (void)setNormalColor:(UIColor *)normalColor {
    if (_normalColor == normalColor) return;
    _normalColor = normalColor;
    [self reloadSbuviews];
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    if (_selectedColor == selectedColor) return;
    _selectedColor = selectedColor;
    [self reloadSbuviews];
}

- (void)setLineColor:(UIColor *)lineColor {
    if (_lineColor == lineColor) return;
    _lineColor = lineColor;
    [self reloadSbuviews];
}

#define mark - UICollectionViewDataSource,UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _titleWidths.count) {
        return CGSizeMake([_titleWidths[indexPath.item] floatValue], collectionView.bounds.size.height);
    }
    return CGSizeMake(0, 0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LLSegmentedCell *cell = (LLSegmentedCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"LLSegmentedCell"
                                                                                         forIndexPath:indexPath];
    if (indexPath.item < _titles.count) {
        NSString *title = _titles[indexPath.item];
        if (self.index == indexPath.item) {
            [cell setConfigWithTitle:title titleColor:_selectedColor titleFont:_font lineColor:_lineColor];
        }
        else {
            [cell setConfigWithTitle:title titleColor:_normalColor titleFont:_font lineColor:[UIColor clearColor]];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == _index) return;
    if ([self.delegate respondsToSelector:@selector(segmentedView:selectedAtIndex:)]) {
        [self.delegate segmentedView:self selectedAtIndex:indexPath.item];
    }
    self.index = indexPath.item;
}

#pragma mark - super method
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) {
        [_collectionView reloadData];
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else {
            newSuperview.viewController.automaticallyAdjustsScrollViewInsets = NO;
        }
#else
        newSuperview.viewController.automaticallyAdjustsScrollViewInsets = NO;
#endif
    }
}

@end
