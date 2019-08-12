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
+ (int32_t)wzm_getThumbnailImageWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion {
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
            if (completion) completion(result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        }
    }];
    return imageRequestID;
}

//获取原图
+ (void)wzm_getOriginalImageWithAsset:(id)asset progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion networkAccessAllowed:(BOOL)networkAccessAllowed {
    WZMAlbumHelper *helper = [WZMAlbumHelper helper];
    helper.imageOptions.networkAccessAllowed = YES;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:helper.imageOptions resultHandler:^(UIImage *result, NSDictionary *info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && result) {
            result = [self wzm_fixOrientation:result];
            BOOL isDegraded = [[info objectForKey:PHImageResultIsDegradedKey] boolValue];
            if (completion) completion(result,info,isDegraded);
        }
        // Download image from iCloud / 从iCloud下载图片
        if ([info objectForKey:PHImageResultIsInCloudKey] && !result && networkAccessAllowed) {
            [self getICloudImageWithAsset:asset progressHandler:progressHandler completion:completion];
        }
    }];
}

+ (void)getICloudImageWithAsset:(id)asset progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion {
    WZMAlbumHelper *helper = [WZMAlbumHelper helper];
    helper.iCloudImageOptions.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressHandler) {
                progressHandler(progress, error, stop, info);
            }
        });
    };
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:helper.iCloudImageOptions resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        UIImage *resultImage = [UIImage imageWithData:imageData];
        resultImage = [self wzm_fixOrientation:resultImage];
        if (completion) completion(resultImage,info,NO);
    }];
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

//获取视频
+ (void)wzm_getVideoWithAsset:(id)asset completion:(void (^)(NSString *videoPath, NSString *desc))completion {
    WZMAlbumHelper *helper = [WZMAlbumHelper helper];
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:helper.videoOptions resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
        // NSLog(@"Info:\n%@",info);
        AVURLAsset *videoAsset = (AVURLAsset*)avasset;
        // NSLog(@"AVAsset URL: %@",myAsset.URL);
        [self wzm_startExportVideoWithVideoAsset:videoAsset presetName:AVAssetExportPreset640x480 completion:completion];
    }];
}

//private导出视频
+ (void)wzm_startExportVideoWithVideoAsset:(AVURLAsset *)videoAsset presetName:(NSString *)presetName completion:(void (^)(NSString *videoPath, NSString *desc))completion {
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    if ([presets containsObject:presetName]) {
        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:presetName];
        NSDateFormatter *formater = [NSDateFormatter wzm_dateFormatter:@"yyyy-MM-dd-HH:mm:ss-SSS"];
        NSString *outputPath = [NSHomeDirectory() stringByAppendingFormat:@"/tmp/video-%@.mp4", [formater stringFromDate:[NSDate date]]];
        session.shouldOptimizeForNetworkUse = true;
        NSArray *supportedTypeArray = session.supportedFileTypes;
        if (supportedTypeArray.count == 0) {
            if (completion) {
                completion(nil, @"该视频类型暂不支持导出");
            }
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
        if (![[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp"]]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/tmp"] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        [session exportAsynchronouslyWithCompletionHandler:^(void) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (session.status) {
                    case AVAssetExportSessionStatusCompleted: {
                        if (completion) {
                            completion(outputPath, nil);
                        }
                    }  break;
                    default: {
                        if (completion) {
                            completion(nil, session.error.description);
                        }
                    };
                }
            });
        }];
    } else {
        if (completion) {
            NSString *des = [NSString stringWithFormat:@"当前设备不支持该预设:%@", presetName];
            completion(nil, des);
        }
    }
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
                      }
                         failureBlock:^(NSError *error){
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

@end
