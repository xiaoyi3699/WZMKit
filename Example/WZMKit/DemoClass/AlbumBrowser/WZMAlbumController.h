//
//  WZMAlbumController.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/12.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMAlbumConfig.h"
@protocol WZMAlbumControllerDelegate;

@interface WZMAlbumController : UIViewController

///配置
@property (nonatomic, readonly, strong) WZMAlbumConfig *config;
///代理
@property (nonatomic, weak) id<WZMAlbumControllerDelegate> pickerDelegate;

- (instancetype)initWithConfig:(WZMAlbumConfig *)config;

@end

@protocol WZMAlbumControllerDelegate <NSObject>

@optional
- (void)albumControllerDidCancel:(WZMAlbumController *)albumController;
- (void)albumController:(WZMAlbumController *)albumController didSelectedPhotos:(NSArray *)photos;

@end
