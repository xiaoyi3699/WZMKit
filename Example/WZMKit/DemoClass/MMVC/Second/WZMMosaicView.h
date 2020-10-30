//
//  KKMasaicView.h
//  WWImageEdit
//
//  Created by 邬维 on 2017/1/11.
//  Copyright © 2017年 kook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZMMosaicView : UIView

///图片
@property (nonatomic, strong) UIImage *image;
///马赛克图片 可为空
@property (nonatomic, strong) UIImage *mosaicImage;
///马赛克线宽
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong, readonly) NSMutableArray *linesArray;

- (void)recover;
- (void)backforward;

@end
