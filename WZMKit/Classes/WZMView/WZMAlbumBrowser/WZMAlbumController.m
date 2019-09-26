//
//  WZMAlbumController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/12.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMAlbumController.h"
#import <Photos/Photos.h>
#import "WZMAlbumNavigationController.h"
#import "WZMAlbumView.h"
#import "WZMAlbumHelper.h"
#import "WZMInline.h"
#import "WZMViewHandle.h"
#import "WZMLogPrinter.h"
#import "WZMPhotoBrowser.h"

@interface WZMAlbumController ()<UIAlertViewDelegate,WZMAlbumViewDelegate,WZMPhotoBrowserDelegate>

@property (nonatomic, strong) WZMAlbumConfig *config;
@property (nonatomic, strong) WZMAlbumView *albumView;

@end

@implementation WZMAlbumController

- (instancetype)initWithConfig:(WZMAlbumConfig *)config {
    self = [super init];
    if (self) {
        self.config = config;
        self.title = config.title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WZM_R_G_B(244, 244, 244);
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.albumView = [[WZMAlbumView alloc] initWithFrame:WZMRectBottomArea() config:self.config];
    self.albumView.delegate = self;
    [self.view addSubview:self.albumView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkAlbumAuthorization];
}

- (void)leftItemClick {
    if ([self.navigationController isKindOfClass:[WZMAlbumNavigationController class]]) {
        WZMAlbumNavigationController *picker = (WZMAlbumNavigationController *)self.navigationController;
        if ([picker.pickerDelegate respondsToSelector:@selector(albumNavigationControllerDidCancel:)]) {
            [picker.pickerDelegate albumNavigationControllerDidCancel:picker];
        }
        if (self.config.autoDismiss) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else {
        if ([self.pickerDelegate respondsToSelector:@selector(albumControllerDidCancel:)]) {
            [self.pickerDelegate albumControllerDidCancel:self];
        }
        if (self.config.autoDismiss) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)rightItemClick {
    if (self.albumView.selectedPhotos.count < self.config.minCount) {
        NSString *msg = [NSString stringWithFormat:@"请至少选择%@张照片",@(self.config.minCount)];
        [WZMViewHandle wzm_showInfoMessage:msg];
        return;
    }
    [WZMViewHandle wzm_showProgressMessage:@"处理中..."];
    self.navigationController.view.userInteractionEnabled = NO;
    [self photosWithModels:self.albumView.selectedPhotos completion:^(NSArray *photos) {
        [WZMViewHandle wzm_dismiss];
        self.navigationController.view.userInteractionEnabled = YES;
        if ([self.navigationController isKindOfClass:[WZMAlbumNavigationController class]]) {
            WZMAlbumNavigationController *picker = (WZMAlbumNavigationController *)self.navigationController;
            if ([picker.pickerDelegate respondsToSelector:@selector(albumNavigationController:didSelectedPhotos:)]) {
                [picker.pickerDelegate albumNavigationController:picker didSelectedPhotos:photos];
            }
            if (self.config.autoDismiss) {
                [picker dismissViewControllerAnimated:YES completion:nil];
            }
        }
        else {
            if ([self.pickerDelegate respondsToSelector:@selector(albumController:didSelectedPhotos:)]) {
                [self.pickerDelegate albumController:self didSelectedPhotos:photos];
            }
            if (self.config.autoDismiss) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

//代理
- (void)albumViewDidSelectedFinish:(WZMAlbumView *)albumView {
    [self rightItemClick];
}

- (void)albumViewWillPreview:(WZMAlbumView *)albumView atIndexPath:(NSIndexPath *)indexPath {
    WZMPhotoBrowser *photoBrowser = [[WZMPhotoBrowser alloc] init];
    photoBrowser.delegate = self;
    photoBrowser.images = albumView.allPhotos;
    photoBrowser.index = indexPath.row;
    
    //计算初始frame
    UICollectionViewCell *cell = [albumView.collectionView cellForItemAtIndexPath:indexPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:self.navigationController.view];
    
    CGFloat scale = rect.size.height/photoBrowser.view.bounds.size.height;
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    photoBrowser.view.center = center;
    photoBrowser.view.transform = CGAffineTransformMakeScale(scale, scale);
    photoBrowser.view.alpha = 0.0;
    photoBrowser.navigationItem.hidesBackButton = YES;
    [self.navigationController.view addSubview:photoBrowser.view];
    [self.navigationController addChildViewController:photoBrowser];
    
    [UIView animateWithDuration:0.35 animations:^{
        photoBrowser.view.alpha = 1.0;
        photoBrowser.view.center = CGPointMake(CGRectGetMidX(self.navigationController.view.bounds), CGRectGetMidY(self.navigationController.view.bounds));
        photoBrowser.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)photoBrowser:(WZMPhotoBrowser *)photoBrowser clickAtIndex:(NSInteger)index contentType:(WZMAlbumPhotoType)contentType gestureType:(WZMGestureRecognizerType)gestureType {
    if (gestureType == WZMGestureRecognizerTypeClose || gestureType == WZMGestureRecognizerTypeSingle) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        UICollectionViewCell *cell = [self.albumView.collectionView cellForItemAtIndexPath:indexPath];
        NSArray *visibleCells = [self.albumView.collectionView visibleCells];
        CGRect rect;
        if ([visibleCells containsObject:cell]) {
            rect = [cell.superview convertRect:cell.frame toView:self.navigationController.view];
        }
        else {
            rect = photoBrowser.view.bounds;
            rect.origin.x -= 20;
            rect.origin.y -= 20;
            rect.size.width += 40;
            rect.size.height += 40;
        }
        CGFloat scale = rect.size.height/photoBrowser.view.bounds.size.height;
        CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
        self.navigationController.view.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.35 animations:^{
            photoBrowser.view.center = center;
            photoBrowser.view.transform = CGAffineTransformMakeScale(scale, scale);
            photoBrowser.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [photoBrowser.view removeFromSuperview];
            [photoBrowser willMoveToParentViewController:nil];
            [photoBrowser removeFromParentViewController];
            self.navigationController.view.userInteractionEnabled = YES;
        }];
    }
}

//相册权限
- (void)checkAlbumAuthorization {
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized){//用户之前已经授权
        [self.albumView reloadData];
    }
    else if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied){//用户之前已经拒绝授权
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请前往“设置-隐私-照片”打开应用的相册访问权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    else{//弹窗授权时监听
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized){//允许
                    [self.albumView reloadData];
                }
                else {//拒绝
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
            });
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private
///获取图片(UIImage),GIF(NSData)或视频(NSURL)
- (void)photosWithModels:(NSArray<WZMAlbumModel *> *)models completion:(void(^)(NSArray *photos))completion {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    [self photosWithModels:models index:0 array:array completion:completion];
}

- (void)photosWithModels:(NSArray<WZMAlbumModel *> *)models index:(NSInteger)index array:(NSMutableArray *)array completion:(void(^)(NSArray *photos))completion {
    if (index < models.count) {
        WZMAlbumModel *model = [models objectAtIndex:index];
        [self photoWithModel:model completion:^(id obj) {
            if (obj) {
                [array addObject:obj];
            }
            [self photosWithModels:models index:(index+1) array:array completion:completion];
        }];
    }
    else {
        if (completion) {
            completion([array copy]);
        }
    }
}

- (void)photoWithModel:(WZMAlbumModel *)model completion:(void(^)(id obj))completion {
    if (model.type == WZMAlbumPhotoTypeVideo) {
        if (self.config.originalVideo) {
            //原视频
            [model getOriginalCompletion:^(id original) {
                if (completion) {
                    completion(original);
                }
            }];
        }
        else {
            //预设尺寸
            [model exportVideoWithPreset:self.config.videoPreset outFolder:self.config.videoFolder completion:^(NSURL *videoURL) {
                if (completion) {
                    completion(videoURL);
                }
            }];
        }
    }
    else if (model.type == WZMAlbumPhotoTypeAudio) {
        if (completion) {
            completion(nil);
        }
    }
    else if (model.type == WZMAlbumPhotoTypePhotoGif && self.config.allowShowGIF) {
        //原图
        [model getOriginalCompletion:^(id original) {
            if (completion) {
                completion(original);
            }
        }];
    }
    else {
        if (self.config.originalImage) {
            //原图
            [model getOriginalCompletion:^(id original) {
                if (completion) {
                    completion(original);
                }
            }];
        }
        else {
            //预设尺寸
            [model exportImageWithImageSize:self.config.imageSize completion:^(UIImage *image) {
                if (completion) {
                    completion(image);
                }
            }];
        }
    }
}

- (void)dealloc {
    WZMLog(@"%@释放了",NSStringFromClass(self.class));
}

@end
