//
//  WZMAlbumController.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/12.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMAlbumModel.h"
@protocol WZMAlbumControllerDelegate;

@interface WZMAlbumController : UIViewController

///列数, 默认4, 最大5
@property (nonatomic, assign) NSInteger column;
///点击确定时是否自动消失
@property (nonatomic, assign) BOOL autoDismiss;
///是否允许预览
@property (nonatomic, assign) BOOL allowPreview;
///是否允许选择图片
@property (nonatomic, assign) BOOL allowPickingImage;
///是否允许选择视频
@property (nonatomic, assign) BOOL allowPickingVideo;
///代理
@property (nonatomic, weak) id<WZMAlbumControllerDelegate> pickerDelegate;

@end

@protocol WZMAlbumControllerDelegate <NSObject>

@optional
- (void)albumPicker:(WZMAlbumController *)albumPicker didSelectedPhotos:(NSArray<WZMAlbumModel *> *)photos;

@end
