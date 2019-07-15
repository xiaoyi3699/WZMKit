//
//  LLScrollImageView.m
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2017/12/12.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "LLScrollImageView.h"
#import "UIView+LLAddPart.h"

@interface LLScrollImageView ()<UIScrollViewDelegate>

@end

@implementation LLScrollImageView {
    NSArray<UIImage *> *_images;
    UIScrollView       *_scrollView;
    UIPageControl      *_pageControl;
    NSArray            *_imageViews;
    NSTimer            *_timer;
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray<UIImage *> *)images {
    self = [super initWithFrame:frame];
    if (self) {
        
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:(images.count+2)];
        [temp addObject:images.lastObject];
        [temp addObjectsFromArray:images];
        [temp addObject:images.firstObject];
        _images = [temp copy];
        
        NSInteger num = _images.count;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(num*self.LLWidth, self.LLHeight);
        [self addSubview:_scrollView];
        
        CGFloat pageControlH = self.LLHeight/4;
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,
                                                                       self.LLHeight-pageControlH,
                                                                       self.LLWidth,
                                                                       pageControlH)];
        _pageControl.numberOfPages = images.count;
        _pageControl.userInteractionEnabled = NO;
        //[_pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageControl];
        
        NSMutableArray *imageViews = [NSMutableArray arrayWithCapacity:num];
        for (NSInteger i = 0; i < num; i ++) {
            
            CGRect rect = _scrollView.bounds;
            rect.origin.x = i%num*_scrollView.LLWidth;
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
            imageView.tag = i;
            imageView.image = _images[i];
            imageView.userInteractionEnabled = YES;
            [_scrollView addSubview:imageView];
            
            if ((i !=0) && (i != num-1)) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
                [imageView addGestureRecognizer:tap];
            }
            
            [imageViews addObject:imageView];
        }
        _imageViews = [imageViews copy];
        
        _scrollView.contentOffset = CGPointMake(_scrollView.LLWidth, 0);
    }
    return self;
}

#pragma mark - 交互事件 && 代理事件
- (void)tapHandle:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(scrollImageView:didSelectedAtIndex:)]) {
        [self.delegate scrollImageView:self didSelectedAtIndex:(tap.view.tag-1)];
    }
}

//- (void)pageControlValueChanged:(UIPageControl *)pageControl {
//    _currentPage = pageControl.currentPage;
//    CGPoint point = CGPointMake((_currentPage+1)*_scrollView.LLWidth, 0);
//    [_scrollView setContentOffset:point animated:YES];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX <= 0) {
        _currentPage = 0;
        scrollView.contentOffset = CGPointMake(scrollView.LLWidth*(_images.count-2), 0);
    }
    else if (offsetX >= scrollView.LLWidth*(_images.count-1)) {
        _currentPage = _images.count-3;
        scrollView.contentOffset = CGPointMake(scrollView.LLWidth, 0);
    }
    else {
        _currentPage = scrollView.contentOffset.x/scrollView.LLWidth-1;
    }
    [_pageControl setCurrentPage:_currentPage];
}

#pragma mark - setter && getter
- (void)setImageViewInset:(UIEdgeInsets)imageViewInset {
    if (UIEdgeInsetsEqualToEdgeInsets(_imageViewInset, imageViewInset)) return;
    
    CGFloat top    = (imageViewInset.top    > 0 ? imageViewInset.top    : 0);
    CGFloat left   = (imageViewInset.left   > 0 ? imageViewInset.left   : 0);
    CGFloat bottom = (imageViewInset.bottom > 0 ? imageViewInset.bottom : 0);
    CGFloat right  = (imageViewInset.right  > 0 ? imageViewInset.right  : 0);
    
    for (UIImageView *imageView in _imageViews) {
        CGRect rect = imageView.frame;
        rect.origin.x += left;
        rect.origin.y += top;
        rect.size.width  -= (left+right);
        rect.size.height -= (top+bottom);
        imageView.frame = rect;
    }
    _imageViewInset = imageViewInset;
}

- (void)setShowPageControl:(BOOL)showPageControl {
    if (_showPageControl == showPageControl) return;
    _showPageControl = showPageControl;
    _pageControl.hidden = !showPageControl;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    if (_pageIndicatorTintColor == pageIndicatorTintColor) return;
    _pageIndicatorTintColor = pageIndicatorTintColor;
    _pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    if (_currentPageIndicatorTintColor == currentPageIndicatorTintColor) return;
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    _pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (void)setCurrentPage:(NSInteger)currentPage {
    if (currentPage < 0 || currentPage > _images.count-3) return;
    if (_currentPage == currentPage) return;
    _currentPage = currentPage;
    _pageControl.currentPage = currentPage;
    
    CGPoint point = CGPointMake((currentPage+1)*_scrollView.LLWidth, 0);
    [_scrollView setContentOffset:point animated:YES];
}

- (void)setAutoScroll:(BOOL)autoScroll {
    if (_autoScroll == autoScroll) return;
    autoScroll ? [self timerFire] : [self timerInvalidate];
    _autoScroll = autoScroll;
}

#pragma mark - private method
- (void)timerFire {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
    }
}

- (void)timerInvalidate {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)timerRun:(NSTimer *)timer {
    NSInteger index = ((_currentPage+1)+1)%_images.count;
    CGPoint point = CGPointMake(index*_scrollView.LLWidth, 0);
    [_scrollView setContentOffset:point animated:YES];
}

#pragma mark - super method
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) {
        [self timerInvalidate];
        [self timerFire];
    }
}

- (void)removeFromSuperview {
    [self timerInvalidate];
    [super removeFromSuperview];
}

@end
