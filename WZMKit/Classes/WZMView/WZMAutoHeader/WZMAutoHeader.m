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
    BOOL _addObserver;
    UIImageView *_imageView;
    UIScrollView *_scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _addObserver = NO;
        self.imageFrame = CGRectZero;
        
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        [self removeObserver];
        _scrollView = (UIScrollView *)newSuperview;
        _scrollView.alwaysBounceVertical = YES;
        [self addObserver];
        
        if (CGRectEqualToRect(CGRectZero, self.imageFrame)) {
            self.imageFrame = self.bounds;
        }
        _imageView.frame = self.imageFrame;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (self.hidden) return;
    if (self.animation == WZMAutoHeaderAnimationNone) return;
    if ([keyPath isEqualToString:WZM_AUTO_CONTENT_OFF_SET]) {
        CGFloat y = _scrollView.contentOffset.y;
        if (y <= 0) {
            CGFloat oldH = self.imageFrame.size.height;
            CGFloat newH = oldH - y;
            CGFloat scale = newH/oldH;
            CGFloat oldW = self.imageFrame.size.width;
            CGFloat newW = oldW * scale;
            if (self.animation == WZMAutoHeaderAnimationScale) {
                _imageView.frame = CGRectMake(self.imageFrame.origin.x+(oldW-newW)/2.0, self.imageFrame.origin.y+y, newW, newH);
            }
            else {
                _imageView.frame = CGRectMake(self.imageFrame.origin.x, self.imageFrame.origin.y+y, oldW, newH);
            }
        }
    }
}

- (void)setImage:(UIImage *)image {
    if (_imageView) {
        _imageView.image = image;
    }
    _image = image;
}

- (void)addObserver {
    if (_addObserver) return;
    _addObserver = YES;
    [_scrollView addObserver:self forKeyPath:WZM_AUTO_CONTENT_OFF_SET options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver {
    if (_addObserver == NO) return;
    _addObserver = NO;
    [_scrollView removeObserver:self forKeyPath:WZM_AUTO_CONTENT_OFF_SET];
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self removeObserver];
}

@end
