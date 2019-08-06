//
//  WZMAlbumBrowserController.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZMAlbumBrowserController : UIViewController

@property (nonatomic, assign) CGRect albumFrame;
///列数, 默认4, 最大5
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) BOOL allowPickingImage;
@property (nonatomic, assign) BOOL allowPickingVideo;

@end
