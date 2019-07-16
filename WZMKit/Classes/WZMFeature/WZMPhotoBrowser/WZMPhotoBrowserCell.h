//
//  WZMPhotoBrowserCell.h
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2017/12/13.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMPhoto.h"

@protocol WZMPhotoBrowserCellDelegate;

@interface WZMPhotoBrowserCell : UICollectionViewCell

@property (nonatomic, weak) id<WZMPhotoBrowserCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)setImage:(id)image;

- (void)willDisplay;
- (void)didEndDisplay;

@end

@protocol WZMPhotoBrowserCellDelegate <NSObject>

@optional
- (void)photoBrowserCell:(WZMPhotoBrowserCell *)photoBrowserCell
        clickAtIndexPath:(NSIndexPath *)indexPath
                 content:(id)content
                   isGif:(BOOL)isGif
                    type:(LLGestureRecognizerType)type;

@end
