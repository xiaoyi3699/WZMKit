//
//  WZMPhotoBrowser.h
//  WZMKit
//
//  Created by WangZhaomeng on 2017/12/13.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMEnum.h"

@protocol WZMPhotoBrowserDelegate;

@interface WZMPhotoBrowser : UIViewController

@property (nonatomic, weak) id<WZMPhotoBrowserDelegate> delegate;

/*
 images内的元素,可以是视频、GIF、图片
 视频: 网址、路径
 GIF: 网址、路径、NSData
 图片: 网址、路径、NSData、UIImage
 */
@property (nonatomic, strong) NSArray *images;
///图片索引
@property (nonatomic, assign) NSInteger index;

- (void)showFromController:(UIViewController *)controller;
- (void)dismiss;

@end

@protocol WZMPhotoBrowserDelegate <NSObject>

@optional
- (void)photoBrowser:(WZMPhotoBrowser *)photoBrowser
        clickAtIndex:(NSInteger)index
         contentType:(WZMAlbumPhotoType)contentType
         gestureType: (WZMGestureRecognizerType)gestureType;


@end
