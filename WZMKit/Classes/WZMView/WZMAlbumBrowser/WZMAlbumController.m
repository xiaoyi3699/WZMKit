//
//  WZMAlbumController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/12.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMAlbumController.h"
#import <Photos/Photos.h>
#import "WZMButton.h"
#import "WZMAlbumView.h"
#import "WZMAlbumHelper.h"
#import "WZMInline.h"
#import "WZMViewHandle.h"
#import "WZMLogPrinter.h"
#import "WZMPhotoBrowser.h"
#import "UIColor+wzmcate.h"
#import "WZMAlbumListCell.h"
#import "WZMAlbumNavigationController.h"
#import "UIViewController+WZMModalAnimation.h"
#import "WZMDefined.h"

@interface WZMAlbumController ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,WZMAlbumViewDelegate,WZMPhotoBrowserDelegate>

@property (nonatomic, assign) CGFloat navBarH;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) WZMButton *titleBtn;
@property (nonatomic, strong) WZMAlbumConfig *config;
@property (nonatomic, strong) WZMAlbumView *albumView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIVisualEffectView *visualView;

@end

@implementation WZMAlbumController

- (instancetype)initWithConfig:(WZMAlbumConfig *)config {
    self = [super init];
    if (self) {
        self.navBarH = 0;
        self.config = config;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor wzm_getDynamicColorByLightColor:[UIColor whiteColor] darkColor:[UIColor blackColor]];
    
    UIImage *dropImage = [[WZMPublic imageWithFolder:@"album" imageName:@"album_drop_down.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.titleView = [[UIView alloc] init];
    self.titleBtn = [WZMButton buttonWithType:UIButtonTypeCustom];
    self.titleBtn.backgroundColor = [UIColor wzm_getDynamicColorByLightColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.5] darkColor:[UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.5]];
    self.titleBtn.layer.cornerRadius = 15;
    self.titleBtn.layer.masksToBounds = YES;
    self.titleBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleBtn.tintColor = [UIColor wzm_getDynamicColorByLightColor:[UIColor darkTextColor] darkColor:[UIColor whiteColor]];
    [self.titleBtn setTitleColor:[UIColor wzm_getDynamicColorByLightColor:[UIColor darkTextColor] darkColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.titleBtn setImage:dropImage forState:UIControlStateNormal];
    [self.titleBtn setImage:dropImage forState:UIControlStateHighlighted];
    [self.titleBtn addTarget:self action:@selector(showVisualViewAction) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:self.titleBtn];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
//    leftItem.tintColor = [UIColor wzm_getDynamicColorByLightColor:[UIColor blueColor] darkColor:[UIColor whiteColor]];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
//    rightItem.tintColor = [UIColor wzm_getDynamicColorByLightColor:WZM_ALBUM_COLOR darkColor:[UIColor whiteColor]];
    
    self.navigationItem.titleView = self.titleView;
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.albumView = [[WZMAlbumView alloc] initWithConfig:self.config];
    self.albumView.delegate = self;
    [self.view addSubview:self.albumView];
    
    UIBlurEffectStyle effectStyle;
//    if (@available(iOS 13.0, *)) {
//        effectStyle = UIBlurEffectStyleSystemUltraThinMaterial;
//    } else {
        effectStyle = UIBlurEffectStyleLight;
//    }
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:effectStyle];
    self.visualView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.visualView.hidden = YES;
    [self.view addSubview:self.visualView];
    
    self.tableView = [[UITableView alloc] init];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
#else
    self.automaticallyAdjustsScrollViewInsets = NO;
#endif
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 60;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorColor = [UIColor wzm_getDynamicColorByLightColor:WZM_R_G_B_A(200, 200, 200, 0.5) darkColor:WZM_R_G_B_A(55, 55, 55, 0.5)];
    self.tableView.scrollsToTop = NO;
    
    [self.visualView.contentView addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (self.navBarH == 0) {
        self.navBarH = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        if (self.navBarH == 0) return;
        CGRect rect = self.view.bounds;
        CGFloat y = self.navBarH;
        CGFloat h = rect.size.height - self.navBarH;
        rect.origin.y = y;
        rect.size.height = h;
        self.albumView.frame = rect;
        self.visualView.frame = CGRectMake(0, y-h, rect.size.width, h);
        self.tableView.frame = self.visualView.bounds;
        [self updateTitleViewWithTitle:self.albumView.selectedAlbum.title];
    }
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

- (void)showVisualViewAction {
    if (self.visualView.hidden) {
        self.visualView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.visualView.frame;
            rect.origin.y = self.navBarH;
            self.visualView.frame = rect;
            self.titleBtn.imageView.layer.transform = CATransform3DConcat(CATransform3DIdentity, CATransform3DMakeRotation(179.99*M_PI/180.0, 0, 0, 1));
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.visualView.frame;
            rect.origin.y = (self.navBarH - rect.size.height);
            self.visualView.frame = rect;
            self.titleBtn.imageView.layer.transform = CATransform3DConcat(CATransform3DIdentity, CATransform3DMakeRotation(0, 0, 0, 1));
        } completion:^(BOOL finished) {
            self.visualView.hidden = YES;
        }];
    }
    [self.tableView reloadData];
}

- (void)updateTitleViewWithTitle:(NSString *)title {
    if (title.length == 0) return;
    CGFloat w = ceil([title sizeWithAttributes:@{NSFontAttributeName:self.titleBtn.titleLabel.font}].width);
    [UIView animateWithDuration:0.1 animations:^{
        self.titleView.frame = CGRectMake(0, 0, w+40, 44);
        self.titleBtn.frame = CGRectMake(0, 7, w+40, 30);
        
        [self.titleBtn setTitle:title forState:UIControlStateNormal];
        self.titleBtn.titleFrame = CGRectMake(13, 0, w, 30);
        self.titleBtn.imageFrame = CGRectMake(13+w+5, 12, 10, 10);
    }];
}

//WZMAlbumView代理
- (void)albumViewDidSelectedFinish:(WZMAlbumView *)albumView {
    [self rightItemClick];
}

- (void)albumViewWillPreview:(WZMAlbumView *)albumView atIndexPath:(NSIndexPath *)indexPath {
    WZMPhotoBrowser *photoBrowser = [[WZMPhotoBrowser alloc] init];
    photoBrowser.delegate = self;
    photoBrowser.images = albumView.selectedAlbum.photos;
    photoBrowser.index = indexPath.row;
    photoBrowser.modalPresentationStyle = UIModalPresentationFullScreen;
    
    //计算初始frame
    UICollectionViewCell *cell = [albumView.collectionView cellForItemAtIndexPath:indexPath];
    CGRect rect = [cell.superview convertRect:cell.frame toView:self.view.superview];
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
            rect = [cell.superview convertRect:cell.frame toView:photoBrowser.view.superview];
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
#if WZM_APP
    photoBrowser.wzm_showFromFrame = rect;
    photoBrowser.wzm_showToFrame = [UIScreen mainScreen].bounds;
    photoBrowser.wzm_presentAnimationType = WZMModalAnimationTypeZoom;
#endif
}

//设置dismiss动画
- (void)resetPhotoBrowser:(WZMPhotoBrowser *)photoBrowser dismissRect:(CGRect)rect {
#if WZM_APP
    photoBrowser.wzm_dismissFromFrame = [UIScreen mainScreen].bounds;
    photoBrowser.wzm_dismissToFrame = rect;
    photoBrowser.wzm_dismissAnimationType = WZMModalAnimationTypeZoom;
#endif
}

//相册权限
- (void)checkAlbumAuthorization {
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized){//用户之前已经授权
        [self.albumView reloadData];
        [self updateTitleViewWithTitle:self.albumView.selectedAlbum.title];
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
                    [self updateTitleViewWithTitle:self.albumView.selectedAlbum.title];
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

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showVisualViewAction];
    WZMAlbumModel *albumModel = [self.albumView.allAlbums objectAtIndex:indexPath.row];
    [self updateTitleViewWithTitle:albumModel.title];
    [self.albumView reloadDataWithAlbumModel:albumModel];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albumView.allAlbums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WZMAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[WZMAlbumListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    if (indexPath.row < self.albumView.allAlbums.count) {
        WZMAlbumModel *albumModel = [self.albumView.allAlbums objectAtIndex:indexPath.row];
        NSString *title = [NSString stringWithFormat:@"%@(%@/%@)",albumModel.title,@(albumModel.selectedCount),@(albumModel.count)];
        WZMAlbumPhotoModel *photoModel = albumModel.photos.lastObject;
        if (photoModel) {
            UIImage *image = photoModel.thumbnail;
            if (image) {
                [cell setConfig:image title:title];
            }
            else {
                [WZMAlbumHelper wzm_getThumbnailWithAsset:photoModel.asset photoWidth:34 thumbnail:^(UIImage *photo) {
                    [cell setConfig:photo title:title];
                } cloud:nil];
            }
        }
        else {
            [cell setConfig:nil title:title];
        }
    }
    return cell;
}

#pragma mark - private
///获取图片(UIImage),GIF(NSData)或视频(NSURL)
- (void)photosWithModels:(NSArray<WZMAlbumPhotoModel *> *)models completion:(void(^)(NSArray *originals,NSArray *thumbnails,NSArray *assets))completion {
    NSMutableArray *array1 = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *array2 = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *array3 = [[NSMutableArray alloc] initWithCapacity:0];
    [self photosWithModels:models index:0 originals:array1 thumbnails:array2 assets:array3 completion:completion];
}

- (void)photosWithModels:(NSArray<WZMAlbumPhotoModel *> *)models index:(NSInteger)index originals:(NSMutableArray *)array1 thumbnails:(NSMutableArray *)array2 assets:(NSMutableArray *)array3 completion:(void(^)(NSArray *originals,NSArray *thumbnails,NSArray *assets))completion {
    if (index < models.count) {
        WZMAlbumPhotoModel *model = [models objectAtIndex:index];
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
