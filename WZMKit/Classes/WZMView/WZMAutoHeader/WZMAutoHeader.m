//
//  WZMAutoHeader.m
//  WZMKit
//
//  Created by WangZhaomeng on 2017/10/17.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMAutoHeader.h"

#define WZM_AUTO_CONTENT_OFF_SET @"contentOffset"
@implementation WZMAutoHeader {
    UIImageView  *_imageView;
    UIScrollView *_scrollView;
}

- (void)setImage:(UIImage *)image {
    if (_image == image) return;
    _image = image;
    if (_imageView) {
        _imageView.image = image;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        _scrollView = (UIScrollView *)newSuperview;
        _scrollView.alwaysBounceVertical = YES;
        
        if (_imageView == nil) {
            _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [self insertSubview:_imageView atIndex:0];
        }
        if (self.image) {
            _imageView.image = self.image;
        }
        [_scrollView addObserver:self forKeyPath:WZM_AUTO_CONTENT_OFF_SET options:NSKeyValueObservingOptionNew context:nil];
    }
    
    [super willMoveToSuperview:newSuperview];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.hidden) return;
    if (self.headerAnimation == WZMAutoHeaderAnimationNone) return;
    
    if ([keyPath isEqualToString:WZM_AUTO_CONTENT_OFF_SET]) {
        
        CGFloat y = _scrollView.contentOffset.y;
        
        if (y <= 0) {
            CGFloat oldH = self.bounds.size.height;
            CGFloat newH = oldH - y;
            CGFloat scale = newH/oldH;
            
            CGFloat oldW = self.bounds.size.width;
            CGFloat newW = oldW * scale;
            
            if (self.headerAnimation == WZMAutoHeaderAnimationScale) {
                _imageView.frame = CGRectMake((oldW-newW)/2.0, y, newW, newH);
            }
            else {
                _imageView.frame = CGRectMake(0, y, oldW, newH);
            }
        }
    }
}

- (void)removeFromSuperview {
    if ([_scrollView isKindOfClass:[UIScrollView class]]) {
        [_scrollView removeObserver:self forKeyPath:WZM_AUTO_CONTENT_OFF_SET];
        _scrollView = nil;
    }
    [super removeFromSuperview];
}

@end
