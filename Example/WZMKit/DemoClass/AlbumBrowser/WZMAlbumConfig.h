//
//  WZMAlbumConfig.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/13.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZMAlbumConfig : NSObject

///列数, 默认4, 最大5
@property (nonatomic, assign) NSInteger column;
///点击确定时是否自动消失
@property (nonatomic, assign) BOOL autoDismiss;
///是否允许预览
@property (nonatomic, assign) BOOL allowPreview;
///是否显示GIF, 默认NO
@property (nonatomic, assign) BOOL allowShowGIF;
///是否允许选择图片
@property (nonatomic, assign) BOOL allowShowImage;
///是否允许选择视频
@property (nonatomic, assign) BOOL allowShowVideo;
///最小选中数量, 默认0
@property (nonatomic, assign) NSInteger minCount;
///最大选中数量, 默认9
@property (nonatomic, assign) NSInteger maxCount;

@end
