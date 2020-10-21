//
//  WZMAlbumVideoEditController.h
//  WZMKit
//
//  Created by Zhaomeng Wang on 2020/6/3.
//

#import <UIKit/UIKit.h>
@class WZMAlbumConfig;
@protocol WZMAlbumVideoEditControllerDelegate;

@interface WZMAlbumVideoEditController : UIViewController

@property (nonatomic, weak) id<WZMAlbumVideoEditControllerDelegate> delegate;

- (instancetype)initWithOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets config:(WZMAlbumConfig *)config;

@end

@protocol WZMAlbumVideoEditControllerDelegate <NSObject>

@optional
- (void)albumVideoEditController:(WZMAlbumVideoEditController *)albumVideoEditController handleOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets;

@end
