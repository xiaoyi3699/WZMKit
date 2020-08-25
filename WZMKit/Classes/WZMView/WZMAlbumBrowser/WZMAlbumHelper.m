//
//  WZMAlbumHelper.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMAlbumHelper.h"
#import <Photos/Photos.h>
#import <ImageIO/ImageIO.h>
#import "WZMMacro.h"
#import "WZMFileManager.h"
#import "WZMLogPrinter.h"
#import "WZMDefined.h"
#import "NSDateFormatter+wzmcate.h"

#if WZM_APP
@interface WZMAlbumHelper ()<UIAlertViewDelegate>
#else
@interface WZMAlbumHelper ()
#endif

@property (nonatomic, assign) CGFloat screenScale;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, strong) NSString *videoFolder;
@property (nonatomic, assign, getter=isShowAlert) BOOL showAlert;
@property (nonatomic, strong) PHImageRequestOptions *imageOptions;
@property (nonatomic, strong) PHVideoRequestOptions *videoOptions;

@property (nonatomic, strong) PHImageRequestOptions *iCloudImageOptions;
@property (nonatomic, strong) PHVideoRequestOptions *iCloudVideoOptions;

@end

@implementation WZMAlbumHelper

+ (instancetype)shareHelper {
    static WZMAlbumHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[WZMAlbumHelper alloc] init];
        helper.showAlert = NO;
    });
    return helper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.screenScale = 2.0;
        self.screenWidth = [UIScreen mainScreen].bounds.size.width;
        if (self.screenWidth > 700) {
            self.screenScale = 1.5;
        }
        self.imageOptions = [[PHImageRequestOptions alloc] init];
        self.imageOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
        self.imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        self.videoOptions = [[PHVideoRequestOptions alloc] init];
        self.videoOptions.version = PHVideoRequestOptionsVersionOriginal;
        self.videoOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        
        self.iCloudImageOptions = [[PHImageRequestOptions alloc] init];
        self.iCloudImageOptions.networkAccessAllowed = YES;
        self.iCloudImageOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
        self.iCloudImageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        self.iCloudVideoOptions = [[PHVideoRequestOptions alloc] init];
        self.iCloudVideoOptions.networkAccessAllowed = YES;
        self.iCloudVideoOptions.version = PHVideoRequestOptionsVersionOriginal;
        self.iCloudVideoOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        
        self.videoFolder = [WZM_CACHE_PATH stringByAppendingPathComponent:@"WZMAlbum"];
        [WZMFileManager createDirectoryAtPath:self.videoFolder];
    }
    return self;
}

//文件格式
+ (WZMAlbumPhotoType)wzm_getAssetType:(id)asset {
    WZMAlbumPhotoType type = WZMAlbumPhotoTypePhoto;
    PHAsset *phAsset = (PHAsset *)asset;
    if (phAsset.mediaType == PHAssetMediaTypeVideo)      type = WZMAlbumPhotoTypeVideo;
    else if (phAsset.mediaType == PHAssetMediaTypeAudio) type = WZMAlbumPhotoTypeAudio;
    else if (phAsset.mediaType == PHAssetMediaTypeImage) {
//        if (@available(iOS 9.1, *)) {
//            if (phAsset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) type = WZMAlbumPhotoTypeLivePhoto;
//        }
        if ([[phAsset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
            type = WZMAlbumPhotoTypePhotoGif;
        }
    }
    return type;
}

//获取缩略图
+ (int32_t)wzm_getThumbnailWithAsset:(id)asset photoWidth:(CGFloat)photoWidth thumbnail:(void(^)(UIImage *photo))thumbnail cloud:(void(^)(BOOL iCloud))cloud {
    PHAsset *phAsset = (PHAsset *)asset;
    CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
    CGFloat pixelWidth = photoWidth * WZM_SCREEN_SCALE;
    //超宽图片
    if (aspectRatio > 1.8) {
        pixelWidth = pixelWidth * aspectRatio;
    }
    //超高图片
    if (aspectRatio < 0.2) {
        pixelWidth = pixelWidth * 0.5;
    }
    CGFloat pixelHeight = pixelWidth / aspectRatio;
    CGSize imageSize = CGSizeMake(pixelWidth, pixelHeight);
    
    //修复获取图片时出现的瞬间内存过高问题
    WZMAlbumHelper *helper = [WZMAlbumHelper shareHelper];
    helper.imageOptions.networkAccessAllowed = NO;
    helper.imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    int32_t imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:helper.imageOptions resultHandler:^(UIImage *result, NSDictionary *info) {
        if ([info objectForKey:PHImageErrorKey]) {
            if (thumbnail) thumbnail(nil);
        }
        else {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue]);
            if (downloadFinined && result) {
                result = [self wzm_fixImageOrientation:result];
                if (thumbnail) thumbnail(result);
            }
        }
    }];
    
    if (cloud) {
        WZMAlbumPhotoType type = [self wzm_getAssetType:asset];
        if (type == WZMAlbumPhotoTypeVideo) {
            helper.videoOptions.networkAccessAllowed = NO;
            [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:helper.videoOptions resultHandler:^(AVAsset *avasset, AVAudioMix *audioMix, NSDictionary *info){
                dispatch_async(dispatch_get_main_queue(), ^{
                    cloud(avasset==nil);
                });
            }];
        }
        else {
            helper.imageOptions.networkAccessAllowed = NO;
            helper.imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:helper.imageOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                cloud([[info objectForKey:PHImageResultIsInCloudKey] boolValue]);
            }];
        }
    }
    return imageRequestID;
}

