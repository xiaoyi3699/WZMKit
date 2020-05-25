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
#import "MKMapView+WZMLocation.h"
#import "WZMPopupAnimator.h"

@interface WZMAlbumLocalView ()

@property (nonatomic, strong) MKMapView *mapView;

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
        [self.mapView setCenterCoordinate:model.coordinate zoomLevel:15 animated:YES];
        [self addSubview:self.mapView];
        
        UIImageView *dwImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
        dwImageView.center = self.mapView.center;
        dwImageView.image = [WZMPublic imageWithFolder:@"album" imageName:@"album_dw.png"];
        [self addSubview:dwImageView];
        
        WZMButton *closeBtn = [[WZMButton alloc] initWithFrame:CGRectMake(w-45.0, 5.0, 40.0, 40.0)];
        closeBtn.backgroundColor = WZM_R_G_B_A(66.0, 66.0, 66.0, 0.5);
        closeBtn.wzm_cornerRadius = 20.0;
        [closeBtn setImage:[WZMPublic imageWithFolder:@"common" imageName:@"close_1.png"] forState:UIControlStateNormal];
        closeBtn.imageFrame = CGRectMake(10.0, 10.0, 20.0, 20.0);
        [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
    }
    return self;
}

- (void)show {
    [[WZMPopupAnimator shareAnimator] popUpView:self animationStyle:WZMAnimationStyleOutFromCenterAnimation duration:0.5 completion:nil];
}

- (void)closeBtnClick:(UIButton *)btn {
    [[WZMPopupAnimator shareAnimator] dismiss:YES completion:nil];
}

@end
