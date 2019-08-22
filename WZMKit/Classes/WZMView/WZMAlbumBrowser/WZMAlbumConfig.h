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
///是否自动消失
@property (nonatomic, assign) BOOL autoDismiss;
///是否允许预览
@property (nonatomic, assign) BOOL allowPreview;
///选中图片时, 是否显示索引, 默认YES
@property (nonatomic, assign) BOOL allowShowIndex;
///是否显示GIF, 默认NO
@property (nonatomic, assign) BOOL allowShowGIF;
///是否允许选择图片, 默认YES
@property (nonatomic, assign) BOOL allowShowImage;
///是否允许选择视频, 默认YES
@property (nonatomic, assign) BOOL allowShowVideo;
///最小选中数量, 默认0
@property (nonatomic, assign) NSInteger minCount;
///最大选中数量, 默认9
@property (nonatomic, assign) NSInteger maxCount;

///是否导出原图, 默认YES
@property (nonatomic, assign) BOOL originalImage;
///导出的最大尺寸(像素), 默认600x600, 非原图时生效
@property (nonatomic, assign) NSInteger imagePreset;

///是否是源视频(源视频路径为虚拟镜像路径), 默认YES
@property (nonatomic, assign) BOOL originalVideo;
///导出的视频存储路径, 非源视频时生效
@property (nonatomic, assign) NSString *videoPath;
/*
 导出的视频尺寸, 非源视频时生效, 默认AVAssetExportPreset640x480
 参数设置:
 AVAssetExportPreset1920x1080,
 AVAssetExportPresetLowQuality,
 AVAssetExportPresetAppleM4A,
 AVAssetExportPresetHEVCHighestQuality,
 AVAssetExportPreset640x480,
 AVAssetExportPreset3840x2160,
 AVAssetExportPresetHEVC3840x2160,
 AVAssetExportPresetHighestQuality,
 AVAssetExportPresetMediumQuality,
 AVAssetExportPreset1280x720,
 AVAssetExportPreset960x540,
 AVAssetExportPresetHEVC1920x1080
 */
@property (nonatomic, assign) NSString *videoPreset;

@end