//获取原图/原视频
+ (int32_t)wzm_getOriginalWithAsset:(id)asset completion:(void(^)(id obj))completion {
    WZMAlbumHelper *helper = [WZMAlbumHelper shareHelper];
    WZMAlbumPhotoType type = [self wzm_getAssetType:asset];
    if (type == WZMAlbumPhotoTypeVideo) {
        helper.videoOptions.networkAccessAllowed = YES;
        int32_t requestId = [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:helper.videoOptions resultHandler:^(AVAsset *avasset, AVAudioMix *audioMix, NSDictionary *info) {
            if ([info objectForKey:PHImageErrorKey]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) completion(nil);
                });
            }
            else {
                AVURLAsset *videoAsset = (AVURLAsset*)avasset;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(videoAsset.URL);
                    }
                });
            }
        }];
        return requestId;
    }
    else {
        helper.imageOptions.networkAccessAllowed = YES;
        helper.imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        if (type == WZMAlbumPhotoTypePhotoGif) {
            int32_t requestId = [[PHImageManager defaultManager] requestImageDataForAsset:asset options:helper.imageOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                if ([info objectForKey:PHImageErrorKey]) {
                    if (completion) completion(nil);
                }
                else {
                    BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue]);
                    if (downloadFinined && imageData) {
                        if (completion) completion(imageData);
                    }
                }
            }];
            return requestId;
        }
        else {
            int32_t requestId = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:helper.imageOptions resultHandler:^(UIImage *result, NSDictionary *info) {
                if ([info objectForKey:PHImageErrorKey]) {
                    if (completion) completion(nil);
                }
                else {
                    BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue]);
                    if (downloadFinined && result) {
                        result = [self wzm_fixImageOrientation:result];
                        if (completion) completion(result);
                    }
                }
            }];
            return requestId;
        }
    }
}

//从iCloud获取图片/视频
+ (void)wzm_getICloudWithAsset:(id)asset progressHandler:(void(^)(double progress))progressHandler completion:(void (^)(id obj))completion {
    WZMAlbumHelper *helper = [WZMAlbumHelper shareHelper];
    helper.iCloudImageOptions.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressHandler) {
                progressHandler(progress);
            }
        });
    };
    WZMAlbumPhotoType type = [self wzm_getAssetType:asset];
    if (type == WZMAlbumPhotoTypeVideo) {
        [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:helper.iCloudVideoOptions resultHandler:^(AVAsset *avasset, AVAudioMix *audioMix, NSDictionary *info){
            if ([info objectForKey:PHImageErrorKey]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) completion(nil);
                });
            }
            else {
                AVURLAsset *videoAsset = (AVURLAsset*)avasset;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) completion(videoAsset.URL);
                });
            }
        }];
    }
    else if (type == WZMAlbumPhotoTypePhotoGif) {
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:helper.iCloudImageOptions resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
            if ([info objectForKey:PHImageErrorKey]) {
                if (completion) completion(nil);
            }
            else {
                BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue]);
                if (downloadFinined && imageData) {
                    if (completion) completion(imageData);
                }
            }
        }];
    }
    else {
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:helper.iCloudImageOptions resultHandler:^(UIImage *result, NSDictionary *info) {
            if ([info objectForKey:PHImageErrorKey]) {
                if (completion) completion(nil);
            }
            else {
                BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue]);
                if (downloadFinined && result) {
                    result = [self wzm_fixImageOrientation:result];
                    if (completion) completion(result);
                }
            }
        }];
    }
}

