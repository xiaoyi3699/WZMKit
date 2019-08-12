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
///是否显示GIF, 默认NO
@property (nonatomic, assign) BOOL allowShowGIF;
///是否显示图片, 默认YES
@property (nonatomic, assign) BOOL allowShowImage;
///是否显示视频, 默认YES
@property (nonatomic, assign) BOOL allowShowVideo;

///所有图片
@property (nonatomic, readonly, strong) NSMutableArray<WZMAlbumModel *> *allPhotos;
///选中的图片
@property (nonatomic, readonly, strong) NSMutableArray<WZMAlbumModel *> *selectedPhotos;

@end
