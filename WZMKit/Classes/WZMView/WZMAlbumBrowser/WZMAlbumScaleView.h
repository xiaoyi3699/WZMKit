//
//  WZMAlbumScaleView.h
//  ThirdApp
//
//  Created by Zhaomeng Wang on 2020/8/20.
//  Copyright © 2020 富秋. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WZMAlbumScaleViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface WZMAlbumScaleView : UIView

@property (nonatomic, weak) id<WZMAlbumScaleViewDelegate> delegate;

@end

@protocol WZMAlbumScaleViewDelegate <NSObject>

@optional
- (void)scaleView:(WZMAlbumScaleView *)scaleView didChangeScale:(CGFloat)scale;

@end

NS_ASSUME_NONNULL_END
