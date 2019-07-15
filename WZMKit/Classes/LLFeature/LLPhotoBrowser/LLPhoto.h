//
//  LLPhoto.h
//  LLPhotoBrowser
//
//  Created by zhaomengWang on 17/2/6.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLEnum.h"

@protocol LLPhotoDelegate;

@interface LLPhoto : UIScrollView

///当前显示的图片
@property (nonatomic, strong) id ll_image;

///设置占位图
@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, weak)   id<LLPhotoDelegate> ll_delegate;

- (void)startGif;
- (void)stopGif;

@end

@protocol LLPhotoDelegate <NSObject>

@optional
- (void)clickAtPhoto:(LLPhoto *)photo content:(id)content isGif:(BOOL)isGif type:(LLGestureRecognizerType)type;

@end
