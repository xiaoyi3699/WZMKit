//
//  WZMScreenShotView.m
//  LLFoundation
//
//  Created by Mr.Wang on 16/12/9.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMScreenShotView.h"

@implementation WZMScreenShotView

- (id)init{
    self = [super init];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor blackColor];
        [self addSubview:_maskView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = _maskView.frame = self.bounds;
}

@end
