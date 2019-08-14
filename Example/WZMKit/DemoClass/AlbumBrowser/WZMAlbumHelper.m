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
        
        self.videoOptions = [[PHVideoRequestOptions alloc] init];
        self.videoOptions.version = PHVideoRequestOptionsVersionOriginal;
        self.videoOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        self.videoOptions.networkAccessAllowed = YES;
        
        self.iCloudImageOptions = [[PHImageRequestOptions alloc] init];
        self.iCloudImageOptions.networkAccessAllowed = YES;
        self.iCloudImageOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
        
        self.videoPath = [WZM_CACHE_PATH stringByAppendingPathComponent:@"KPAlbum"];
        [WZMFileManager createDirectoryAtPath:self.videoPath];
    }
    return self;
}

//文件格式
+ (WZMAlbumPhotoType)getAssetType:(id)asset {
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
    // 超宽图片
    if (aspectRatio > 1.8) {
        pixelWidth = pixelWidth * aspectRatio;
    }
    // 超高图片
    if (aspectRatio < 0.2) {
        pixelWidth = pixelWidth * 0.5;
    }
    CGFloat pixelHeight = pixelWidth / aspectRatio;
    CGSize imageSize = CGSizeMake(pixelWidth, pixelHeight);
    
    // 修复获取图片时出现的瞬间内存过高问题
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
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:helper.imageOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            cloud([[info objectForKey:PHImageResultIsInCloudKey] boolValue]);
        }];
    }
    return imageRequestID;
}

//获取原图
+ (void)wzm_getOriginalWithAsset:(id)asset completion:(void(^)(UIImage *photo, BOOL iCloud))completion {
    WZMAlbumHelper *helper = [WZMAlbumHelper helper];
    helper.imageOptions.networkAccessAllowed = YES;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:helper.imageOptions resultHandler:^(UIImage *result, NSDictionary *info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && result) {
            result = [self wzm_fixOrientation:result];
            if (completion) completion(result,[[info objectForKey:PHImageResultIsInCloudKey] boolValue]);
        }
        else {
            if (completion) completion(nil,[[info objectForKey:PHImageResultIsInCloudKey] boolValue]);
        }
    }];
}

+ (void)getICloudImageWithAsset:(id)asset progressHandler:(void(^)(double progress))progressHandler completion:(void (^)(id obj))completion {
    WZMAlbumHelper *helper = [WZMAlbumHelper helper];
    helper.iCloudImageOptions.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressHandler) {
                progressHandler(progress);
            }
        });
    };
    WZMAlbumPhotoType type = [self getAssetType:asset];
    if (type == WZMAlbumPhotoTypeVideo) {
        [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:helper.videoOptions resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
            AVURLAsset *videoAsset = (AVURLAsset*)avasset;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(videoAsset.URL);
                }
            });
        }];
    }
    else {
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:helper.iCloudImageOptions resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
            UIImage *resultImage = [UIImage imageWithData:imageData];
            resultImage = [self wzm_fixOrientation:resultImage];
            if (completion) completion(resultImage);
        }];
    }
}

//获取视频
+ (void)wzm_getVideoWithAsset:(id)asset completion:(void(^)(NSURL *videoURL))completion {
    WZMAlbumHelper *helper = [WZMAlbumHelper helper];
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:helper.videoOptions resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
        AVURLAsset *videoAsset = (AVURLAsset*)avasset;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(videoAsset.URL);
            }
        });
    }];
}

