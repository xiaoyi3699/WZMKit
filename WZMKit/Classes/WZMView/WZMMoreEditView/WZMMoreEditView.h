//
//  WZMMoreEditView.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2021/3/1.
//  Copyright © 2021 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WZMMoreEditViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface WZMMoreEditView : UIView

@property (nonatomic, weak) id<WZMMoreEditViewDelegate> delegate;

- (BOOL)allowZoom;
- (BOOL)allowRotate;
- (UIImage *)getImage0;
- (UIImage *)getImage1;
- (UIImage *)getImage2;
- (UIImage *)getImage3;

@end

@protocol WZMMoreEditViewDelegate <NSObject>

@optional
- (void)moreEditView:(WZMMoreEditView *)moreEditView didSelectedIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
