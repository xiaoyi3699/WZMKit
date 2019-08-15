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
#import <AssetsLibrary/AssetsLibrary.h>

@interface WZMAlbumHelper ()

@property (nonatomic, strong) NSString *videoPath;
@property (nonatomic, assign) CGFloat screenScale;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, strong) PHImageRequestOptions *imageOptions;
@property (nonatomic, strong) PHVideoRequestOptions *videoOptions;

@property (nonatomic, strong) PHImageRequestOptions *iCloudImageOptions;
@property (nonatomic, strong) PHVideoRequestOptions *iCloudVideoOptions;

@end

@implementation WZMAlbumHelper

+ (instancetype)helper {
    static WZMAlbumHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[WZMAlbumHelper alloc] init];
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
        
        self.videoPath = [WZM_CACHE_PATH stringByAppendingPathComponent:@"WZMAlbum"];
        [WZMFileManager createDirectoryAtPath:self.videoPath];
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
        if (@available(iOS 9.1, *)) {
            //             if (asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) type = WZMAlbumPhotoTypeLivePhoto;
        }
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
    WZMAlbumHelper *helper = [WZMAlbumHelper helper];
    helper.imageOptions.networkAccessAllowed = NO;
    int32_t imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:helper.imageOptions resultHandler:^(UIImage *result, NSDictionary *info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && result) {
            result = [self wzm_fixOrientation:result];
            if (thumbnail) thumbnail(result);
        }
    }];
    
    if (cloud) {
        WZMAlbumPhotoType type = [self wzm_getAssetType:asset];
        if (type == WZMAlbumPhotoTypeVideo) {
            helper.videoOptions.networkAccessAllowed = NO;
            [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:helper.videoOptions resultHandler:^(AVAsset *avasset, AVAudioMix *audioMix, NSDictionary *info){
                if (cloud) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cloud(avasset==nil);
                    });
                }
            }];
        }
        else {
            helper.imageOptions.networkAccessAllowed = NO;
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:helper.imageOptions resultHandler:^(UIImage *result, NSDictionary *info) {
                cloud([[info objectForKey:PHImageResultIsInCloudKey] boolValue]);
            }];
        }
    }
    return imageRequestID;
}

//获取原图/原视频
+ (int32_t)wzm_getOriginalWithAsset:(id)asset completion:(void(^)(id obj))completion {
    WZMAlbumHelper *helper = [WZMAlbumHelper helper];
    WZMAlbumPhotoType type = [self wzm_getAssetType:asset];
    if (type == WZMAlbumPhotoTypeVideo) {
        helper.videoOptions.networkAccessAllowed = YES;
        int32_t requestId = [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:helper.videoOptions resultHandler:^(AVAsset *avasset, AVAudioMix *audioMix, NSDictionary *info) {
            AVURLAsset *videoAsset = (AVURLAsset*)avasset;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(videoAsset.URL);
                }
            });
        }];
        return requestId;
    }
    else {
        helper.imageOptions.networkAccessAllowed = YES;
        int32_t requestId = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:helper.imageOptions resultHandler:^(UIImage *result, NSDictionary *info) {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined && result) {
                result = [self wzm_fixOrientation:result];
                if (completion) completion(result);
            }
        }];
        return requestId;
    }
}

//从iCloud获取图片/视频
+ (void)wzm_getICloudWithAsset:(id)asset progressHandler:(void(^)(double progress))progressHandler completion:(void (^)(id obj))completion {
    WZMAlbumHelper *helper = [WZMAlbumHelper helper];
    WZMAlbumPhotoType type = [self wzm_getAssetType:asset];
    if (type == WZMAlbumPhotoTypeVideo) {
        helper.iCloudVideoOptions.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressHandler) {
                    progressHandler(progress);
                }
            });
        };
        [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:helper.iCloudVideoOptions resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
            AVURLAsset *videoAsset = (AVURLAsset*)avasset;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(videoAsset.URL);
                }
            });
        }];
    }
    else {
        helper.iCloudImageOptions.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (progressHandler) {
                    progressHandler(progress);
                }
            });
        };
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:helper.iCloudImageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined && result) {
                result = [self wzm_fixOrientation:result];
                if (completion) completion(result);
            }
        }];
    }
}

//导出视频
+ (void)wzm_exportVideoWithAsset:(id)asset completion:(void(^)(NSURL *videoURL))completion {
    WZMAlbumHelper *helper = [WZMAlbumHelper helper];
    [self wzm_exportVideoWithAsset:asset preset:AVAssetExportPreset640x480 outPath:helper.videoPath completion:completion];
}

+ (void)wzm_exportVideoWithAsset:(id)asset preset:(NSString *)preset outPath:(NSString *)outPath completion:(void(^)(NSURL *videoURL))completion {
    WZMAlbumHelper *helper = [WZMAlbumHelper helper];
    helper.videoOptions.networkAccessAllowed = YES;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:helper.videoOptions resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
        NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avasset];
        if ([presets containsObject:preset]) {
            AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:avasset presetName:preset];
            NSDateFormatter *formater = [NSDateFormatter wzm_dateFormatter:@"yyyy-MM-dd-HH:mm:ss-SSS"];
            NSString *videoName = [formater stringFromDate:[NSDate date]];
            NSString *outputPath = [outPath stringByAppendingFormat:@"%@.mp4", videoName];
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
+ (void)wzm_saveVideo:(NSString *)path {
    UISaveVideoAtPathToSavedPhotosAlbum(path, nil, nil, nil);
}

//保存图片到系统相册
+ (void)wzm_saveImage:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

+ (void)wzm_saveImageData:(NSData *)data completion:(doBlock)completion {
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        if (completion) {
            completion();
        }
    }];
}

///清除视频缓存
+ (void)wzm_claerVideoCache {
    WZMAlbumHelper *helper = [WZMAlbumHelper helper];
    [WZMFileManager deleteFileAtPath:helper.videoPath error:nil];
    [WZMFileManager createDirectoryAtPath:helper.videoPath];
}

//private修正图片转向
+ (UIImage *)wzm_fixOrientation:(UIImage *)aImage {
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

@end