//导出图片
+ (void)wzm_exportImageWithAsset:(id)asset imageSize:(CGSize)imageSize completion:(void(^)(UIImage *image))completion {
    WZMAlbumHelper *helper = [WZMAlbumHelper shareHelper];
    helper.imageOptions.networkAccessAllowed = YES;
    helper.imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFit options:helper.imageOptions resultHandler:^(UIImage *result, NSDictionary *info) {
        if ([info objectForKey:PHImageErrorKey]) {
            if (completion) completion(nil);
        }
        else {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue]);
            if (downloadFinined && result) {
                result = [self wzm_fixImageOrientation:result];
                if (completion) completion(result);
            }
        }
    }];
}

//导出GIF
+ (void)wzm_exportGifWithAsset:(id)asset completion:(void(^)(NSData *data))completion {
    WZMAlbumHelper *helper = [WZMAlbumHelper shareHelper];
    helper.imageOptions.networkAccessAllowed = YES;
    helper.imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:helper.iCloudImageOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        if ([info objectForKey:PHImageErrorKey]) {
            if (completion) completion(nil);
        }
        else {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue]);
            if (downloadFinined && imageData) {
                if (completion) completion(imageData);
            }
        }
    }];
}

//导出视频
+ (void)wzm_exportVideoWithAsset:(id)asset completion:(void(^)(NSURL *videoURL))completion {
    WZMAlbumHelper *helper = [WZMAlbumHelper shareHelper];
    [self wzm_exportVideoWithAsset:asset preset:AVAssetExportPreset640x480 outFolder:helper.videoFolder completion:completion];
}

+ (void)wzm_exportVideoWithAsset:(id)asset preset:(NSString *)preset outFolder:(NSString *)outFolder completion:(void(^)(NSURL *videoURL))completion {
    WZMAlbumHelper *helper = [WZMAlbumHelper shareHelper];
    helper.videoOptions.networkAccessAllowed = YES;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:helper.videoOptions resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
        NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avasset];
        if ([presets containsObject:preset]) {
            AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:avasset presetName:preset];
            NSDateFormatter *formater = [NSDateFormatter wzm_dateFormatter:@"yyyy-MM-dd-HH:mm:ss-SSS"];
            NSString *videoName = [NSString stringWithFormat:@"%@.mp4",[formater stringFromDate:[NSDate date]]];
            NSString *outputPath = [outFolder stringByAppendingPathComponent:videoName];
            session.shouldOptimizeForNetworkUse = true;
            NSArray *supportedTypeArray = session.supportedFileTypes;
            if (supportedTypeArray.count == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        WZMLog(@"该视频类型暂不支持导出");
                        completion(nil);
                    }
                });
                return;
            }
            else if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {
                session.outputFileType = AVFileTypeMPEG4;
            } else {
                AVURLAsset *videoAsset = (AVURLAsset*)avasset;
                session.outputFileType = [supportedTypeArray objectAtIndex:0];
                if (videoAsset.URL && videoAsset.URL.lastPathComponent) {
                    outputPath = [outputPath stringByReplacingOccurrencesOfString:@".mp4" withString:[NSString stringWithFormat:@"-%@", videoAsset.URL.lastPathComponent]];
                }
            }
            session.outputURL = [NSURL fileURLWithPath:outputPath];
            [session exportAsynchronouslyWithCompletionHandler:^(void) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    switch (session.status) {
                        case AVAssetExportSessionStatusCompleted: {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (completion) {
                                    completion([NSURL fileURLWithPath:outputPath]);
                                }
                            });
                        }  break;
                        default: {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (completion) {
                                    WZMLog(@"%@",session.error.description);
                                    completion(nil);
                                }
                            });
                        };
                    }
                });
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    NSString *des = [NSString stringWithFormat:@"当前设备不支持该预设:%@", preset];
                    WZMLog(@"%@",des);
                    completion(nil);
                }
            });
        }
    }];
}

