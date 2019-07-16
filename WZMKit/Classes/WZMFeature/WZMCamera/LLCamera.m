//
//  LLCamera.m
//  LLFeature
//
//  Created by WangZhaomeng on 2017/10/12.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "LLCamera.h"
#import "LLLog.h"
#import <AVFoundation/AVFoundation.h>

@interface LLCamera (){
    AVCaptureSession *_captureSession;
    AVCaptureVideoPreviewLayer *_videoPreviewLayer;
}
@end

@implementation LLCamera

- (instancetype)initWithPosition:(LLCaptureDevicePosition)position {
    self = [super init];
    if (self) {
        
        if (position == LLCaptureDevicePositionBack) {
            if ([self isBackCameraAvailable] == NO) {
                ll_log(@"后摄像头不可用");
                return self;
            }
        }
        else if (position == LLCaptureDevicePositionFront) {
            if ([self isFrontCameraAvailable] == NO) {
                ll_log(@"前摄像头不可用");
                return self;
            }
        }
        else {
            if ([self isCameraAvailable] == NO) {
                ll_log(@"摄像头不可用");
                return self;
            }
        }
        
        NSError *error;
        AVCaptureDevice *camera = [self cameraWithPosition:(AVCaptureDevicePosition)position];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:camera error:&error];
        if (error) {
            ll_log(@"%@",[error localizedDescription]);
        }
        else {
            if (_captureSession == nil) {
                _captureSession = [[AVCaptureSession alloc] init];
                [_captureSession beginConfiguration];
                [_captureSession addInput:input];
                [_captureSession commitConfiguration];
                
                _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
                [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            }
        }
    }
    return self;
}

//开始
- (void)startInView:(UIView *)view {
    [_videoPreviewLayer setFrame:view.bounds];
    [view.layer addSublayer:_videoPreviewLayer];
    [_captureSession startRunning];
}

//结束
- (void)stop {
    [_videoPreviewLayer removeFromSuperlayer];
    [_captureSession stopRunning];
}

//切换前后摄像头
- (void)swapFrontAndBackCameras {
    if (![self hasMultipleCameras]) return;
    NSArray *inputs = _captureSession.inputs;
    for (AVCaptureDeviceInput *captureDeviceInput in inputs) {
        AVCaptureDevice *device = captureDeviceInput.device ;
        if ([device hasMediaType:AVMediaTypeVideo]) {
            AVCaptureDevicePosition position = device.position ;
            AVCaptureDevice *newCamera = nil ;
            AVCaptureDeviceInput *newInput = nil ;
            if (position == AVCaptureDevicePositionFront)
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            else
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            [_captureSession beginConfiguration];
            [_captureSession removeInput:captureDeviceInput];
            [_captureSession addInput:newInput];
            [_captureSession commitConfiguration];
            break ;
        }
    }
}

#pragma mark - private method
//判断设备是否有摄像头
- (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

//前面的摄像头是否可用
- (BOOL)isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

//后面的摄像头是否可用
- (BOOL)isBackCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

//是否可切换前后摄像头
- (BOOL)hasMultipleCameras {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    if (devices != nil && [devices count] > 1) return YES;
    return NO;
}

//获取前/后摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices )
        if (device.position == position)
            return device;
    return nil ;
}

@end
