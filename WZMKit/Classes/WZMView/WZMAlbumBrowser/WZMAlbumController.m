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
#import "UIColor+wzmcate.h"
#import "UIViewController+WZMModalAnimation.h"

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
    self.view.backgroundColor = [UIColor wzm_getDynamicColorByLightColor:[UIColor whiteColor] darkColor:[UIColor blackColor]];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = [UIColor wzm_getDynamicColorByLightColor:[UIColor blueColor] darkColor:[UIColor whiteColor]];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    rightItem.tintColor = [UIColor wzm_getDynamicColorByLightColor:WZM_ALBUM_COLOR darkColor:[UIColor whiteColor]];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.albumView = [[WZMAlbumView alloc] initWithConfig:self.config];
    self.albumView.delegate = self;
    [self.view addSubview:self.albumView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat navBarH = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGRect rect = self.view.bounds;
    rect.origin.y = navBarH;
    rect.size.height -= navBarH;
    self.albumView.frame = rect;
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
    [self photosWithModels:self.albumView.selectedPhotos completion:^(NSArray *originals, NSArray *thumbnails, NSArray *assets) {
        [WZMViewHandle wzm_dismiss];
        self.navigationController.view.userInteractionEnabled = YES;
        if ([self.navigationController isKindOfClass:[WZMAlbumNavigationController class]]) {
            WZMAlbumNavigationController *picker = (WZMAlbumNavigationController *)self.navigationController;
            if ([picker.pickerDelegate respondsToSelector:@selector(albumNavigationController:didSelectedOriginals:thumbnails:assets:)]) {
                [picker.pickerDelegate albumNavigationController:picker didSelectedOriginals:originals thumbnails:thumbnails assets:assets];
            }
            if (self.config.autoDismiss) {
                [picker dismissViewControllerAnimated:YES completion:nil];
            }
        }
        else {
            if ([self.pickerDelegate respondsToSelector:@selector(albumController:didSelectedOriginals:thumbnails:assets:)]) {
                [self.pickerDelegate albumController:self didSelectedOriginals:originals thumbnails:thumbnails assets:assets];
            }
            if (self.config.autoDismiss) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

//WZMAlbumView代理
- (void)albumViewDidSelectedFinish:(WZMAlbumView *)albumView {
    [self rightItemClick];
}

- (void)albumViewWillPreview:(WZMAlbumView *)albumView atIndexPath:(NSIndexPath *)indexPath {
    WZMPhotoBrowser *photoBrowser = [[WZMPhotoBrowser alloc] init];
    photoBrowser.delegate = self;
    photoBrowser.images = albumView.allPhotos;
    photoBrowser.index = indexPath.row;
    photoBrowser.modalPresentationStyle = UIModalPresentationFullScreen;
    
    //计算初始frame
    UICollectionViewCell *cell = [albumView.collectionView cellForItemAtIndexPath:indexPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:self.navigationController.view];
    [self resetPhotoBrowser:photoBrowser presentRect:rect ];
    [self presentViewController:photoBrowser animated:YES completion:nil];
}

//WZMPhotoBrowser代理
- (void)photoBrowser:(WZMPhotoBrowser *)photoBrowser clickAtIndex:(NSInteger)index contentType:(WZMAlbumPhotoType)contentType gestureType:(WZMGestureRecognizerType)gestureType {
    if (gestureType == WZMGestureRecognizerTypeClose || gestureType == WZMGestureRecognizerTypeSingle) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:photoBrowser.index inSection:0];
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
        [self resetPhotoBrowser:photoBrowser dismissRect:rect];
        [photoBrowser dismissViewControllerAnimated:YES completion:nil];
    }
}

//设置present动画
- (void)resetPhotoBrowser:(WZMPhotoBrowser *)photoBrowser presentRect:(CGRect)rect {
    photoBrowser.wzm_showFromFrame = rect;
    photoBrowser.wzm_showToFrame = [UIScreen mainScreen].bounds;
    photoBrowser.wzm_presentAnimationType = WZMModalAnimationTypeZoom;
}

//设置dismiss动画
- (void)resetPhotoBrowser:(WZMPhotoBrowser *)photoBrowser dismissRect:(CGRect)rect {
    photoBrowser.wzm_dismissFromFrame = [UIScreen mainScreen].bounds;
    photoBrowser.wzm_dismissToFrame = rect;
    photoBrowser.wzm_dismissAnimationType = WZMModalAnimationTypeZoom;
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
- (void)photosWithModels:(NSArray<WZMAlbumModel *> *)models completion:(void(^)(NSArray *originals,NSArray *thumbnails,NSArray *assets))completion {
    NSMutableArray *array1 = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *array2 = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *array3 = [[NSMutableArray alloc] initWithCapacity:0];
    [self photosWithModels:models index:0 originals:array1 thumbnails:array2 assets:array3 completion:completion];
}

- (void)photosWithModels:(NSArray<WZMAlbumModel *> *)models index:(NSInteger)index originals:(NSMutableArray *)array1 thumbnails:(NSMutableArray *)array2 assets:(NSMutableArray *)array3 completion:(void(^)(NSArray *originals,NSArray *thumbnails,NSArray *assets))completion {
    if (index < models.count) {
        WZMAlbumModel *model = [models objectAtIndex:index];
        [model getImageWithConfig:self.config completion:^(id obj) {
            if (obj) {
                [array1 addObject:obj];
                [array2 addObject:model.thumbnail];
                [array3 addObject:model.asset];
            }
            [self photosWithModels:models index:(index+1) originals:array1 thumbnails:array2 assets:array3 completion:completion];
        }];
    }
    else {
        if (completion) completion([array1 copy],[array2 copy],[array3 copy]);
    }
}

- (void)dealloc {
    WZMLog(@"%@释放了",NSStringFromClass(self.class));
}

@end
