//
//  WZMGifListCell.m
//  ThirdApp
//
//  Created by Zhaomeng Wang on 2020/8/20.
//  Copyright © 2020 富秋. All rights reserved.
//

#import "WZMGifListCell.h"
#import "WZMGifHelper.h"

@implementation WZMGifListCell {
    UIImageView *_imageView;
    CAKeyframeAnimation *_anim;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.wzm_cornerRadius = 2.0;
        _imageView.wzm_borderWidth = 0.5;
        _imageView.wzm_borderColor = WZM_THEME_COLOR;
        [self addSubview:_imageView];
        
        _anim = [CAKeyframeAnimation animation];
        _anim.keyPath = @"transform.rotation";
        _anim.duration = 0.2;
        _anim.repeatCount = MAXFLOAT;
        _anim.values = @[@(-0.06),@(0.06),@(-0.06)];
        _anim.removedOnCompletion = NO;
        _anim.fillMode = kCAFillModeForwards;
    }
    return self;
}

- (void)setConfig:(id)image {
    _imageView.image = [WZMGifHelper getImage:image];
}

- (void)beginShake {
    [self.layer addAnimation:_anim forKey:@"shake"];
}

- (void)stopShake {
    [self.layer removeAllAnimations];
}

@end
