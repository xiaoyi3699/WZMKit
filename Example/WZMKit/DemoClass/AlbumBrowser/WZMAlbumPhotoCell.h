//
//  WZMAlbumPhotoCell.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMAlbumPhotoModel.h"
@protocol WZMAlbumPhotoCellDelegate;

@interface WZMAlbumPhotoCell : UICollectionViewCell

@property (nonatomic, readonly, strong) WZMAlbumPhotoModel *model;
@property (nonatomic, weak) id<WZMAlbumPhotoCellDelegate> delegate;

- (void)setConfig:(WZMAlbumPhotoModel *)photoModel;

@end

@protocol WZMAlbumPhotoCellDelegate <NSObject>

@optional
- (void)albumPhotoCell:(WZMAlbumPhotoCell *)cell didSelected:(BOOL)selected;

@end
