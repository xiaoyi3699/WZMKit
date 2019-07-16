//
//  WZMPhoto.h
//  WZMPhotoBrowser
//
//  Created by zhaomengWang on 17/2/6.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMEnum.h"

@protocol WZMPhotoDelegate;

@interface WZMPhoto : UIScrollView

///当前显示的图片
@property (nonatomic, strong) id wzm_image;

///设置占位图
@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, weak)   id<WZMPhotoDelegate> wzm_delegate;

- (void)startGif;
- (void)stopGif;

@end

@protocol WZMPhotoDelegate <NSObject>

@optional
- (void)clickAtPhoto:(WZMPhoto *)photo content:(id)content isGif:(BOOL)isGif type: (WZMGestureRecognizerType)type;

@end
