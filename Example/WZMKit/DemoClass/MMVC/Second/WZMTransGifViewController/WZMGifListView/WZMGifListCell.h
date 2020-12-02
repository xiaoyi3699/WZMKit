//
//  WZMGifListCell.h
//  ThirdApp
//
//  Created by Zhaomeng Wang on 2020/8/20.
//  Copyright © 2020 富秋. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZMGifListCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)beginShake;
- (void)stopShake;
- (void)setConfig:(id)image;

@end

NS_ASSUME_NONNULL_END
