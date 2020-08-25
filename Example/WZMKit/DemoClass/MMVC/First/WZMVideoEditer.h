//
//  WZMVideoEditer.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/8/24.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@protocol WZMVideoEditerDelegate;

@interface WZMVideoEditer : NSObject

#pragma mark - 原视频
@property (nonatomic, assign) CGFloat volume;
@property (nonatomic, assign) CGFloat start;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGRect cropFrame;

#pragma mark - 配音
@property (nonatomic, assign) CGFloat volume2;
@property (nonatomic, assign, getter=isLoop2) BOOL loop2;

#pragma mark - other
@property (nonatomic, assign, readonly) CGFloat progress;
@property (nonatomic, strong, readonly) NSString *exportPath;
@property (nonatomic, weak) id<WZMVideoEditerDelegate> delegate;
@property (nonatomic, assign, readonly ,getter=isExporting) BOOL exporting;

#pragma mark - 视频处理
///视频时长、尺寸剪裁
- (void)handleVideoWithPath:(NSString *)path;
///视频时长、尺寸剪裁，并添加配音
- (void)handleVideoWithPath:(NSString *)path otherPath:(NSString *)path2;

@end

@protocol WZMVideoEditerDelegate <NSObject>

@optional
- (void)videoEditerExporting:(WZMVideoEditer *)videoEditer;
- (void)videoEditerDidExported:(WZMVideoEditer *)videoEditer;
- (void)videoEditer:(WZMVideoEditer *)videoEditer renderLayerWithComposition:(AVMutableVideoComposition *)composition;

@end
