//
//  UIButton+WZMHelper.m
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2017/12/13.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "UIButton+WZMHelper.h"
#import "Aspects.h"

@implementation UIButton (WZMHelper)

- (void)setImageFrame:(CGRect)imageFrame titleFrame:(CGRect)titieFrame {
    [self aspect_hookSelector:@selector(layoutSubviews) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info){
        if (CGRectIsNull(imageFrame) == NO) {
            self.imageView.frame = imageFrame;
        }
        
        if (CGRectIsNull(titieFrame) == NO) {
            self.titleLabel.frame = titieFrame;
        }
        
    } error:nil];
}

@end
