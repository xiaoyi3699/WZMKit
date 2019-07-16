//
//  WZMCamera.h
//  WZMKit
//
//  Created by WangZhaomeng on 2017/10/12.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMEnum.h"

@interface WZMCamera : NSObject

- (instancetype)initWithPosition: (WZMCaptureDevicePosition)position;

//开始
- (void)startInView:(UIView *)view;

//结束
- (void)stop;

//切换前后摄像头
- (void)swapFrontAndBackCameras;

@end
