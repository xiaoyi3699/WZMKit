//
//  WZMAlbumView.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMAlbumModel.h"

@interface WZMAlbumView : UIView

///列数, 默认4, 最大5
@property (nonatomic, assign) NSInteger column;
///是否允许预览
@property (nonatomic, assign) BOOL allowPreview;
///是否允许选择图片
@property (nonatomic, assign) BOOL allowPickingImage;
///是否允许选择视频
@property (nonatomic, assign) BOOL allowPickingVideo;

///所有图片
@property (nonatomic, readonly, strong) NSMutableArray<WZMAlbumModel *> *allPhotos;
///选中的图片
@property (nonatomic, readonly, strong) NSMutableArray<WZMAlbumModel *> *selectedPhotos;

@end
