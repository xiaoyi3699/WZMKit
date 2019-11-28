//
//  WZMVideoEditView.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/11/28.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZMVideoEditView : UIView

///视频路径
@property (nonatomic, strong) NSURL *videoUrl;
///视频渲染frame,添加水印、文字等均以此frame为准
@property (nonatomic, readonly ,assign) CGRect videoFrame;

///添加水印
- (void)addWatermark:(UIView *)markView;
///导出视频
- (void)exportVideoCompletion:(void(^)(NSURL *exportURL))completion;

@end
