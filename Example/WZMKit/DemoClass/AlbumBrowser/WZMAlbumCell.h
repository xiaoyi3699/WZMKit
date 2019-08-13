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

@interface WZMAlbumCell : UICollectionViewCell

@property (nonatomic, weak) id<WZMAlbumCellDelegate> delegate;

- (void)setConfig:(WZMAlbumConfig *)config photoModel:(WZMAlbumModel *)photoModel;

@end

@protocol WZMAlbumCellDelegate <NSObject>

@optional
- (void)albumPhotoCellDidSelected:(WZMAlbumCell *)cell;
- (void)albumPhotoCellWillShowPreview:(WZMAlbumCell *)cell;
- (void)albumPhotoCellDidSelectedPreview:(WZMAlbumCell *)cell;

@end
