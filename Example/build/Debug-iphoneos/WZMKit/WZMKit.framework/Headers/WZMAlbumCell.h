//
//  WZMAlbumCell.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMAlbumPhotoModel.h"
#import "WZMAlbumConfig.h"
@protocol WZMAlbumCellDelegate;

@interface WZMAlbumCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<WZMAlbumCellDelegate> delegate;

- (void)setConfig:(WZMAlbumConfig *)config model:(WZMAlbumPhotoModel *)model;

@end

@protocol WZMAlbumCellDelegate <NSObject>

@optional
- (void)albumPhotoCellDidSelectedIndexBtn:(WZMAlbumCell *)cell;

@end
