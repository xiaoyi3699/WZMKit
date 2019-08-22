//
//  WZMAlbumNavigationController.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/12.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMAlbumConfig.h"
@protocol WZMAlbumNavigationControllerDelegate;

@interface WZMAlbumNavigationController : UINavigationController

///配置
@property (nonatomic, readonly, strong) WZMAlbumConfig *config;
///代理
@property (nonatomic, weak) id<WZMAlbumNavigationControllerDelegate> pickerDelegate;

- (instancetype)initWithConfig:(WZMAlbumConfig *)config;

@end

@protocol WZMAlbumNavigationControllerDelegate <NSObject>

@optional
- (void)albumNavigationControllerDidCancel:(WZMAlbumNavigationController *)albumNavigationController;
- (void)albumNavigationController:(WZMAlbumNavigationController *)albumNavigationController didSelectedPhotos:(NSArray *)photos;

@end
