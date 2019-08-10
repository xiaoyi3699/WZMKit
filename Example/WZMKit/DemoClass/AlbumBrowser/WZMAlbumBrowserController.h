//
//  WZMAlbumBrowserController.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMAlbumPhotoModel.h"
@protocol WZMAlbumBrowserControllerDelegate;

@interface WZMAlbumBrowserController : UIViewController

///相册视图在屏幕中的frame, 默认全屏
@property (nonatomic, assign) CGRect albumFrame;
///列数, 默认4, 最大5
@property (nonatomic, assign) NSInteger column;
///是否允许选择图片
@property (nonatomic, assign) BOOL allowPickingImage;
///是否允许选择视频
@property (nonatomic, assign) BOOL allowPickingVideo;
///设置已选中的图片
@property (nonatomic, strong) NSArray<WZMAlbumPhotoModel *> *selectedPhotos;
///代理
@property (nonatomic, weak) id<WZMAlbumBrowserControllerDelegate> delegate;

@end

@protocol WZMAlbumBrowserControllerDelegate <NSObject>

@optional
- (void)albumBrowser:(WZMAlbumBrowserController *)albumBrowser didSelectedPhotos:(NSArray<WZMAlbumPhotoModel *> *)photos;

@end
