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

@interface WZMAlbumController ()<UIAlertViewDelegate>

@property (nonatomic, strong) WZMAlbumView *albumBrowser;

@end

@implementation WZMAlbumController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.column = 4;
        self.autoDismiss = YES;
        self.allowPreview = NO;
        self.allowShowGIF = NO;
        self.allowShowImage = YES;
        self.allowShowVideo = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.albumBrowser = [[WZMAlbumView alloc] initWithFrame:WZMRectBottomArea()];
    if ([self.navigationController isKindOfClass:[WZMAlbumNavigationController class]]) {
        WZMAlbumNavigationController *picker = (WZMAlbumNavigationController *)self.navigationController;
        self.albumBrowser.column = picker.column;
        self.albumBrowser.allowPreview = picker.allowPreview;
        self.albumBrowser.allowShowImage = picker.allowShowImage;
        self.albumBrowser.allowShowVideo = picker.allowShowVideo;
    }
    else {
        self.albumBrowser.column = self.column;
        self.albumBrowser.allowPreview = self.allowPreview;
        self.albumBrowser.allowShowImage = self.allowShowImage;
        self.albumBrowser.allowShowVideo = self.allowShowVideo;
    }
    [self.view addSubview:self.albumBrowser];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkAlbumAuthorization];
}

- (void)leftItemClick {
    if ([self.navigationController isKindOfClass:[WZMAlbumNavigationController class]]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightItemClick {
    [WZMViewHandle wzm_showProgressMessage:@"处理中..."];
    self.navigationController.view.userInteractionEnabled = NO;
    [self photosWithModels:self.albumBrowser.selectedPhotos completion:^(NSArray *photos) {
        [WZMViewHandle wzm_dismiss];
        self.navigationController.view.userInteractionEnabled = YES;
        if ([self.navigationController isKindOfClass:[WZMAlbumNavigationController class]]) {
            WZMAlbumNavigationController *picker = (WZMAlbumNavigationController *)self.navigationController;
            if ([picker.pickerDelegate respondsToSelector:@selector(albumNavigationController:didSelectedPhotos:)]) {
                [picker.pickerDelegate albumNavigationController:picker didSelectedPhotos:photos];
            }
            if (picker.autoDismiss) {
                [picker dismissViewControllerAnimated:YES completion:nil];
            }
        }
        else {
            if ([self.pickerDelegate respondsToSelector:@selector(albumController:didSelectedPhotos:)]) {
                [self.pickerDelegate albumController:self didSelectedPhotos:photos];
            }
            if (self.autoDismiss) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

//相册权限
- (void)checkAlbumAuthorization {
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized){//用户之前已经授权
        [self.albumBrowser reloadData];
    }
    else if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied){//用户之前已经拒绝授权
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请前往“设置-隐私-照片”打开应用的相册访问权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    else{//弹窗授权时监听
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized){//允许
                    [self.albumBrowser reloadData];
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

///获取图片(UIImage)或视频(路径)
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
        [WZMAlbumHelper wzm_getVideoWithAsset:model.asset completion:^(NSString *videoPath, NSString *desc) {
            if (completion) {
                completion(videoPath);
            }
        }];
    }
    else {
        [WZMAlbumHelper wzm_getOriginalImageWithAsset:model.asset progressHandler:nil completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            if (completion) {
                completion(photo);
            }
        } networkAccessAllowed:YES];
    }
}

- (void)dealloc {
    WZMLog(@"%@释放了",NSStringFromClass(self.class));
}

@end