//保存视频到系统相册
+ (void)wzm_saveVideoWithPath:(NSString *)path completion:(void(^)(NSError *error))completion {
    if (path == nil || path.length == 0) return;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        NSURL *url = [NSURL fileURLWithPath:path];
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(error);
        });
    }];
}

//保存图片到系统相册
+ (void)wzm_saveImage:(UIImage *)image completion:(void(^)(NSError *error))completion {
    if (image == nil) return;
    if ([image isKindOfClass:[UIImage class]]) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion(error);
            });
        }];
    }
}

+ (void)wzm_saveImageWithPath:(NSString *)path completion:(void(^)(NSError *error))completion {
    if (path == nil || path.length == 0) return;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        NSURL *url = [NSURL fileURLWithPath:path];
        [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:url];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(error);
        });
    }];
}

///清除视频缓存
+ (void)wzm_claerVideoCache {
    WZMAlbumHelper *helper = [WZMAlbumHelper shareHelper];
    [WZMFileManager deleteFileAtPath:helper.videoFolder error:nil];
    [WZMFileManager createDirectoryAtPath:helper.videoFolder];
}

///从iCloud获取图片失败
+ (void)showiCloudError {
    WZMAlbumHelper *helper = [WZMAlbumHelper shareHelper];
    if (helper.isShowAlert) return;
    helper.showAlert = YES;
#if WZM_APP
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"从iCloud获取图片失败，请切换至无线网络后重试" delegate:helper cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
#endif
}

#if WZM_APP
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    WZMAlbumHelper *helper = [WZMAlbumHelper shareHelper];
    helper.showAlert = NO;
}
#endif

#pragma mark - 刷新相册通知
+ (void)postUpdateAlbumNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WZMUpdateAlbum" object:nil];
}

+ (void)addUpdateAlbumObserver:(id)observer selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:@"WZMUpdateAlbum" object:nil];
}

+ (void)removeUpdateAlbumObserver:(id)observer {
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

#pragma mark - other
//修正图片转向
+ (UIImage *)wzm_fixImageOrientation:(UIImage *)aImage {
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//修正视频转向
+ (AVMutableVideoComposition *)wzm_fixVideoOrientation:(AVAsset *)videoAsset {
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    // 视频转向
    int degrees = [self degressFromVideoFileWithAsset:videoAsset];
    if (degrees != 0) {
        CGAffineTransform translateToCenter;
        CGAffineTransform mixedTransform;
        videoComposition.frameDuration = CMTimeMake(1, 30);
        
        NSArray *tracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        
        AVMutableVideoCompositionInstruction *roateInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        roateInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [videoAsset duration]);
        AVMutableVideoCompositionLayerInstruction *roateLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        if (degrees == 90) {
            // 顺时针旋转90°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, 0.0);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        } else if(degrees == 180){
            // 顺时针旋转180°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.width, videoTrack.naturalSize.height);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.width,videoTrack.naturalSize.height);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        } else if(degrees == 270){
            // 顺时针旋转270°
            translateToCenter = CGAffineTransformMakeTranslation(0.0, videoTrack.naturalSize.width);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2*3.0);
            videoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        }
        
        roateInstruction.layerInstructions = @[roateLayerInstruction];
        // 加入视频方向信息
        videoComposition.instructions = @[roateInstruction];
    }
    return videoComposition;
}

/// 获取视频角度
+ (int)degressFromVideoFileWithAsset:(AVAsset *)asset {
    int degress = 0;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        } else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        } else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        } else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    return degress;
}

@end
