//
//  WZMAlbumEditViewController.h
//  WZMKit
//
//  Created by Zhaomeng Wang on 2020/6/3.
//

#import <UIKit/UIKit.h>
@class WZMAlbumConfig;
@protocol WZMAlbumEditViewControllerDelegate;

@interface WZMAlbumEditViewController : UIViewController

@property (nonatomic, weak) id<WZMAlbumEditViewControllerDelegate> delegate;

- (instancetype)initWithOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets config:(WZMAlbumConfig *)config;

@end

@protocol WZMAlbumEditViewControllerDelegate <NSObject>

@optional
- (void)albumEditViewController:(WZMAlbumEditViewController *)albumEditViewController handleOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets;

@end
