//
//  WZMAudioRecorder.h
//  WZMKit
//
//  Created by WangZhaomeng on 2017/11/10.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WZMAudioRecorderDelegate;

@interface WZMAudioRecorder : NSObject

///必须以.caf结尾, 设置为"0"则使用默认路径
@property (nonatomic, strong) NSString *toPath;
@property (nonatomic, weak) id<WZMAudioRecorderDelegate> delegate;

///开始录音
- (void)startRecord;
///结束录音
- (void)stopRecord:(void(^)(NSString *toPath,NSInteger time))completion;

@end

@protocol WZMAudioRecorderDelegate <NSObject>

@optional
- (void)audioRecorderr:(WZMAudioRecorder *)audioRecorderr didChangeVolume:(CGFloat)volume;

@end
