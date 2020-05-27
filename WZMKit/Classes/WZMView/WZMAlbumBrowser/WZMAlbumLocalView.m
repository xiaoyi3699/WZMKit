//
//  WZMAlbumLocalView.m
//  git_XNLocation
//
//  Created by Zhaomeng Wang on 2020/5/25.
//  Copyright © 2020 Zhaomeng Wang. All rights reserved.
//

#import "WZMAlbumLocalView.h"
#import "WZMButton.h"
#import "WZMMacro.h"
#import "UIView+wzmcate.h"
#import <MapKit/MapKit.h>
#import <Photos/Photos.h>
#import "MKMapView+WZMLocation.h"
#import "WZMPopupAnimator.h"
#import "NSDateFormatter+wzmcate.h"

@interface WZMAlbumLocalView ()<MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *labels;

@end

@implementation WZMAlbumLocalView

- (instancetype)initWithModel:(WZMAlbumPhotoModel *)model {
    CGFloat w = WZM_SCREEN_WIDTH-60.0;
    CGFloat h = 500.0;
    self = [super initWithFrame:CGRectMake(30.0, (WZM_SCREEN_HEIGHT-h)/2.0-20.0, w, h)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.wzm_cornerRadius = 5.0;
        CGRect mapRect = self.bounds;
        mapRect.size.height -= 150.0;
        self.mapView = [[MKMapView alloc] initWithFrame:mapRect];
        //设置用户的跟踪模式
        self.mapView.userTrackingMode = MKUserTrackingModeNone;
        //设置标准地图
        self.mapView.mapType = MKMapTypeStandard;
        // 不显示罗盘和比例尺
        if (@available(iOS 9.0, *)) {
            self.mapView.showsCompass = NO;
            self.mapView.showsScale = NO;
        }
        self.mapView.delegate = self;
        [self.mapView setCenterCoordinate:model.coordinate zoomLevel:15 animated:YES];
        [self addSubview:self.mapView];
        
        //添加定位图标
        MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
        pointAnnotation.coordinate = model.coordinate;
        [self.mapView addAnnotation:pointAnnotation];
        
        WZMButton *closeBtn = [[WZMButton alloc] initWithFrame:CGRectMake(w-45.0, 5.0, 40.0, 40.0)];
        closeBtn.backgroundColor = WZM_R_G_B_A(66.0, 66.0, 66.0, 0.5);
        closeBtn.wzm_cornerRadius = 20.0;
        [closeBtn setImage:[WZMPublic imageWithFolder:@"common" imageName:@"close_1.png"] forState:UIControlStateNormal];
        closeBtn.imageFrame = CGRectMake(10.0, 10.0, 20.0, 20.0);
        [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        
        if (model.orgFilename == nil) {
            model.orgFilename = [model.asset valueForKey:@"filename"];
            if (model.orgFilename == nil) {
                model.orgFilename = @"未知";
            }
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.networkAccessAllowed = NO;
            options.resizeMode = PHImageRequestOptionsResizeModeNone;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            PHImageManager * imageManager = [PHImageManager defaultManager];
            [imageManager requestImageDataForAsset:model.asset options:options resultHandler:^(NSData * imageData, NSString * dataUTI, UIImageOrientation orientation, NSDictionary * info) {
                model.cacheSize = imageData.length;
                UIImage *image = [UIImage imageWithData:imageData];
                model.imageSize = image.size;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setupImageInfo:model];
                });
            }];
        }
        CGFloat spacing = 15.0;
        CGFloat labelW = (w-spacing*3)/2.0;
        self.labels = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 8; i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(spacing+i%2*(labelW+spacing), self.mapView.wzm_maxY+10.0+i/2*30.0, labelW, 33.0)];
            label.textColor = [UIColor darkGrayColor];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:10.0];
            [self addSubview:label];
            [self.labels addObject:label];
        }
        [self setupImageInfo:model];
    }
    return self;
}

- (void)show {
    [[WZMPopupAnimator shareAnimator] popUpView:self animationStyle:WZMAnimationStyleOutFromCenterAnimation duration:0.5 completion:nil];
}

- (void)closeBtnClick:(UIButton *)btn {
    [[WZMPopupAnimator shareAnimator] dismiss:YES completion:nil];
}

- (void)setupImageInfo:(WZMAlbumPhotoModel *)model {
    NSArray *names = [model.orgFilename componentsSeparatedByString:@"."];
    for (NSInteger i = 0; i < self.labels.count; i ++) {
        UILabel *label = [self.labels objectAtIndex:i];
        if (i == 0) {
            label.text = [NSString stringWithFormat:@"名称：%@",names.firstObject];
        }
        else if (i == 1) {
            label.text = [NSString stringWithFormat:@"格式：%@",names.lastObject];
        }
        else if (i == 2) {
            label.text = [NSString stringWithFormat:@"创建日期：%@",[self getTimeStringByDate:model.creationDate]];
        }
        else if (i == 3) {
            label.text = [NSString stringWithFormat:@"修改日期：%@",[self getTimeStringByDate:model.modificationDate]];
        }
        else if (i == 4) {
            CGFloat size = model.cacheSize/1024.0;
            if (size >= 1024) {
                label.text = [NSString stringWithFormat:@"大小：%.2fM",size/1024.0];
            }
            else {
                label.text = [NSString stringWithFormat:@"大小：%.1fKB",size];
            }
        }
        else if (i == 5) {
            label.text = [NSString stringWithFormat:@"尺寸：%@x%@",@((int)model.imageSize.width),@((int)model.imageSize.height)];
        }
        else if (i == 6) {
            label.text = [NSString stringWithFormat:@"经度：%@",@(model.coordinate.longitude)];
        }
        else {
            label.text = [NSString stringWithFormat:@"纬度：%@",@(model.coordinate.latitude)];
        }
    }
}

- (NSString *)getTimeStringByDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [NSDateFormatter wzm_dateFormatter:@"yyyy-MM-dd"];
    NSString *timeString = [dateFormatter stringFromDate:date];
    return timeString;
}

//自定义大头针
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        static NSString *reuseIndetifier = @"annotation";
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.image = [WZMPublic imageWithFolder:@"album" imageName:@"album_dw@3x.png"];
        return annotationView;
    }
    return nil;
}

@end
