//
//  WZMAlbumCell.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMAlbumModel.h"
#import "WZMAlbumConfig.h"
@protocol WZMAlbumCellDelegate;

#define WZM_ALBUM_COLOR [UIColor redColor]
@interface WZMAlbumCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<WZMAlbumCellDelegate> delegate;

- (void)setConfig:(WZMAlbumConfig *)config model:(WZMAlbumModel *)model;

@end

@protocol WZMAlbumCellDelegate <NSObject>

@optional
- (void)albumPhotoCellWillPreview:(WZMAlbumCell *)cell;
- (void)albumPhotoCellDidSelectedPreview:(WZMAlbumCell *)cell;

@end
