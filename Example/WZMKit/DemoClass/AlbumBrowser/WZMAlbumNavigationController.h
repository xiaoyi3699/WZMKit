//
//  WZMAlbumNavigationController.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/12.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WZMAlbumNavigationControllerDelegate;

@interface WZMAlbumNavigationController : UINavigationController

///列数, 默认4, 最大5
@property (nonatomic, assign) NSInteger column;
///点击确定时是否自动消失
@property (nonatomic, assign) BOOL autoDismiss;
///是否允许预览<暂时无效>
@property (nonatomic, assign) BOOL allowPreview;
///是否显示GIF, 默认NO
@property (nonatomic, assign) BOOL allowShowGIF;
///是否允许选择图片
@property (nonatomic, assign) BOOL allowShowImage;
///是否允许选择视频
@property (nonatomic, assign) BOOL allowShowVideo;
///代理
@property (nonatomic, weak) id<WZMAlbumNavigationControllerDelegate> pickerDelegate;

@end

@protocol WZMAlbumNavigationControllerDelegate <NSObject>

@optional
- (void)albumNavigationController:(WZMAlbumNavigationController *)albumNavigationController didSelectedPhotos:(NSArray *)photos;

@end