//导出视频
+ (void)wzm_exportVideoWithAsset:(id)asset completion:(void(^)(NSURL *videoURL))completion {
    WZMAlbumHelper *helper = [WZMAlbumHelper helper];
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:helper.videoOptions resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
        // NSLog(@"Info:\n%@",info);
        AVURLAsset *videoAsset = (AVURLAsset*)avasset;
        // NSLog(@"AVAsset URL: %@",myAsset.URL);
        [self wzm_startExportVideoWithVideoAsset:videoAsset presetName:AVAssetExportPreset640x480 completion:completion];
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

//保存图片到自定义相册
+ (void)wzm_saveToAlbumName:(NSString *)albumName data:(NSData *)data completion:(doBlock)completion {
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    NSMutableArray *groups=[[NSMutableArray alloc]init];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group){
            [groups addObject:group];
        }
        else {
            BOOL haveHDRGroup = NO;
            for (ALAssetsGroup *gp in groups) {
                NSString *name =[gp valueForProperty:ALAssetsGroupPropertyName];
                if ([name isEqualToString:albumName]) {//相册已存在
                    haveHDRGroup = YES;
                    break;
                }
            }
            if (haveHDRGroup == NO) {//相册不存在
                [assetsLibrary addAssetsGroupAlbumWithName:albumName
                                               resultBlock:^(ALAssetsGroup *group) {
                                                   [groups addObject:group];
                                               }
                                              failureBlock:nil];
            }
        }
    };
    //创建相簿
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:listGroupBlock failureBlock:nil];
    [self wzm_saveToAlbumWithMetadata:nil
                            imageData:data
                      customAlbumName:albumName
                      completionBlock:^{
                          if (completion) {
                              completion();
                          }
                      } failureBlock:^(NSError *error) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              if([error.localizedDescription rangeOfString:@"User denied access"].location != NSNotFound
                                 ||[error.localizedDescription rangeOfString:@"用户拒绝访问"].location!=NSNotFound){
                                  //提示授权
                                  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:error.localizedDescription message:error.localizedFailureReason delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles: nil];
                                  [alert show];
                              }
                          });
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

//保存到相册
+ (void)wzm_saveToAlbumWithMetadata:(NSDictionary *)metadata
                          imageData:(NSData *)imageData
                    customAlbumName:(NSString *)customAlbumName
                    completionBlock:(void (^)(void))completionBlock
                       failureBlock:(void (^)(NSError *error))failureBlock {
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    __weak ALAssetsLibrary *weakSelf = assetsLibrary;
    void (^AddAsset)(ALAssetsLibrary *, NSURL *) = ^(ALAssetsLibrary *assetsLibrary, NSURL *assetURL) {
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:customAlbumName]) {
                    [group addAsset:asset];
                    if (completionBlock) {
                        completionBlock();
                    }
                }
            } failureBlock:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
        } failureBlock:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    };
    [assetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if (customAlbumName) {
            [assetsLibrary addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
                if (group) {
                    [weakSelf assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group addAsset:asset];
                        if (completionBlock) {
                            completionBlock();
                        }
                    } failureBlock:^(NSError *error) {
                        if (failureBlock) {
                            failureBlock(error);
                        }
                    }];
                }
                else {
                    AddAsset(weakSelf, assetURL);
                }
            } failureBlock:^(NSError *error) {
                AddAsset(weakSelf, assetURL);
            }];
        }
        else {
            if (completionBlock) {
                completionBlock();
            }
        }
    }];
}

//private导出视频
+ (void)wzm_startExportVideoWithVideoAsset:(AVURLAsset *)videoAsset presetName:(NSString *)presetName completion:(void(^)(NSURL *videoURL))completion {
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    if ([presets containsObject:presetName]) {
        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:presetName];
        WZMAlbumHelper *helper = [WZMAlbumHelper helper];
        NSDateFormatter *formater = [NSDateFormatter wzm_dateFormatter:@"yyyy-MM-dd-HH:mm:ss-SSS"];
        NSString *videoName = [formater stringFromDate:[NSDate date]];
        NSString *outputPath = [helper.videoPath stringByAppendingFormat:@"%@.mp4", videoName];
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
                NSString *des = [NSString stringWithFormat:@"当前设备不支持该预设:%@", presetName];
                WZMLog(@"%@",des);
                completion(nil);
            }
        });
    }
}

@end
