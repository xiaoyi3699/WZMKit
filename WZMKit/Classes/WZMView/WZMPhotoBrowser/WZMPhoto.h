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

/*
 当前显示的视频、GIF、图片
 视频: 网址、路径
 GIF: 网址、路径、NSData
 图片: 网址、路径、NSData、UIImage
 */
@property (nonatomic, strong) id wzm_image;

///设置占位图
@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, weak)   id<WZMPhotoDelegate> wzm_delegate;

- (void)start;
- (void)stop;

@end

@protocol WZMPhotoDelegate <NSObject>

@optional
- (void)clickAtPhoto:(WZMPhoto *)photo
         contentType:(WZMAlbumPhotoType)contentType
         gestureType:(WZMGestureRecognizerType)gestureType;

@end
