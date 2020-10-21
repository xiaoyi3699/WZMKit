//
//  ViewController.h
//  Image
//
//  Created by aasjdi dau on 2019/3/27.
//  Copyright © 2019 aasjdi dau. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WZMAlbumConfig;
@protocol WZMAlbumImageEditControllerDelegate;

@interface WZMAlbumImageEditController : UIViewController

@property (nonatomic, weak) id<WZMAlbumImageEditControllerDelegate> delegate;

- (instancetype)initWithOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets config:(WZMAlbumConfig *)config;

@end

@protocol WZMAlbumImageEditControllerDelegate <NSObject>

@optional
- (void)albumImageEditController:(WZMAlbumImageEditController *)albumImageEditController handleOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets;

@end
